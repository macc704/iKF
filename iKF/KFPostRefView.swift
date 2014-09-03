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
    private var _model: KFReference!;
    private var panGesture:UIPanGestureRecognizer?;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(controller: KFCanvasViewController, ref: KFReference) {
        self.mainController = controller;
        super.init(frame: CGRectMake(0,0,0,0));
        self.setModel(ref);
        
        bindEvents();
    }
    
    func getModel()->KFReference!{
        return self._model;
    }
    
    func setModel(newModel:KFReference){
        self._model = newModel;
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
        let refModel = self.getModel();
        var menues:[KFMenu] = [];
        
        let operatable = KFDefaultMenu();
        operatable.name = "Operatable";
        operatable.checked = refModel.isOperatable();
        operatable.exec = {
            refModel.setOperatable(!refModel.isOperatable());
            operatable.checked = refModel.isOperatable();
            self.updateFromModel();
            self.mainController.updatePostRef(self);
        }
        
        let border = KFDefaultMenu();
        border.name = "Border";
        border.checked = refModel.isBorder();
        border.exec = {
            refModel.setBorder(!refModel.isBorder());
            border.checked = refModel.isBorder();
            self.updateFromModel();
            self.mainController.updatePostRef(self);
        }

        let fitscale = KFDefaultMenu();
        fitscale.name = "FitScale";
        fitscale.checked = refModel.isFitScale();
        fitscale.exec = {
            refModel.setFitScale(!refModel.isFitScale())
            fitscale.checked = refModel.isFitScale();
            self.updateFromModel();
            self.mainController.updatePostRef(self);
        }
        
        return [operatable, border, fitscale];
    }
    
    func updatePanEventBinding(){
        if(!self.getModel().isLocked() && self.panGesture == nil){
            self.panGesture = UIPanGestureRecognizer(target:self, action:"handlePanning:");
            self.addGestureRecognizer(self.panGesture!);
        }else if(self.getModel().isLocked() && self.panGesture != nil){
            self.removeGestureRecognizer(self.panGesture!);
            self.panGesture = nil;
        }
    }
    
    func kfSetSize(width:CGFloat, height:CGFloat){
        self.getModel().width = width;
        self.getModel().height = height;
        self.updateFromModel();
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if(!getModel().isLocked()){
            mainController.suppressScroll();
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        mainController.unlockSuppressScroll();
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
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
        if(!border && getModel().isBorder() && getModel().isShowInPlace()){
            self.layer.borderColor = UIColor.grayColor().CGColor;
            self.layer.borderWidth = 1.0;
            border = true;
        }else if (border && (!getModel().isBorder() || !getModel().isShowInPlace())){
            self.layer.borderWidth = 0.0;
            border = false;
        }
        
        let r = self.frame;
        self.frame = CGRectMake(getModel().location.x, getModel().location.y, r.size.width, r.size.height);
    }
    
    //    func die(){
    //
    //    }
}
