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
    private let creationToolView = KFCreationToolView(frame: CGRect(x:0, y:0, width:90, height:35));
    private var imagePickerManager:KFImagePicker?;
    
    private var user:KFUser?;
    private var registration:KFRegistration?;
    private var postRefs:[String: KFReference] = [:];
    private var postRefViews:[String: KFPostRefView] = [:];
    private var views:[KFView] = [];
    private var currentView:KFView?
    private var reusableRefViews:[String: KFPostRefView] = [:];
    
    private var initialized = false;
    private var cometThreadNumber:Int = 0;
    private var cometVersion:Int = 0;
    
    required init(coder aDecoder: NSCoder!) {
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
        if(self.initialized){
            self.cometThreadNumber++;
            self.startComet(self.cometThreadNumber);
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        canvasView.setSize(canvasContainer.frame.size);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        self.cometThreadNumber++;
    }
    
    func go(registration:KFRegistration){
        KFAppUtils.executeInBackThread({
            self.registration = registration;
            self.user = KFService.getInstance().getCurrentUser();
            let enterResult = KFService.getInstance().enterCommunity(registration);
            if(enterResult == false){
                //alert
                return;
            }
            
            self.views = KFService.getInstance().refreshViews();
            self.initialized = true;
            self.setCurrentView(self.views[0]);
            //set current view do below
            //self.cometThreadNumber++;
            //self.startComet(self.cometThreadNumber);
        })
    }
    
    func addNote(ref:KFReference){
        if(!(ref.post is KFNote)){
            //    [NSException raise:@"iKFConnectionException" format:@"Illegal addNote"];
            return;
        }
        
        //self.hideHalo();
        
        var postRefView:KFNoteRefView?;
        
        if(self.reusableRefViews[ref.guid] != nil ){
            postRefView = reusableRefViews[ref.guid] as? KFNoteRefView;
            postRefView!.model = ref;
        }else{
            postRefView = KFNoteRefView(controller: self, ref: ref);
        }
        
        postRefView?.updateFromModel();
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
        
        var postRefView:KFDrawingRefView?;
        
        if(self.reusableRefViews[ref.guid] != nil ){
            postRefView = reusableRefViews[ref.guid] as? KFDrawingRefView;
            postRefView!.model = ref;
        }else{
            postRefView = KFDrawingRefView(controller: self, ref: ref);
        }
        
        postRefView?.updateFromModel();
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
            canvasView.connectionLayer.addConnection(fromRefView!, to: toRefView!);
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
            KFService.getInstance().createNote(viewId, buildsOn: buildsOn?.model, location: p);
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
    
    func deletePostRef(refView:KFPostRefView){
        self.hideHalo();
        
        refView.removeFromSuperview();
        canvasView.connectionLayer.noteRemoved(refView);
        
        let viewId = self.getCurrentView().guid;
        KFAppUtils.executeInBackThread({
            self.cometVersion++;
            KFService.getInstance().deletePostRef(viewId, postRef: refView.model);
        });
    }
    
    func updatePostRef(refView:KFPostRefView){
        let viewId = self.getCurrentView().guid;
        KFAppUtils.executeInBackThread({
            self.cometVersion++;
            KFService.getInstance().updatePostRef(viewId, postRef: refView.model);
        });
    }
    
    //?? Refactoring??
    func postLocationChanged(postView:KFPostRefView){
        postView.model.location = postView.frame.origin;
        self.updatePostRef(postView);
    }
    
    func requestConnectionsRepaint(){
        self.canvasView.connectionLayer.requestRepaint();
    }
    
    //    func openNoteEditController(: (KFNote*)note mode: (NSString*)mode;
    
    //    func update(){
    //
    //    }
    
    func setCurrentView(view:KFView){
        if(self.currentView == view){
            return;//already the view
        }
        
        self.currentView = view;
        KFAppUtils.executeInGUIThread({
            self.navBar.topItem.title = self.currentView!.title;
        });
        self.cometThreadNumber++;
        self.startComet(self.cometThreadNumber);
    }
    
    func getCurrentView() -> KFView{
        return self.currentView!;
    }
    
    private func startComet(threadNumber:Int){
        KFAppUtils.executeInBackThread({
            var viewId = self.getCurrentView().guid;
            self.cometVersion = -1;
            while(true){
                if(viewId != self.getCurrentView().guid){
                    viewId = self.getCurrentView().guid;
                    self.cometVersion = -1;
                }
                let newVersion = KFService.getInstance().getNextViewVersionAsync(viewId, currentVersion: self.cometVersion);
                if(threadNumber != self.cometThreadNumber){
                    break;
                }
                if(newVersion == -1){
                    KFAppUtils.debug("error at newVersion");
                    break;
                }
                KFAppUtils.debug("newVersion=\(newVersion)");
                if(newVersion > self.cometVersion){
                    self.cometVersion = newVersion;
                    KFAppUtils.debug("refresh request");
                    self.refreshAllPostsAsync();
                    NSThread.sleepForTimeInterval(2.0);
                    KFAppUtils.debug("wake up");
                }else if(newVersion < self.cometVersion){
                    KFAppUtils.debug("ERROR: newVersion < cometVersion");
                    self.cometVersion = newVersion;
                }
            }
        })
        KFAppUtils.debug("comet stopped number=\(threadNumber)");
        
    }
    
    private func refreshAllPostsAsync(){
        KFAppUtils.executeInBackThread({
            let viewId = self.getCurrentView().guid;
            let newRefs = KFService.getInstance().getPosts(viewId);
            KFAppUtils.executeInGUIThread({
                self.refreshPosts(newRefs);
            });
        });
    }
    
    private func refreshPosts(newRefs:[String:KFReference]){
        self.reusableRefViews = self.postRefViews;
        self.clearViews();
        self.postRefs = newRefs;
        
        for each in self.postRefs.values{
            if(each.isHidden()){
                continue;
            }
            
            if(each.post is KFNote){
                self.addNote(each);
            }else if(each.post is KFDrawing){
                self.addDrawing(each);
            }else if(each.post is KFView){
                self.addViewRef(each);
            }else{
                KFAppUtils.debug("unknown post=\(each.post)");
            }
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
        viewSelectionController.views = self.views;
        let popController = UIPopoverController(contentViewController: viewSelectionController);
        viewSelectionController.selectedHandler = {(view:KFView) in
            popController.dismissPopoverAnimated(true);
            self.setCurrentView(view);
        }
        popController.presentPopoverFromBarButtonItem(self.viewsButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true);
    }
    
    func openNoteEditController(note:KFNote, mode:String){
        let noteController = iKFCompositeNoteViewController();
        if(mode == "edit"){
            noteController.toEditMode();
        }else if(mode == "read"){
            noteController.toReadMode();
        }
        noteController.setNote(note, andViewId: self.getCurrentView().guid);
        self.presentViewController(noteController, animated: true, completion: nil);
    }
    
    func openPostById(guid:String, frame:CGRect){
        let view = postRefViews[guid];
        if(view != nil){
            let refview = view! as KFPostRefView;
            openPostViewer0(refview.model.post!, frame: frame, refView:refview);
        }else{
            KFAppUtils.showAlert("not implemented", msg: "ref to post not found in this view guid=\(guid)");
            //not implemented
        }
    }
    
    func openPost(postRefView:KFPostRefView){
        //openPopupViewer(postRefView);
        self.openPostViewer(postRefView.model.post!, from: postRefView, refView:postRefView);
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
        
        //        var screenW = self.view.frame.width;
        //        var screenH = self.view.frame.height;
        let screenW = canvasView.frame.size.width;
        let screenH = canvasView.frame.size.height;
        
        let fromCenter = CGPointMake(from.frame.size.width/2, from.frame.size.height/2);
        let absP = from.convertPoint(fromCenter, toView: canvasView);
        //        let absP = from.convertPoint(fromCenter, toView: nil);
        //println("\(screenW), \(screenH)");
        //println(absP);
        
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
    
    func openViewlinkSelectionViewer(popOverLoc:UIView, creatingPoint:CGPoint){
        let viewSelectionController = KFViewSelectionController();
        viewSelectionController.views = self.views;
        KFPopoverManager.getInstance().openInPopover(popOverLoc, controller: viewSelectionController);
        let fromViewId = getCurrentView().guid;
        viewSelectionController.selectedHandler = {(view:KFView) in
            KFPopoverManager.getInstance().closeCurrentPopover();
            KFService.getInstance().createViewLink(fromViewId, toViewId: view.guid , location: creatingPoint);
            return;
        }
    }
    
    func openCreateView(popOverLoc:UIView, creatingPoint:CGPoint){
        let controller = KFViewEditViewController();
        controller.loc = creatingPoint;
        controller.viewIdToLink = self.getCurrentView().guid;
        KFPopoverManager.getInstance().openInPopover(popOverLoc, controller: controller);
    }
    
    /* event handlers */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func exitPressed(sender: AnyObject) {
        self.cometThreadNumber++;
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func viewsButtonPressed(sender: AnyObject) {
        self.showViewSelection();
    }
    
    @IBAction func updatePressed(sender: AnyObject) {
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
