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
    private var target:UIView;
    private var size:CGFloat;
    
    private var locator:KFHaloLocator!;
    private var handles:[UIView:(()->CGRect)]=[:];//handle, locator
    
    init(controller:KFCanvasViewController?, target:UIView, size:CGFloat = 40){
        self.controller = controller;
        self.target = target;
        self.size = size;
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        self.locator = KFHaloLocator(halo: self, size: size);
        self.installHaloHandles();
        //self.initializeSizeAndHandles();
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        controller?.suppressScroll();
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        controller?.unlockSuppressScroll();
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
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
            installHaloHandle("bin.png", locator: locator.TOP_LEFT(), tap: "handleDelete:", pan: nil);
        }
        
        if(target is KFDrawingRefView){
            let drawing = target as KFDrawingRefView;
            if(drawing.model.isLocked()){
                installHaloHandle("unlock.png", locator: locator.TOP_RIGHT(), tap: "handleUnlock:", pan: nil);
            }
            else{
                installHaloHandle("lock.png", locator: locator.TOP_RIGHT(), tap: "handleLock:", pan: nil);
            }
            installHaloHandle("resize.png", locator: locator.BOTTOM_RIGHT(), tap: nil, pan: "handlePanResize:");
            installHaloHandle("move.png", locator: locator.TOP(), tap: nil, pan: "handleMove:");
            installHaloHandle("rotation.png", locator: locator.BOTTOM_LEFT(), tap: nil, pan: "handlePanRotation:");
            
            let rotationGesture = UIRotationGestureRecognizer(target: self, action: "handleGestureRotation:");
            self.addGestureRecognizer(rotationGesture);
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handleGestureResize:");
            self.addGestureRecognizer(pinchGesture);
        }
        
        if(target is KFNoteRefView){
            installHaloHandle("read.png", locator: locator.TOP_RIGHT(), tap: "handleRead:", pan: nil);
            installHaloHandle("edit.png", locator: locator.TOP(), tap: "handleEdit:", pan: nil);
            installHaloHandle("clip.png", locator: locator.TOP_QUARTER_RIGHT(), tap: "handleClip:", pan: nil);
            installHaloHandle("buildsOn.png", locator: locator.BOTTOM_LEFT(), tap: nil, pan: "handleBuildsOn:");
        }
        
        if(target is KFWebView || target is KFWebBrowserView){
            installHaloHandle("move.png", locator: locator.TOP(), tap: nil, pan: "handleMoveWeb:");
            installHaloHandle("resize.png", locator: locator.BOTTOM_RIGHT(), tap: nil, pan: "handlePanResizeWeb:");
            installHaloHandle("anchor.png", locator: locator.BOTTOM_LEFT(), tap: nil, pan: "handleAnchorWeb:");
        }
        
        if(target is KFCreationToolView){
            installHaloHandle("new.png", locator: locator.TOP_LEFT(), tap: "handleNewNote:", pan: nil);
            installHaloHandle("newpicture.png", locator: locator.TOP(), tap: "handleNewPicture:", pan: nil);
            installHaloHandle("newviewlink.png", locator: locator.BOTTOM_LEFT(), tap: "handleNewViewlink:", pan: nil);
            //installHaloHandle("newview.png", locator: locator.BOTTOM_RIGHT(), tap: nil, pan: nil);
            installHaloHandle("window.png", locator: locator.TOP_RIGHT(), tap: "handleOpenWindow:", pan: nil);
        }
    }
    
    func installHaloHandle(imgName:String, locator:(()->CGRect), tap:Selector?, pan:Selector?) -> UIImageView{
        let button = KFImageView(image: UIImage(named: imgName));
        button.mainController = controller;
        self.addSubview(button);
        button.userInteractionEnabled = true;
        if(tap){
            let gesture = UITapGestureRecognizer(target: self, action: tap!);
            gesture.numberOfTapsRequired = 1;
            button.addGestureRecognizer(gesture);
        }
        if(pan){
            let gesture = UIPanGestureRecognizer(target: self, action: pan!);
            button.addGestureRecognizer(gesture);
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
            }, completion: {
            (x:Bool) in
                // not necessary
                //            for handle in self.handles.keys{
                //                handle.frame = self.handles[handle]!();
                //            }
            });
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
        controller?.openImageSelectionViewer(recognizer.view, creatingPoint: self.target.frame.origin);
    }
    
    func handleNewViewlink(recognizer:UIGestureRecognizer){
        controller?.openViewlinkSelectionViewer(recognizer.view, creatingPoint: self.target.frame.origin);
    }
    
    func handleLock(recognizer:UIGestureRecognizer){
        setLock(true);
    }
    
    func handleUnlock(recognizer:UIGestureRecognizer){
        setLock(false);
    }
    
    private func setLock(lock:Bool){
        let postTarget = target as KFPostRefView;
        postTarget.model.setLocked(lock);
        postTarget.updatePanEventBinding();
        controller?.updatePostRef(postTarget);
        controller?.hideHalo();
    }
    
    func handleEdit(recognizer:UIGestureRecognizer){
        controller?.openNoteEditController((target as KFPostRefView).model.post as KFNote, mode: "edit");
        controller?.hideHalo();
    }
    
    func handleRead(recognizer:UIGestureRecognizer){
        controller?.openNoteEditController((target as KFPostRefView).model.post as KFNote, mode: "read");
        controller?.hideHalo();
    }
    
    func handleDelete(recognizer:UIGestureRecognizer){
        let postTarget = target as KFPostRefView;
        self.controller?.deletePostRef(postTarget);
        controller?.hideHalo();
    }
    
    func handleClip(recognizer:UIGestureRecognizer){
        let noteTarget = target as KFNoteRefView;
        let note = noteTarget.model.post as KFNote;
        let pasteboard = UIPasteboard.generalPasteboard();
        pasteboard.string = note.title;
        var dic = NSMutableDictionary(dictionary: pasteboard.items[0] as NSDictionary);
        dic["kfmodel.guid"] = note.guid;
        pasteboard.items = [dic];
        KFAppUtils.showAlert("Notification", msg: "Cliped Post '\(note.title)'")
        controller?.hideHalo();
    }
    
    func handleBuildsOn(recognizer:UIPanGestureRecognizer){
        let postTarget = target as KFPostRefView;
        
        switch(recognizer.state){
        case .Began:
            break;
        case .Changed:
            moveHandle(recognizer);
            break;
        case .Ended:
            let button = recognizer.view;
            let objectP = postTarget.frame.origin;
            let buttonP = button.frame.origin;
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
            let objectP = webbrowser.frame.origin;
            let buttonP = button.frame.origin;
            let p = CGPoint(x:objectP.x + buttonP.x, y:objectP.y + buttonP.y);
            controller?.createWebNote(p, url: url, title: title);
            self.initializeSizeAndHandles();
            break;
        default:
            break;
        }
    }
    
    private func moveHandle(recognizer:UIPanGestureRecognizer) -> CGPoint{
        let button = recognizer.view;
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
        let drawingTarget = target as KFDrawingRefView;
        
        switch(recognizer.state){
        case .Began:
            break;
        case .Changed:
            let button = recognizer.view;
            moveHandle(recognizer);
            let w = button.frame.origin.x - button.frame.size.width;
            let h = button.frame.origin.y - button.frame.size.height;
            drawingTarget.kfSetSize(w, height:h);
            break;
        case .Ended:
            self.updateToServer();
            controller?.showHalo(drawingTarget);
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
            let button = recognizer.view;
            moveHandle(recognizer);
            let w = button.frame.origin.x - button.frame.size.width;
            let h = button.frame.origin.y - button.frame.size.height;
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
            controller?.showHalo(drawingTarget);
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
            controller?.showHalo(drawingTarget);
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
            controller?.showHalo(drawingTarget);
            break;
        default:
            break;
        }
    }
    
    private func updateToServer(){
        let drawingTarget = target as KFDrawingRefView;
        drawingTarget.updateToModel();
        controller?.updatePostRef(drawingTarget);
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
