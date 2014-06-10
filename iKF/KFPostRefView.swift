//
//  KFPostRefView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFPostRefView: UIView {

    var mainController: iKFMainViewController;
    
    var model: KFReference;
   
    init(controller: iKFMainViewController, ref: KFReference) {
        mainController = controller;
        self.model = ref;
        
        super.init(frame: CGRectMake(0,0,0,0));
    }
    
    func bindEvents(){
        //Pan
        self.addGestureRecognizer(UIPanGestureRecognizer(target:self, action:"handlePanning:"));
        
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
    
    func makeShadow(){
        self.layer.shadowColor = UIColor.blackColor().CGColor;
        self.layer.shadowOpacity = 0.7;
        self.layer.shadowOffset = CGSizeMake(10.0, 10.0);
        self.layer.shadowRadius = 5.0;
        self.layer.masksToBounds = false;
        let path = UIBezierPath(rect: self.bounds);
        self.layer.shadowPath = path.CGPath;
    }
    
    func removeShadow(){
        self.layer.shadowOpacity = 0.0;
    }    
    
    func handleSingleTap(recognizer: UIGestureRecognizer){
        self.openPopupViewer();
    }
                            
    func handleDoubleTap(recognizer: UIGestureRecognizer){
        mainController.showHandle(self);
    }

    var notePopupController: iKFNotePopupViewController?;
    var popoverController: UIPopoverController?;
    
    //これはkfMainへ移動すること
    func openPopupViewer(){
        let newPopupController = iKFNotePopupViewController();
        newPopupController.note = (self.model.post as KFNote);

        newPopupController.kfViewController = mainController;
        newPopupController.contentSizeForViewInPopover = newPopupController.view.frame.size;
        self.notePopupController = newPopupController;
        
        popoverController = UIPopoverController(contentViewController: notePopupController);
        popoverController?.presentPopoverFromRect(self.frame, inView: self.superview, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true);
    }
    
    func die(){
       self.mainController.removeNote(self);
    }
}