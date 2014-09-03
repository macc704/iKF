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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(controller: KFCanvasViewController, ref: KFReference) {
        super.init(controller: controller, ref: ref);
        //bindEvents();
        

        //self.backgroundColor = UIColor.lightGrayColor();
    }
    
    override func setModel(newModel: KFReference) {
        if(getModel() != nil){
            getModel().post?.detach(self);
            self.attachedTo = nil;
        }
        
        super.setModel(newModel);
        
        if(getModel() != nil){
            getModel().post!.attach(self, selector: "noteChanged");
            self.attachedTo = getModel().post;
            if(refView is KFLabelNoteRefView){
                (refView? as KFLabelNoteRefView).model = getModel();
            }
        }
    }
    
    func noteChanged(){
        self.updateFromModel();
    }
    
    var cache:String?;
    var wasFitScale = false;
      
    override func updateFromModel(){
        super.updateFromModel();
        
        var createIcon = false;
        var createUnfold = false;
        if(refView is KFLabelNoteRefView && self.getModel().isShowInPlace()){
            refView!.removeFromSuperview();
            createUnfold = true;
        }
        else if(refView is KFWebView && !self.getModel().isShowInPlace()){
            refView!.removeFromSuperview();
            createIcon = true;
        }
        else if(refView == nil && self.getModel().isShowInPlace()){
            createUnfold = true;
        }
        else if(refView == nil && !self.getModel().isShowInPlace()){
            createIcon = true;
        }

        if(createIcon){
            if(refView != nil && refView is KFWebView){
                (refView as KFWebView).close();
            }
            refView = KFLabelNoteRefView(ref: getModel());
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
            if(wasFitScale == false && getModel().isFitScale() == true){
                (refView as KFWebView).scalesPageToFit = true;
                wasFitScale = true;
                cache = "";
            }
            else if(wasFitScale == true && getModel().isFitScale() == false){
                (refView as KFWebView).scalesPageToFit = false;
                wasFitScale = false;
                cache = "";
            }
        }
        
        if(refView is KFLabelNoteRefView){
            (refView? as KFLabelNoteRefView).updateFromModel();
        }
        if(refView is KFWebView){
            let note = getModel().post as KFNote;
            if(note.content != cache){
                //let template = KFService.getInstance().getReadTemplate();
                //let html = template!.stringByReplacingOccurrencesOfString("%YOURCONTENT%", withString:note.content);                
                (refView as KFWebView).loadHTMLString(note.getReadHtml(), baseURL: KFResource.getWebResourceURL());
                cache = note.content;
            }
            refView!.frame = CGRectMake(0, 0, getModel().width, getModel().height);
        }
      
        self.frame.size = refView!.frame.size;        //only size
        
        if(operatableHandle == nil && getModel().isOperatable() && refView is KFWebView){
            operatableHandle = UIView();
            operatableHandle.backgroundColor = UIColor.grayColor();
            operatableHandle.frame = CGRectMake(self.frame.size.width-40,0, 40, 40);
            let recognizerDoubleTap = UITapGestureRecognizer(target:self, action:"handleDoubleTap:");
            recognizerDoubleTap.numberOfTapsRequired = 2;
            operatableHandle.addGestureRecognizer(recognizerDoubleTap);
            self.addSubview(operatableHandle);
            (refView as KFWebView).userInteractionEnabled = true;
        }else if (operatableHandle != nil && (!getModel().isOperatable() || !(refView is KFWebView))){
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
