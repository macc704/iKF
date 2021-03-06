//
//  KFHalo.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-29.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFHalo: UIView {
    
    private var controller:KFCanvasViewController?;
    private var target:UIView!;
    private var size:CGFloat!;
    
    private var locator:KFHaloLocator!;
    private var handles:[UIView:(()->CGRect)]=[:];//handle, locator
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(controller:KFCanvasViewController?, target:UIView, size:CGFloat = 40){
        self.controller = controller;
        self.target = target;
        self.size = size;
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        self.locator = KFHaloLocator(halo: self, size: size);
        self.installHaloHandles();
        
        
        //supress under object gestures
        let tapGestureDouble = UITapGestureRecognizer(target: self, action: "tapDouble:")
        tapGestureDouble.numberOfTapsRequired = 2;
        self.addGestureRecognizer(tapGestureDouble);
        let tapGestureSingle = UITapGestureRecognizer(target: self, action: "tapSingle:")
        tapGestureSingle.numberOfTapsRequired = 1;
        self.addGestureRecognizer(tapGestureSingle);

        // below will be done by startanimation
        // self.initializeSizeAndHandles();
    }
    
    func tapDouble(recognizer:UITapGestureRecognizer){
    }
    func tapSingle(recognizer:UITapGestureRecognizer){
        controller?.hideHalo();
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        controller?.suppressScroll();
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
        controller?.unlockSuppressScroll();
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        controller?.unlockSuppressScroll();
    }
    
    private func initializeSizeAndHandles(){
        let targetFrame = self.target.frame;
        self.frame = CGRect(x:targetFrame.origin.x - size, y:targetFrame.origin.y - size, width:targetFrame.size.width + size*2, height:targetFrame.size.height + size*2);
        for handle in handles.keys{
            handle.frame = handles[handle]!();
        }
    }
    
    private func installHaloHandles(){
        if(target is KFPostRefView){
            let post = (target as KFPostRefView).getModel().post!;
            installHaloHandle("bin.png", locator: locator.TOP_LEFT(), tap: "handleDelete:", pan: nil);
            installHaloHandle("move.png", locator: locator.TOP(), tap: nil, pan: "handleMove:");
            
            if(post.canEditMe()){
                installHaloHandle("setting.png", locator: locator.BOTTOM_QUARTER_RIGHT(), tap: "handlePostSetting:", pan: nil);
            }
        }
        
        if(target is KFDrawingRefView){
            let drawing = target as KFDrawingRefView;
            if(drawing.getModel().isLocked()){
                installHaloHandle("unlock.png", locator: locator.TOP_RIGHT(), tap: "handleUnlock:", pan: nil);
            }
            else{
                installHaloHandle("lock.png", locator: locator.TOP_RIGHT(), tap: "handleLock:", pan: nil);
            }
            installHaloHandle("resize.png", locator: locator.BOTTOM_RIGHT(), tap: nil, pan: "handlePanResize:");
            installHaloHandle("rotation.png", locator: locator.BOTTOM_LEFT(), tap: nil, pan: "handlePanRotation:");
            installHaloHandle("buildson.png", locator: locator.BOTTOM(), tap: nil, pan: "handleBuildsOn:");
            
            installHaloHandle("moveto.png", locator: locator.BOTTOM_QUARTER_LEFT(), tap: "handleMovePostToView:", pan: nil);
            
            let rotationGesture = UIRotationGestureRecognizer(target: self, action: "handleGestureRotation:");
            self.addGestureRecognizer(rotationGesture);
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handleGestureResize:");
            self.addGestureRecognizer(pinchGesture);
        }
        
        if(target is KFNoteRefView){
            let note = target as KFNoteRefView;
            installHaloHandle("read.png", locator: locator.TOP_QUARTER_RIGHT(), tap: "handleRead:", pan: nil);
            if(note.getModel().post!.canEditMe()){
                installHaloHandle("edit.png", locator: locator.TOP_RIGHT(), tap: "handleEdit:", pan: nil);
            }else{
                installHaloHandle("nonedit.png", locator: locator.TOP_RIGHT(), tap: nil, pan: nil);
            }
            installHaloHandle("clip.png", locator: locator.TOP_QUARTER_LEFT(), tap: "handleClip:", pan: nil);
            if(note.getModel().isShowInPlace()){
                installHaloHandle("closetoicon", locator: locator.LEFT(), tap: "closeToIcon:", pan: nil);
                installHaloHandle("resize.png", locator: locator.BOTTOM_RIGHT(), tap: nil, pan: "handlePanResize:");
            }else{
                installHaloHandle("showinplace", locator: locator.LEFT(), tap: "showInPlace:", pan: nil);
            }
            if(note.getModel().isShowInPlace()){
                installHaloHandle("list", locator: locator.RIGHT(), tap: "handleShowMenu:", pan: nil);
            }
            installHaloHandle("buildson.png", locator: locator.BOTTOM(), tap: nil, pan: "handleBuildsOn:");
            installHaloHandle("moveto.png", locator: locator.BOTTOM_QUARTER_LEFT(), tap: "handleMovePostToView:", pan: nil);
        }
        
        if(target is KFWebBrowserView){
            if((target as KFWebBrowserView).noteRef != nil){
                installHaloHandle("read.png", locator: locator.TOP_QUARTER_RIGHT(), tap: "handleRead:", pan: nil);
                if((target as KFWebBrowserView).noteRef!.getModel().post!.canEditMe()){
                    installHaloHandle("edit.png", locator: locator.TOP_RIGHT(), tap: "handleEdit:", pan: nil);
                }else{
                    installHaloHandle("nonedit.png", locator: locator.TOP_RIGHT(), tap: nil, pan: nil);
                }
                installHaloHandle("clip.png", locator: locator.TOP_QUARTER_LEFT(), tap: "handleClip:", pan: nil);
            }
            
            installHaloHandle("move.png", locator: locator.TOP(), tap: nil, pan: "handleMoveWeb:");
            installHaloHandle("resize.png", locator: locator.BOTTOM_RIGHT(), tap: nil, pan: "handlePanResizeWeb:");
            if((target as KFWebBrowserView).noteRef == nil){
                installHaloHandle("window.png", locator: locator.RIGHT(), tap: "handleToggleMenuWeb:", pan: nil);
                installHaloHandle("anchor.png", locator: locator.BOTTOM(), tap: nil, pan: "handleAnchorWeb:");
            }else{
                installHaloHandle("buildson.png", locator: locator.BOTTOM(), tap: nil, pan: "handleBuildsOn:");
            }
            installHaloHandle("close.png", locator: locator.TOP_LEFT(), tap: "closeWeb:", pan: nil);
        }
        
        if(target is KFCreationToolView){
            installHaloHandle("new.png", locator: locator.TOP_LEFT(), tap: "handleNewNote:", pan: nil);
            installHaloHandle("newpicture.png", locator: locator.TOP_QUARTER_LEFT(), tap: "handleNewPicture:", pan: nil);
            installHaloHandle("newviewlink.png", locator: locator.TOP(), tap: "handleNewViewlink:", pan: nil);
            installHaloHandle("moveto.png", locator: locator.TOP_QUARTER_RIGHT(), tap: "handleNewPostlink:", pan: nil);
            installHaloHandle("newview.png", locator: locator.TOP_RIGHT(), tap: "handleNewView:", pan: nil);
            
            installHaloHandle("setting.png", locator: locator.BOTTOM_LEFT(), tap: "handlePostSetting:", pan: nil);
            installHaloHandle("window.png", locator: locator.BOTTOM_RIGHT(), tap: "handleOpenWindow:", pan: nil);
        }
    }
    
    func installHaloHandle(imgName:String, locator:(()->CGRect), tap:Selector?, pan:Selector?) -> UIImageView{
        let button = KFImageView(image: UIImage(named: imgName));
        button.mainController = controller;
        self.addSubview(button);
        button.userInteractionEnabled = true;
        if(tap != nil){
            let gesture = UITapGestureRecognizer(target: self, action: tap!);
            gesture.numberOfTapsRequired = 1;
            button.addGestureRecognizer(gesture);
        }
        if(pan != nil){
            let gesture = UIPanGestureRecognizer(target: self, action: pan!);
            button.addGestureRecognizer(gesture);
            let illegal = UITapGestureRecognizer(target: self, action: "handleIllegalTapping:");
            button.addGestureRecognizer(illegal);
        }
        self.handles[button] = locator;
        return button;
    }
    
    func showWithAnimation(container:UIView){
        self.initializeSizeAndHandles();
        self.alpha = 0.0;
        let center = CGPoint(x: self.frame.width/2, y: self.frame.height/2);
        for handle in handles.keys{
            handle.center = center;
        }
        container.addSubview(self);
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = 1.0
            for handle in self.handles.keys{
                handle.frame = self.handles[handle]!();
            }
            }, completion: nil);
    }
    
    // ----------- handlers -----------
    
    func handleShowMenu(recognizer:UIGestureRecognizer){
        let postRefView = target as KFPostRefView;
        let c = KFMenuViewController(menues:postRefView.getMenuItems());
        c.setBarTitle("Properties:")
        c.fit();
        let from = recognizer.view;
        KFPopoverManager.getInstance().openInPopover(from!, controller: c);
    }
    
    func handleMovePostToView(recognizer:UIGestureRecognizer){
        let post = (target as KFPostRefView).getModel().post!;
        let popOverLoc = recognizer.view;
        let creatingPoint = CGPointMake(50, 50);
        let viewSelectionController = KFViewSelectionController();
        viewSelectionController.setBarTitle("Copy to");
        viewSelectionController.models = KFService.getInstance().currentRegistration.community.views.array;
        KFPopoverManager.getInstance().openInPopover(popOverLoc!, controller: viewSelectionController);
        //let fromViewId = controller!.getCurrentView().guid;
        viewSelectionController.selectedHandler = {(model:KFModel) in
            KFPopoverManager.getInstance().closeCurrentPopover();
            KFService.getInstance().createPostLink(model.guid, toPostId: post.guid , location:creatingPoint);
            return;
        }
    }
    
    func handlePostSetting(recognizer:UIGestureRecognizer){
        var post:KFPost!;
        if(target is KFCreationToolView){
            post = controller!.getCurrentView();
        }else{
            post = (target as KFPostRefView).getModel().post!;
        }
        
        var menus:[KFMenu] = [];
        let users:[KFUser] = KFService.getInstance().currentRegistration.community.members.array;
        for user in users {
            let menu = KFDefaultMenu();
            menu.name = user.getFullName();
            menu.checked = post.canEdit(user);
            menu.exec = {
                let newValue = !menu.checked;
                menu.checked = newValue;
                post.setAuthor(user, value:newValue);
            }
            menus.append(menu);
        }
        let c = KFMenuViewController(menues:menus);
        c.setBarTitle("Co-Authors");
        c.closeHandler = {
            if(post.dirtyAuthors){
                post.dirtyAuthors = false;
                KFAppUtils.executeInBackThread({
                    KFService.getInstance().updatePostAuthors(post);
                    return;
                });
            }
        };
        let from = recognizer.view;
        KFPopoverManager.getInstance().openInPopover(from!, controller: c);
    }
    
    func handleToggleMenuWeb(recognizer:UIGestureRecognizer){
        let browser = target as KFWebBrowserView;
        browser.setShowToolbar(!browser.isShowToolbar());
    }
    
    func closeWeb(recognizer:UIGestureRecognizer){
        let browser = target as KFWebBrowserView;
        browser.close();
        self.removeFromSuperview();
    }
    
    func handleOpenWindow(recognizer:UIGestureRecognizer){
        let size = CGSizeMake(500, 500);
        var loc = recognizer.locationInView(self.superview);
        loc.x = loc.x - size.width / 2;
        loc.x = 30 > loc.x ? 30 : loc.x;
        controller?.openBrowser(loc, size:size);
    }
    
    func handleNewNote(recognizer:UIGestureRecognizer){
        var loc = recognizer.locationInView(self.superview);
        controller?.createNote(loc);
    }
    
    func handleNewPicture(recognizer:UIGestureRecognizer){
        controller?.openImageSelectionViewer(recognizer.view!, creatingPoint: self.target.frame.origin);
    }
    
    func handleNewViewlink(recognizer:UIGestureRecognizer){
        self.openViewlinkSelectionViewer(recognizer.view!, creatingPoint: self.target.frame.origin);
    }
    
    private func openViewlinkSelectionViewer(popOverLoc:UIView, creatingPoint:CGPoint){
        let viewSelectionController = KFViewSelectionController();
        viewSelectionController.setBarTitle("Create Link to View");
        viewSelectionController.models = KFService.getInstance().currentRegistration.community.views.array;
        KFPopoverManager.getInstance().openInPopover(popOverLoc, controller: viewSelectionController);
        let fromViewId = controller!.getCurrentView().guid;
        viewSelectionController.selectedHandler = {(model:KFModel) in
            KFPopoverManager.getInstance().closeCurrentPopover();
            self.controller?.hideHalo();
            KFService.getInstance().createViewLink(fromViewId, toViewId: model.guid , location: creatingPoint);
            return;
        }
    }
    
    func handleNewPostlink(recognizer:UIGestureRecognizer){
        self.openPostlinkSelectionViewer(recognizer.view!, creatingPoint: self.target.frame.origin);
    }
    
    private func openPostlinkSelectionViewer(popOverLoc:UIView, creatingPoint:CGPoint){
        let viewSelectionController = KFViewSelectionController();
        viewSelectionController.setBarTitle("Create PostLink Here");
        viewSelectionController.models = KFService.getInstance().getAllPosts().array;
        KFPopoverManager.getInstance().openInPopover(popOverLoc, controller: viewSelectionController);
        let fromViewId = controller!.getCurrentView().guid;
        viewSelectionController.selectedHandler = {(model:KFModel) in
            KFPopoverManager.getInstance().closeCurrentPopover();
            self.controller?.hideHalo();
            KFService.getInstance().createPostLink(fromViewId, toPostId: model.guid , location: creatingPoint);
            return;
        }
    }
    
    
    func handleNewView(recognizer:UIGestureRecognizer){
        self.openCreateView(recognizer.view!, creatingPoint: self.target.frame.origin);
    }
    
    private func openCreateView(popOverLoc:UIView, creatingPoint:CGPoint){
        let c = KFViewEditViewController();
        c.loc = creatingPoint;
        c.viewIdToLink = self.controller!.getCurrentView().guid;
        KFPopoverManager.getInstance().openInPopover(popOverLoc, controller: c);
    }
    
    func handleLock(recognizer:UIGestureRecognizer){
        setLock(true);
    }
    
    func handleUnlock(recognizer:UIGestureRecognizer){
        setLock(false);
    }
    
    private func setLock(lock:Bool){
        let postTarget = target as KFPostRefView;
        postTarget.getModel().setLocked(lock);
        postTarget.updateEventBinding();
        controller?.updatePostRef(postTarget);
        controller?.hideHalo();
    }
    
    func closeToIcon(recognizer:UIGestureRecognizer){
        setShowInPlace(false);
    }
    
    func showInPlace(recognizer:UIGestureRecognizer){
        setShowInPlace(true);
    }
    
    private func setShowInPlace(showInPlace:Bool){
        let postTarget = target as KFPostRefView;
        if(showInPlace && postTarget.getModel().width < 10){
            postTarget.getModel().width = 100;
        }
        if(showInPlace && postTarget.getModel().height < 10){
            postTarget.getModel().height = 100;
        }
        postTarget.getModel().setShowInPlace(showInPlace);
        //        postTarget.updatePanEventBinding();
        controller?.updatePostRef(postTarget);
        postTarget.updateFromModel();
        controller?.hideHalo();
    }
    
    func handleEdit(recognizer:UIGestureRecognizer){
        var noteRef:KFPostRefView!;
        if(target is KFWebBrowserView){
            noteRef = (target as KFWebBrowserView).noteRef;
        }else if(target is KFPostRefView){
            noteRef = target as KFPostRefView;
        }else{
            return; //exception
        }
        controller?.openNoteEditController(noteRef.getModel().post as KFNote, mode: "edit");
        controller?.hideHalo();
    }
    
    func handleRead(recognizer:UIGestureRecognizer){
        var noteRef:KFPostRefView!;
        if(target is KFWebBrowserView){
            noteRef = (target as KFWebBrowserView).noteRef;
        }else if(target is KFPostRefView){
            noteRef = target as KFPostRefView;
        }else{
            return; //exception
        }
        controller?.openNoteEditController(noteRef.getModel().post as KFNote, mode: "read");
        controller?.hideHalo();
    }
    
    func handleDelete(recognizer:UIGestureRecognizer){
        let postTarget = target as KFPostRefView;
        self.controller?.deletePostRef(postTarget, fromUI:true);
        controller?.hideHalo();
    }
    
    func handleClip(recognizer:UIGestureRecognizer){
        var noteRef:KFPostRefView!;
        if(target is KFWebBrowserView){
            noteRef = (target as KFWebBrowserView).noteRef;
        }else if(target is KFPostRefView){
            noteRef = target as KFPostRefView;
        }else{
            return; //exception
        }
        let note = noteRef.getModel().post as KFNote;
        let pasteboard = UIPasteboard.generalPasteboard();
        pasteboard.string = note.title;
        var dic = NSMutableDictionary(dictionary: pasteboard.items[0] as NSDictionary);
        dic["kfmodel.guid"] = note.guid;
        pasteboard.items = [dic];
        //KFAppUtils.showAlert("Notification", msg: "Cliped Post '\(note.title)'")
        openMessage(noteRef, message: "This note was clipped to pasteboard.\n\nYou can make a reference\nby 'Paste as Reference'");
        controller?.hideHalo();
    }
    
    func handleIllegalTapping(recognizer:UIGestureRecognizer){
        openMessage(recognizer.view!, message: "Don't Tap me\n\nDrag me!");
    }
    
    private func openMessage(from:UIView, message:String){
        let c = KFSimplePopupViewController();
        c.message = message;
        KFPopoverManager.getInstance().openInPopover(from, controller: c);
    }
    
    func handleBuildsOn(recognizer:UIPanGestureRecognizer){
        var postTarget:KFPostRefView?;
        if(target is KFPostRefView){
            postTarget = target as? KFPostRefView;
        }else if (target is KFWebBrowserView){
            postTarget = (target as KFWebBrowserView).noteRef;
        }
        
        if(target == nil){
            return;
        }
        
        switch(recognizer.state){
        case .Began:
            break;
        case .Changed:
            moveHandle(recognizer);
            break;
        case .Ended:
            let button = recognizer.view;
            let objectP = self.frame.origin;
            let buttonP = button!.frame.origin;
            let p = CGPoint(x:objectP.x + buttonP.x, y:objectP.y + buttonP.y);
            controller?.createNote(p, buildsOn: postTarget);
            break;
        default:
            break;
        }
    }
    
    func handleAnchorWeb(recognizer:UIPanGestureRecognizer){
        switch(recognizer.state){
        case .Began:
            break;
        case .Changed:
            moveHandle(recognizer);
            break;
        case .Ended:
            let webbrowser = target as KFWebBrowserView;
            let url = webbrowser.getURL();
            let title = webbrowser.getTitle();
            let button = recognizer.view;
            let objectP = self.frame.origin;
            let buttonP = button!.frame.origin;
            let p = CGPoint(x:objectP.x + buttonP.x, y:objectP.y + buttonP.y);
            controller?.createWebNote(p, url: url, title: title);
            self.initializeSizeAndHandles();
            break;
        default:
            break;
        }
    }
    
    private func moveHandle(recognizer:UIPanGestureRecognizer) -> CGPoint{
        let button = recognizer.view!;
        let location = recognizer.translationInView(button);
        let movePoint = CGPointMake(button.center.x+location.x, button.center.y+location.y);
        button.center = movePoint;
        recognizer.setTranslation(CGPointZero, inView: button);
        return movePoint;
    }
    
    func handleMove(recognizer:UIPanGestureRecognizer){
        let postTarget = target as KFPostRefView;
        
        switch(recognizer.state){
        case .Began:
            break;
        case .Changed:
            //move halo
            let location = recognizer.translationInView(self);
            let movePoint = CGPoint(x:self.center.x+location.x, y:self.center.y+location.y);
            self.center = movePoint;
            break;
        case .Ended:
            break;
        default:
            break;
        }
        
        postTarget.handlePanning(recognizer);
    }
    
    func handleMoveWeb(recognizer:UIPanGestureRecognizer){
        switch(recognizer.state){
        case .Began:
            break;
        case .Changed:
            let location = recognizer.translationInView(self);
            let movePoint = CGPoint(x:self.center.x+location.x, y:self.center.y+location.y);
            self.center = movePoint;
            
            //let location = recognizer.translationInView(self);
            let movePoint2 = CGPointMake(target.center.x+location.x, target.center.y+location.y);
            target.center = movePoint2;
            recognizer.setTranslation(CGPointZero, inView:target);
            break;
        case .Ended:
            break;
        default:
            break;
        }
    }
    
    func handlePanResize(recognizer:UIPanGestureRecognizer){
        let drawingTarget = target as KFPostRefView;
        
        switch(recognizer.state){
        case .Began:
            break;
        case .Changed:
            let button = recognizer.view!;
            moveHandle(recognizer);
            var w = button.frame.origin.x - button.frame.size.width;
            var h = button.frame.origin.y - button.frame.size.height;
            w = round(w);
            h = round(h);
            if(w < 50){
                w = 50;
            }
            if(h < 50){
                h = 50;
            }
            drawingTarget.kfSetSize(w, height:h);
            break;
        case .Ended:
            self.updateToServer();
            //            controller?.showHalo(drawingTarget);
            self.initializeSizeAndHandles();
            break;
        default:
            break;
        }
    }
    
    func handlePanResizeWeb(recognizer:UIPanGestureRecognizer){
        switch(recognizer.state){
        case .Began:
            break;
        case .Changed:
            let button = recognizer.view!;
            moveHandle(recognizer);
            var w = button.frame.origin.x - button.frame.size.width;
            var h = button.frame.origin.y - button.frame.size.height;
            w = round(w);
            h = round(h);
            if(w < 50){
                w = 50;
            }
            if(h < 50){
                h = 50;
            }
            let newRect:CGRect = CGRectMake(target.frame.origin.x, target.frame.origin.y, w, h);
            target.frame = newRect;
            break;
        case .Ended:
            self.initializeSizeAndHandles();
            break;
        default:
            break;
        }
    }
    
    private var initialScale:CGFloat?;
    private var initialCenter:CGPoint?;
    
    func handleGestureResize(recognizer:UIPinchGestureRecognizer){
        let drawingTarget = target as KFDrawingRefView;
        
        switch(recognizer.state){
        case .Began:
            initialScale = drawingTarget.scaleX;
            initialCenter = drawingTarget.center;
            break;
        case .Changed:
            let scale = recognizer.scale;
            let newScale = initialScale! * scale;
            drawingTarget.kfSetScale(newScale, newScaleY:newScale);
            drawingTarget.center = initialCenter!;
            break;
        case .Ended:
            self.updateToServer();
            //            controller?.showHalo(drawingTarget);
            self.initializeSizeAndHandles();
            break;
        default:
            break;
        }
    }
    
    func handlePanRotation(recognizer:UIPanGestureRecognizer){
        let drawingTarget = target as KFDrawingRefView;
        
        switch(recognizer.state){
        case .Began:
            break;
        case .Changed:
            let movePoint = moveHandle(recognizer);
            let button = recognizer.view;
            
            let frameW = self.frame.size.width;
            let frameH = self.frame.size.height;
            let org = CGPoint(x:frameW/2, y:frameH/2);
            
            //http://kappdesign.blog.fc2.com/blog-entry-18.html
            // make difference then reverse y axis
            let diffX = movePoint.x - org.x;
            var diffY = (movePoint.y - org.y);
            diffY = -diffY;
            let originalAngle:Double = atan2(Double(diffY), Double(diffX));
            let leftBottomAngle:Double = M_PI - atan2(Double(frameW), Double(frameH));
            let radian:Double =  originalAngle + leftBottomAngle;
            var newRotation:CGFloat = CGFloat(radian);
            newRotation = self.adjustRotation(newRotation);
            newRotation = -newRotation;
            drawingTarget.kfSetRotation(newRotation);
            break;
        case .Ended:
            self.updateToServer();
            //            controller?.showHalo(drawingTarget);
            self.initializeSizeAndHandles();
            break;
        default:
            break;
        }
    }
    
    private var initialRotation:CGFloat?;
    
    func handleGestureRotation(recognizer:UIRotationGestureRecognizer){
        let drawingTarget = target as KFDrawingRefView;
        
        switch(recognizer.state){
        case .Began:
            initialRotation = drawingTarget.rotation;
            break;
        case .Changed:
            let rotation = recognizer.rotation;
            var newRotation = initialRotation! + rotation;
            newRotation = self.adjustRotation(newRotation);
            drawingTarget.kfSetRotation(newRotation);
            break;
        case .Ended:
            self.updateToServer();
            //            controller?.showHalo(drawingTarget);
            self.initializeSizeAndHandles();
            break;
        default:
            break;
        }
    }
    
    private func updateToServer(){
        let postTarget = target as KFPostRefView;
        postTarget.updateToModel();
        controller?.updatePostRef(postTarget);
    }
    
    func adjustRotation(radian:CGFloat) -> CGFloat{
        let tmp1 = 360.0 / (2.0 * M_PI);
        var degree:Int = Int(Double(radian) * tmp1);
        let a = degree % 90;
        if(-5 < a && a < 0){
            degree = degree + a;
        }else if(0 < a && a < 5){
            degree = degree - a;
        }
        let tmp2 = (2.0 * M_PI) / 360.0;
        let newRadian = Double(degree) * tmp2;
        return CGFloat(newRadian);
    }
    
}
