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
    
    private var canvasView = KFCanvasView();
    private var halo:iKFHandle?;
    
    private var user:KFUser?;
    private var registration:KFRegistration?;
    private var postRefs:[String: KFReference] = [:];
    private var postRefViews:[String: KFPostRefView] = [:];
    private var views:[KFView] = [];
    private var currentView:KFView?
    private var reusableRefViews:[String: KFPostRefView] = [:];
    
    private var initialized = false;
    private var cometThreadNumber = 0;
    private var cometVersion = 0;
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.setSize(canvasContainer.frame.size);
        canvasView.setCanvasSize(4000, height:3000);
        canvasContainer.addSubview(canvasView);
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
            self.setCurrentView(self.views[0]);
            self.initialized = true;
            self.cometThreadNumber++;
            self.startComet(self.cometThreadNumber);
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
            postRefView?.updateFromModel();
        }else{
            postRefView = KFNoteRefView(controller: self, ref: ref);
        }
        
        let r = postRefView!.frame;
        postRefView!.frame = CGRect(x: ref.location.x, y: ref.location.y, width: r.size.width, height: r.size.height);
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
        let r = postRefView!.frame;
        postRefView!.frame = CGRect(x: ref.location.x, y: ref.location.y, width: r.size.width, height: r.size.height);
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
        self.hideHalo();
        
        self.halo = iKFHandle(controller: self, target: view);
        self.halo!.alpha = 0.0;
        self.canvasView.addSubview(self.halo);
        func animation(){
            halo!.alpha = 1.0;
        }
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: animation, completion: nil);
    }
    
    func hideHalo(){
        if(self.halo){
            self.halo!.removeFromSuperview();
            self.halo = nil;
        }
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
        self.currentView = view;
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func exitPressed(sender: AnyObject) {
        self.cometThreadNumber++;
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func updatePressed(sender: AnyObject) {
    }
    
    @IBAction func noteAddPressed(sender: AnyObject) {
    }
    
    @IBAction func imageAddPressed(sender: AnyObject) {
    }
    
    @IBAction func viewLinkAddPressed(sender: AnyObject) {
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
