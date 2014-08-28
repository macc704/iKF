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
    var wasFitScale = false;
      
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
            if(refView != nil && refView is KFWebView){
                (refView as KFWebView).close();
            }
            refView = KFLabelNoteRefView(ref: model);
            self.addSubview(refView!);
        }
        if(createUnfold){
            cache = "";
            refView = KFWebView.createAsPost();
            refView!.userInteractionEnabled = false;
            self.addSubview(refView!);
        }
        
        //update model to view
        if(refView is KFWebView){
            if(wasFitScale == false && model.isFitScale() == true){
                (refView as KFWebView).scalesPageToFit = true;
                wasFitScale = true;
                cache = "";
            }
            else if(wasFitScale == true && model.isFitScale() == false){
                (refView as KFWebView).scalesPageToFit = false;
                wasFitScale = false;
                cache = "";
            }
        }
        
        if(refView is KFLabelNoteRefView){
            (refView? as KFLabelNoteRefView).updateFromModel();
        }
        if(refView is KFWebView){
            let refModel = model as KFReference;
            let note = refModel.post as KFNote;
            if(note.content != cache){
                //let template = KFService.getInstance().getReadTemplate();
                //let html = template!.stringByReplacingOccurrencesOfString("%YOURCONTENT%", withString:note.content);                
                (refView as KFWebView).loadHTMLString(note.getReadHtml(), baseURL: KFResource.getWebResourceURL());
                cache = note.content;
            }
            refView!.frame = CGRectMake(0, 0, refModel.width, refModel.height);
        }
      
        self.frame.size = refView!.frame.size;        //only size
        
        if(operatableHandle == nil && model.isOperatable() && refView is KFWebView){
            operatableHandle = UIView();
            operatableHandle.backgroundColor = UIColor.grayColor();
            operatableHandle.frame = CGRectMake(self.frame.size.width-40,0, 40, 40);
            let recognizerDoubleTap = UITapGestureRecognizer(target:self, action:"handleDoubleTap:");
            recognizerDoubleTap.numberOfTapsRequired = 2;
            operatableHandle.addGestureRecognizer(recognizerDoubleTap);
            self.addSubview(operatableHandle);
            (refView as KFWebView).userInteractionEnabled = true;
        }else if (operatableHandle != nil && (!model.isOperatable() || !(refView is KFWebView))){
            if(refView is KFWebView){
                (refView as KFWebView).userInteractionEnabled = false;
            }
            operatableHandle.removeFromSuperview();
            operatableHandle = nil;
        }
        if(operatableHandle != nil && refView is KFWebView){
            operatableHandle.frame = CGRectMake(self.frame.size.width-40,0, 40, 40);
        }
        

        
    }
    
    var operatableHandle:UIView!;
    
    override func tapA(){
        self.mainController.openPost(self);
    }
    
}
