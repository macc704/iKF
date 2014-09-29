//
//  KFTinyMCEView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-29.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFTinyMCEView: KFWebView {

    private var areaHeight = 400;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init();
        
        self.performPasteAsReference = {(text:String)->() in
            self.insertText(text);
        };
        self.performPasteAsHtml = {(text:String)->() in
            self.insertText(text);
        };
        self.scrollView.scrollEnabled = true;
        self.scrollView.bounces = false;
    }
    
    func insertSupport(support:KFSupport){
        var insertString = KFNote.createSupportTag(support);
        self.insertText(insertString);
    }
    
    func insertText(text:String) {
        self.evalJavascript("tinymce.activeEditor.insertContent('\(KFWebView.encodingForJS(text))');");
    }
    
    func setText(text:String) {
        if(self.isInitialized()){
            self.evalJavascript(setTextJS(text));
            self.evalJavascript(getSetHeightJS());
            return;
        }else{//else not initialized
            self.evalJavascript("window.onload = function(){\(setTextJS(text))\(getSetHeightJS())}");
            let path = NSBundle.mainBundle().pathForResource("edit", ofType: "html", inDirectory: "WebResources");
            let req = NSURLRequest(URL: NSURL(string: path!));
            self.loadRequest(req);
        }
    }
    
    func getText() -> String?{
        return self.evalJavascript("tinymce.activeEditor.getContent();");
    }
    
    private func setTextJS(text:String) -> String {
        return "tinymce.activeEditor.setContent('\(KFWebView.encodingForJS(text))');";
    }
    
    private func getSetHeightJS() -> String {
        return "document.getElementById('mcearea1').style.height='\(areaHeight)px';";
    }
    
    func refreshAreaHeight(height:Int){
        if(self.areaHeight == height){
            return;
        }
        self.areaHeight = height;
        if(isInitialized()){
            self.evalJavascript(getSetHeightJS());
        }
    }
   
    func isInitialized() -> Bool{
        let res = isDirtyEval();
        if(res == nil || res!.isEmpty){
            return false;
        }
        return true;
    }
    
    func isDirty() -> Bool{
        return isDirtyEval() == "true";
    }
    
    private func isDirtyEval() -> String?{
        return self.evalJavascript("tinymce.activeEditor.isDirty();");
    }
    
}
