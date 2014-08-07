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
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(controller: KFCanvasViewController, ref: KFReference) {
        super.init(controller: controller, ref: ref);
        //bindEvents();
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
        //self.backgroundColor = UIColor.lightGrayColor();
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
    
    var cache:String?;
      
    override func updateFromModel(){
        super.updateFromModel();
        if(attachedTo != nil && attachedTo != model.post){
            model.post?.detach(self);
        }
        if(attachedTo == nil){
            model.post!.attach(self, selector: "noteChanged");
            self.attachedTo = model.post;
        }
        
        var createIcon = false;
        var createUnfold = false;
        if(refView is KFLabelNoteRefView && self.model.isShowInPlace()){
            refView!.removeFromSuperview();
            createUnfold = true;
        }
        else if(refView is KFWebView && !self.model.isShowInPlace()){
            refView!.removeFromSuperview();
            createIcon = true;
        }
        else if(refView == nil && self.model.isShowInPlace()){
            createUnfold = true;
        }
        else if(refView == nil && !self.model.isShowInPlace()){
            createIcon = true;
        }

        if(createIcon){
            refView = KFLabelNoteRefView(ref: model);
            self.addSubview(refView!);
        }
        if(createUnfold){
            refView = KFWebView();
            refView!.userInteractionEnabled = false;
            self.addSubview(refView!);
        }
        
        //update model to view
        if(refView is KFLabelNoteRefView){
            (refView? as KFLabelNoteRefView).updateFromModel();
        }
        if(refView is KFWebView){
            let refModel = model as KFReference;
            let note = refModel.post as KFNote;
            if(note.content != cache){
                let template = KFService.getInstance().getReadTemplate();
                let html = template!.stringByReplacingOccurrencesOfString("%YOURCONTENT%", withString:note.content);
                (refView as KFWebView).loadHTMLString(html, baseURL: nil);
                cache = note.content;
            }
            refView!.frame = CGRectMake(0, 0, refModel.width, refModel.height);
        }
        
        
        //only size
        self.frame.size = refView!.frame.size;
    }
    
    override func tapA(){
        self.mainController.openPost(self);
    }
    
}
