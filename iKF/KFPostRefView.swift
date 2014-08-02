//
//  KFPostRefView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFPostRefView: UIView {
    
    var mainController: KFCanvasViewController;
    var model: KFReference;
    private var panGesture:UIPanGestureRecognizer?;
    
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
    
    func updatePanEventBinding(){
        if(!self.model.isLocked() && self.panGesture == nil){
            self.panGesture = UIPanGestureRecognizer(target:self, action:"handlePanning:");
            self.addGestureRecognizer(self.panGesture);
        }else if(self.model.isLocked() && self.panGesture != nil){
            self.removeGestureRecognizer(panGesture);
            self.panGesture = nil;
        }
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
            self.superview.bringSubviewToFront(self);
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
    
    func updateFromModel(){
        let r = self.frame;
        self.frame = CGRectMake(model.location.x, model.location.y, r.size.width, r.size.height);
    }
    
    //    func die(){
    //
    //    }
}
