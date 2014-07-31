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
    @IBOutlet weak var imageAddButton: UIBarButtonItem!
    
    private var canvasView = KFCanvasView();
    private var imagePicker:KFImagePicker?;
    
    
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.imagePicker = KFImagePicker(mainController: self);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //canvasView.setSize(canvasContainer.frame.size);//moved to viewDidAppear and rotation
        canvasView.setCanvasSize(4000, height:3000);
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
            
            self.views = KFService.getInstance().getViews(registration.communityId);
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
        
        self.hideHalo();
        
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
        canvasView.noteLayer.addSubview(postRefView);
    }
    
    func addDrawing(ref:KFReference){
        if(!(ref.post is KFDrawing)){
            //    [NSException raise:@"iKFConnectionException" format:@"Illegal addDrawing"];
            return;
        }
        
        self.hideHalo();
        
        var postRefView:KFDrawingRefView?;
        
        if(self.reusableRefViews[ref.guid] != nil ){
            postRefView = reusableRefViews[ref.guid] as? KFDrawingRefView;
            postRefView!.model = ref;
        }else{
            postRefView = KFDrawingRefView(controller: self, ref: ref);
        }

        postRefView?.updateFromModel();
        postRefViews[ref.guid] = postRefView;
        //postRefViews[ref.post!.guid] = postRefView;//ちょっとずる
        canvasView.drawingLayer.addSubview(postRefView);
    }
    
    func addViewRef(ref:KFReference){
        if(!(ref.post is KFView)){
            //[NSException raise:@"iKFConnectionException" format:@"Illegal ViewRef"];
        }
        
        self.hideHalo();
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
            canvasView.connectionLayer.addConnectionFrom(fromRefView, to: toRefView);
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
    
    func openPost(postRefView:KFPostRefView){
        
    }
    
    //    var notePopupController: iKFNotePopupViewController?;
    //    var popoverController: UIPopoverController?;
    //
    //    //これはkfMainへ移動すること
    //    func openPopupViewer(){
    //        let newPopupController = iKFNotePopupViewController();
    //        newPopupController.note = (self.model.post as KFNote);
    //
    //        newPopupController.kfViewController = mainController;
    //        newPopupController.preferredContentSize = newPopupController.view.frame.size;
    //        self.notePopupController = newPopupController;
    //
    //        self.popoverController = UIPopoverController(contentViewController: notePopupController);
    //        newPopupController.popController = self.popoverController;
    //        self.popoverController?.presentPopoverFromRect(self.frame, inView: self.superview, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true);
    //    }
    
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
    }
    
    @IBAction func imageAddPressed(sender: AnyObject) {
        self.imagePicker!.openImagePicker(imageAddButton, viewId: self.getCurrentView().guid);
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
