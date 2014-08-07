//
//  KFPostRefView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFPostRefView: UIView {
    
    var mainController: KFCanvasViewController!;
    var model: KFReference!;
    private var panGesture:UIPanGestureRecognizer?;
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(controller: KFCanvasViewController, ref: KFReference) {
        self.mainController = controller;
        self.model = ref;
        
        super.init(frame: CGRectMake(0,0,0,0));
        
        bindEvents();
    }
    
    private func bindEvents(){
        //Pan
        updatePanEventBinding();
        
        //Single Tap
        let recognizerSingleTap = UITapGestureRecognizer(target:self, action:"handleSingleTap:");
        recognizerSingleTap.numberOfTapsRequired = 1;
        self.addGestureRecognizer(recognizerSingleTap);
        
        //Double Tap
        let recognizerDoubleTap = UITapGestureRecognizer(target:self, action:"handleDoubleTap:");
        recognizerDoubleTap.numberOfTapsRequired = 2;
        self.addGestureRecognizer(recognizerDoubleTap);
        
        recognizerSingleTap.requireGestureRecognizerToFail(recognizerDoubleTap);
    }
    
    func getMenuItems() -> [KFMenu]{
        let refModel = self.model;
        var menues:[KFMenu] = [];
        
        let operatable = KFDefaultMenu();
        operatable.name = "Operatable";
        operatable.checked = refModel.isOperatable();
        operatable.exec = {
            operatable.checked = !refModel.isOperatable();
            refModel.setOperatable(!refModel.isOperatable());
            self.updateFromModel();
            self.mainController.updatePostRef(self);
        }
        
        let border = KFDefaultMenu();
        border.name = "Border";
        border.checked = refModel.isBorder();
        border.exec = {
            border.checked = !refModel.isBorder()
            refModel.setBorder(!refModel.isBorder());
            self.updateFromModel();
            self.mainController.updatePostRef(self);
        }

        let fitscale = KFDefaultMenu();
        fitscale.name = "FitScale";
        fitscale.checked = refModel.isFitScale();
        fitscale.exec = {
            fitscale.checked = !refModel.isFitScale();
            self.updateFromModel();
            self.mainController.updatePostRef(self);
        }
        
        return [operatable, border, fitscale];
    }
    
    func updatePanEventBinding(){
        if(!self.model.isLocked() && self.panGesture == nil){
            self.panGesture = UIPanGestureRecognizer(target:self, action:"handlePanning:");
            self.addGestureRecognizer(self.panGesture!);
        }else if(self.model.isLocked() && self.panGesture != nil){
            self.removeGestureRecognizer(self.panGesture!);
            self.panGesture = nil;
        }
    }
    
    func kfSetSize(width:CGFloat, height:CGFloat){
        self.model.width = width;
        self.model.height = height;
        self.updateFromModel();
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        if(!model.isLocked()){
            mainController.suppressScroll();
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        mainController.unlockSuppressScroll();
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        mainController.unlockSuppressScroll();
    }
    
    func handlePanning(recognizer: UIPanGestureRecognizer){
        switch(recognizer.state){
        case .Began:
            self.superview!.bringSubviewToFront(self);
            self.makeShadow();
            break;
        case .Changed:
            let location = recognizer.translationInView(self);
            let movePoint = CGPointMake(self.center.x+location.x, self.center.y+location.y);
            self.center = movePoint;
            recognizer.setTranslation(CGPointZero, inView:self);
            break;
        case .Ended:
            mainController.requestConnectionsRepaint();
            mainController.postLocationChanged(self);
            self.removeShadow();
            break;
        default:
            break;
        }
    }
    
    private var savedBackgroundColor:UIColor?;
    
    func makeShadow(){
        self.savedBackgroundColor = self.backgroundColor;
        self.backgroundColor = UIColor.whiteColor();
        self.layer.shadowColor = UIColor.blackColor().CGColor;
        self.layer.shadowOpacity = 0.7;
        self.layer.shadowOffset = CGSizeMake(10.0, 10.0);
        self.layer.shadowRadius = 5.0;
        self.layer.masksToBounds = false;
        let path = UIBezierPath(rect: self.bounds);
        self.layer.shadowPath = path.CGPath;
    }
    
    func removeShadow(){
        self.backgroundColor = savedBackgroundColor;
        self.layer.shadowOpacity = 0.0;
    }
    
    func handleSingleTap(recognizer: UIGestureRecognizer){
        self.tapA();
    }
    
    func handleDoubleTap(recognizer: UIGestureRecognizer){
        self.tapB();
    }
    
    func tapA(){
    }
    
    func tapB(){
        mainController.showHalo(self);
    }
    
    func updateToModel(){        
    }
    
    var border:Bool = false;
    
    func updateFromModel(){
        if(!border && model.isBorder() && model.isShowInPlace()){
            self.layer.borderColor = UIColor.grayColor().CGColor;
            self.layer.borderWidth = 1.0;
            border = true;
        }else if (border && (!model.isBorder() || !model.isShowInPlace())){
            self.layer.borderWidth = 0.0;
            border = false;
        }
        
        let r = self.frame;
        self.frame = CGRectMake(model.location.x, model.location.y, r.size.width, r.size.height);
    }
    
    //    func die(){
    //
    //    }
}
