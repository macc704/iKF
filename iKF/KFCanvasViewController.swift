//
//  KFCanvasViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-30.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFCanvasViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var canvasContainer: UIView!
    
    @IBOutlet weak var viewsButton: UIBarButtonItem!
    
    private var canvasView = KFCanvasView();
    private let creationToolView = KFCreationToolView(frame: CGRect(x:0, y:0, width:120, height:35));
    private var imagePickerManager:KFImagePicker?;
    
    private var user:KFUser?;
    private var registration:KFRegistration?;
    private var postRefs:[String: KFReference] = [:];
    private var postRefViews:[String: KFPostRefView] = [:];
    private var currentView:KFView?
    private var reusableRefViews:[String: KFPostRefView] = [:];
    private var cometManager:KFMobileCometManager = KFMobileCometManager();
    
    private var initialized = false;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(nibName: "KFCanvasViewController", bundle: nil);
        imagePickerManager = KFImagePicker(mainController:self);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //canvasView.setSize(canvasContainer.frame.size);//moved to viewDidAppear and rotation
        canvasView.setCanvasSize(4000, height:3000);
        canvasView.doubleTapHandler = {p in
            self.creationToolView.center = p;
            self.showHalo(self.creationToolView);
        };
        canvasContainer.addSubview(canvasView);
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        canvasView.setSize(canvasContainer.frame.size);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        canvasView.setSize(canvasContainer.frame.size);
        if(initialized == false){
            go();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        //        cometManager.stop();
    }
    
    func setKFRegistration(registration:KFRegistration){
        self.registration = registration;
    }
    
    func go(){
        let loading = KFLoadingView();
        loading.showOnView(self.canvasView);
        self.cometManager.busInitialized = {
            KFAppUtils.executeInBackThread({
                self.user = KFService.getInstance().currentUser;
                let enterResult = KFService.getInstance().enterCommunity(self.registration!);
                if(enterResult == false){
                    return;//alert
                }
                KFService.getInstance().refreshMembers();//order imporatnt
                KFService.getInstance().refreshViews();//order important
                KFAppUtils.executeInGUIThread({
                    self.cometManager.subscribeCommunityEvent(self.registration!.community.guid);
                    return;
                });
                self.setCurrentView(KFService.getInstance().currentRegistration.community.views.array[0]);
                self.initialized = true;
                KFAppUtils.executeInGUIThread({
                    loading.hide();
                });
            });
        }
        self.cometManager.messageReceived = self.messageReceived;
        let service = KFService.getInstance();
        self.cometManager.start(service.getHost(), username: service.username!, password: service.password!);
    }
    
    func messageReceived(type:String?, method:String?, target:String?){
        //println("messageReceived: \(type), \(method), \(target)");
        let service = KFService.getInstance();
        
        if(type == "postref" && method == "create"){
            let ref = service.getPostRef(target!);
            //service.updateBuildOnsInPost(ref!.post!); // not necessary any more
            self.addReference(ref!);
            self.addBuildsOn(ref!);
        }
        if(type == "postref" && method == "update"){
            let newRef = service.getPostRef(target!);
            //println("postref-update-\(ref)");
            let refView = self.postRefViews[newRef!.guid];
            if(refView == nil){
                println("warning: ref is null =\(target)");
                return;
            }
            refView!.getModel().marge(newRef!);
            refView!.getModel().notify();
            //refView!.updateFromModel();
            self.requestConnectionsRepaint();
        }
        if(type == "postref" && method == "delete"){
            let refView = self.postRefViews[target!];
            if(refView != nil){
                deletePostRef(refView!, fromUI:false);
            }
        }
        if(type == "post" && method == "update"){
            let newPost = service.getPost(target!);
            
            //設計ミス　あとで変更すること
            let refView = self.postRefViews[target!];//ずる
            if(refView == nil){
                println("warning: ref is null =\(target)");
                return;
            }else{
                refView!.getModel().post!.marge(newPost!);
                refView!.getModel().post!.notify();
                //refView!.updateFromModel();
            }
            //println("\((post! as KFNote).guid), \(post!.beenRead)");
            //refView!.getModel().post?.merge(post!);
            //refView!.getModel().post?.notify();
            //refView!.updateFromModel();
        }
        if(type == "view" && method == "create"){
            KFService.getInstance().refreshViews();
        }
        if(type == "view" && method == "delete"){
            KFService.getInstance().refreshViews();
        }
    }
    
    func addNote(ref:KFReference){
        if(!(ref.post is KFNote)){
            //    [NSException raise:@"iKFConnectionException" format:@"Illegal addNote"];
            return;
        }
        
        //self.hideHalo();
        
        var postRefView:KFNoteRefView!;
        
        if(self.reusableRefViews[ref.guid] != nil ){
            postRefView = reusableRefViews[ref.guid] as KFNoteRefView;
            postRefView.setModel(ref);
        }else{
            postRefView = KFNoteRefView(controller: self, ref: ref);
        }
        
        postRefView.updateFromModel();
        postRefViews[ref.guid] = postRefView;
        postRefViews[ref.post!.guid] = postRefView;//ちょっとずる
        canvasView.noteLayer.addSubview(postRefView!);
    }
    
    func addDrawing(ref:KFReference){
        if(!(ref.post is KFDrawing)){
            //    [NSException raise:@"iKFConnectionException" format:@"Illegal addDrawing"];
            return;
        }
        
        //self.hideHalo();
        
        var postRefView:KFDrawingRefView!;
        
        if(self.reusableRefViews[ref.guid] != nil ){
            postRefView = reusableRefViews[ref.guid] as KFDrawingRefView;
            postRefView.setModel(ref);
        }else{
            postRefView = KFDrawingRefView(controller: self, ref: ref);
        }
        
        postRefView.updateFromModel();
        postRefViews[ref.guid] = postRefView;
        postRefViews[ref.post!.guid] = postRefView;//ちょっとずる
        canvasView.drawingLayer.addSubview(postRefView!);
    }
    
    func addViewRef(ref:KFReference){
        if(!(ref.post is KFView)){
            //[NSException raise:@"iKFConnectionException" format:@"Illegal ViewRef"];
        }
        
        //self.hideHalo();
        let postRefView = KFViewRefView(controller: self, ref: ref);
        canvasView.noteLayer.addSubview(postRefView);
        postRefViews[ref.guid] = postRefView;
    }
    
    func addBuildsOn(ref:KFReference){
        if(!(ref.post is KFNote)){
            //    [NSException raise:@"iKFConnectionException" format:@"Illegal addNote"];
            return;
        }
        
        let note = ref.post as KFNote;
        if(note.buildsOn != nil){
            let fromRefView = postRefViews[note.guid]
            let toRefView = postRefViews[note.buildsOn!.guid];//ちょっとずる
            if(fromRefView != nil && toRefView != nil){
                canvasView.connectionLayer.addConnection(fromRefView!, to: toRefView!);
            }
        }
    }
    
    func showHalo(view:UIView){
        let halo = KFHalo(controller: self, target: view);
        self.canvasView.showHalo(halo);
    }
    
    func hideHalo(){
        self.canvasView.hideHalo();
    }
    
    private func createNote(){
        self.createNote(CGPoint(x: 50, y: 50));
    }
    
    func createNote(p:CGPoint){
        self.createNote(p, buildsOn: nil);
    }
    
    func createNote(p:CGPoint, buildsOn:KFPostRefView?){
        self.hideHalo();
        let viewId = self.getCurrentView().guid;
        KFAppUtils.executeInBackThread({
            KFService.getInstance().createNote(viewId, buildsOn: buildsOn?.getModel(), location: p);
            return;
        });
    }
    
    func createWebNote(p:CGPoint, url:String, title:String){
        self.hideHalo();
        let viewId = self.getCurrentView().guid;
        KFAppUtils.executeInBackThread({
            var body = "<html><head>";
            body = body + "<meta http-equiv='refresh' content='0; URL="+url+"'>";
            body = body + "</head><body></body></html>";
            KFService.getInstance().createNote(viewId, location: p, title:title, body: body);
            return;
        });
    }
    
    func deletePostRef(refView:KFPostRefView, fromUI:Bool){
        self.hideHalo();
        
        refView.removeFromSuperview();
        canvasView.connectionLayer.noteRemoved(refView);
        
        if(fromUI == true){
            let viewId = self.getCurrentView().guid;
            KFAppUtils.executeInBackThread({
                KFService.getInstance().deletePostRef(viewId, postRef: refView.getModel());
                return;
            });
        }
    }
    
    func updatePostRef(refView:KFPostRefView){
        let viewId = self.getCurrentView().guid;
        KFAppUtils.executeInBackThread({
            KFService.getInstance().updatePostRef(viewId, postRef: refView.getModel());
            return;
        });
    }
    
    //?? Refactoring??
    func postLocationChanged(postView:KFPostRefView){
        postView.getModel().location = postView.frame.origin;
        self.updatePostRef(postView);
    }
    
    func requestConnectionsRepaint(){
        self.canvasView.connectionLayer.requestRepaint();
    }
    
    func setCurrentView(view:KFView){
        if(self.currentView == view){
            return;//already the view
        }
        
        //new view
        KFAppUtils.executeInGUIThread({
            KFWebView.clearPostInstances();
            self.currentView = view;
            self.navBar.topItem!.title = self.currentView!.title;
            self.refreshAllPostsAsync();
            let res = self.cometManager.subscribeViewEvent(self.getCurrentView().guid);
        });
    }
    
    func getCurrentView() -> KFView{
        return self.currentView!;
    }
    
    private func startComet(threadNumber:Int){
        
    }
    
    private func refreshAllPostsAsync(){
        //        KFAppUtils.executeInBackThread({
        var task:(()->()) = {
            let viewId = self.getCurrentView().guid;
            let newRefs = KFService.getInstance().getPostRefs(viewId);
            KFAppUtils.executeInGUIThread({
                self.refreshPosts(newRefs);
            });
            return;
        };
        
        KFAppUtils.asyncExecWithLoadingView(self.canvasView, task, nil);
        
        //        });
    }
    
    private func addReference(ref:KFReference){
        if(ref.isHidden()){
            return;
        }
        
        if(ref.post is KFNote){
            self.addNote(ref);
        }else if(ref.post is KFDrawing){
            self.addDrawing(ref);
        }else if(ref.post is KFView){
            self.addViewRef(ref);
        }else{
            KFAppUtils.debug("unknown post=\(ref.post)");
        }
    }
    
    private func refreshPosts(newRefs:[String:KFReference]){
        self.reusableRefViews = self.postRefViews;
        self.clearViews();
        self.postRefs = newRefs;
        
        for each in self.postRefs.values{
            addReference(each);
        }
        
        for each in self.postRefs.values{
            if(each.isHidden()){
                continue;
            }
            
            if(each.post is KFNote){
                self.addBuildsOn(each);
            }
        }
        
        self.reusableRefViews = [:];
    }
    
    private func clearViews(){
        self.postRefViews = [:];
        self.canvasView.clearViews();
    }
    
    private func showViewSelection(){
        let viewSelectionController = KFViewSelectionController();
        viewSelectionController.models = KFService.getInstance().currentRegistration.community.views.array;
        viewSelectionController.selectedHandler = {(model:KFModel) in
            self.setCurrentView(model as KFView);
        }
        KFPopoverManager.getInstance().openInPopoverFromBarButton(self.viewsButton, controller: viewSelectionController);
    }
    
    func openNoteEditController(note:KFNote, mode:String){
        let noteController = KFCompositeNoteViewController();
        if(mode == "edit"){
            noteController.toEditMode();
        }else if(mode == "read"){
            noteController.toReadMode();
        }
        noteController.setNote(note, viewId: self.getCurrentView().guid);
        self.presentViewController(noteController, animated: true, completion: nil);
    }
    
    func openPostById(guid:String, frame:CGRect){
        let view = postRefViews[guid];
        if(view != nil){
            let refview = view! as KFPostRefView;
            openPostViewer0(refview.getModel().post!, frame: frame, refView:refview);
        }else{
            KFAppUtils.showAlert("not implemented", msg: "ref to post not found in this view guid=\(guid)");
            //not implemented
        }
    }
    
    func openPost(postRefView:KFPostRefView){
        //openPopupViewer(postRefView);
        self.openPostViewer(postRefView.getModel().post!, from: postRefView, refView:postRefView);
    }
    
    //ref is temporary
    func openPostViewer(post:KFPost, from:UIView, refView:KFPostRefView? = nil){
        let frame = postViewerRect(from);
        openPostViewer0(post, frame: frame, refView: refView);
    }
    
    func openPostViewer0(post:KFPost, frame:CGRect, refView:KFPostRefView? = nil){
        let browser = KFWebBrowserView(showToolBar: false);
        browser.frame = frame;
        browser.kfSetNote(post as KFNote);
        browser.noteRef = refView; //temporary
        browser.mainController = self;
        self.canvasView.windowsLayer.addSubview(browser);
        browser.doubleTapHandler = {
            self.showHalo(browser);
        }
    }
    
    private func postViewerRect(from:UIView) -> CGRect{
        let orient = UIDevice.currentDevice().orientation;
        
        var width:CGFloat = 400;
        var height:CGFloat = 600;
        if(orient == UIDeviceOrientation.LandscapeLeft || orient == UIDeviceOrientation.LandscapeRight){
            width = 500;
            height = 400;
        }
        var x = from.center.x;
        var y = from.center.y;
        
        let screenW = canvasView.frame.size.width;
        let screenH = canvasView.frame.size.height;
        
        let fromCenter = CGPointMake(from.frame.size.width/2, from.frame.size.height/2);
        let absP = from.convertPoint(fromCenter, toView: canvasView);
        
        // horizontal - default right
        if(absP.x > screenW/2){// located in right
            //to left
            x -= width;
        }else{
            
        }
        
        // vertical - default bottom
        if(absP.y > screenH*2/3){ //located in bottom
            //to top
            y -= height;
        }else if(absP.y > screenH/3){//located inmiddle
            //to middle
            y -= height / 2 ;
        }
        
        //adjust
        if(x < 30){
            x = 30;
        }
        if(y < 30){
            y = 30;
        }
        
        return CGRectMake(x, y, width, height);
    }
    
    //    private func openPopupViewer(postRefView:KFPostRefView){
    //        let notePopupController = iKFNotePopupViewController();
    //        notePopupController.note = (postRefView.model.post as KFNote);
    //        notePopupController.kfViewController = self;
    //        notePopupController.preferredContentSize = notePopupController.view.frame.size;
    //        KFPopoverManager.getInstance().openInPopover(postRefView, controller: notePopupController);
    //    }
    
    func openBrowser(p:CGPoint, size:CGSize = CGSize(width: 500, height: 600)){
        let browser = KFWebBrowserView();
        //let p = self.canvasView.translateToCanvas(CGPointMake(50, 50));
        browser.frame = CGRect(x: p.x, y:p.y, width: size.width, height:size.height);
        browser.mainController = self;
        //println(browser.frame);
        browser.setURL("http://www.google.com");
        self.canvasView.windowsLayer.addSubview(browser);
        browser.doubleTapHandler = {
            self.showHalo(browser);
        }
        self.hideHalo();
    }
    
    func openImageSelectionViewer(popOverLoc:UIView, creatingPoint:CGPoint){
        let pickerController = imagePickerManager!.createImagePicker();
        imagePickerManager!.loc = creatingPoint;
        KFPopoverManager.getInstance().openInPopover(popOverLoc, controller: pickerController);
    }
    
    
    /* event handlers */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func exitPressed(sender: AnyObject) {
        KFWebView.clearAllInstances();
        cometManager.stop();
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func viewsButtonPressed(sender: AnyObject) {
        if(initialized == false){
            KFAppUtils.showAlert("Warning", msg: "Not initialized yet");
            return;
        }
        self.showViewSelection();
    }
    
    @IBAction func updatePressed(sender: AnyObject) {
        if(initialized == false){
            KFAppUtils.showAlert("Warning", msg: "Not initialized yet");
            return;
        }
        self.refreshAllPostsAsync();
    }
    
    func suppressScroll(){
        canvasView.suppressScroll();
    }
    
    func unlockSuppressScroll(){
        canvasView.unlockSuppressScroll();
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
