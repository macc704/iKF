//
//  KFNoteRefView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNoteRefView: KFPostRefView {
    
    var refView:UIView?;
    
    var attachedTo:KFPost?;
    
    init(controller: KFCanvasViewController, ref: KFReference) {
        super.init(controller: controller, ref: ref);
        //bindEvents();
    }
    
    //    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView! {
    //        let hitView = super.hitTest(point, withEvent: event);
    //        if(hitView == self){
    //            return nil;
    //        }else{
    //            return hitView;
    //        }
    //    }
    
    func noteChanged(){
        self.updateFromModel();
    }
    
    override func updateFromModel(){
        super.updateFromModel();
        if(attachedTo != nil && attachedTo != model.post){
            model.post?.detach(self);
        }
        if(attachedTo == nil){
            model.post!.attach(self, selector: "noteChanged");
            self.attachedTo = model.post;
        }
        
        if(refView is KFLabelNoteRefView && self.model.isShowInPlace()){
            refView = nil;
        }
        if(refView is KFInPlaceNoteRefView && !self.model.isShowInPlace()){
            refView = nil;
        }
        if(refView == nil){
            if(self.model.isShowInPlace()){
                
            }else{
                refView = KFLabelNoteRefView(ref: model);
            }
            self.addSubview(refView);
        }
        
        if(refView is KFLabelNoteRefView){
            (refView? as KFLabelNoteRefView).updateFromModel();
        }
        
        self.frame.size = refView!.frame.size;
    }
    
    override func tapA(){
        self.mainController.openPost(self);
    }
    
}
