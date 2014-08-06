//
//  KFWebView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFWebView: UIWebView {
    
    var performPasteAsReference:((String)->())?;//(id)
    var kfModel:KFModel?;//KFModel*
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        if(action == Selector("onPasteAsReference:")){
            return self.canPerformPasteAsReference();
        }
        return super.canPerformAction(action, withSender: sender);
    }
    
    private func canPerformPasteAsReference() -> Bool{
        return self.performPasteAsReference != nil && self.getValueFromPasteboard("kfmodel.guid") != nil;
    }
    
    func onPasteAsReference(sender:UIMenuController){
        if (!self.canPerformPasteAsReference()){
            return;
        }
    
        let pasteboard = UIPasteboard.generalPasteboard();
        let guid:String! = self.getValueFromPasteboard("kfmodel.guid")!;
        let type:String?/* not good! */ = self.getValueFromPasteboard("kfmodel");
        let title = pasteboard.string;
        var pasteString:String;
        if (type == "contentreference"){
            pasteString = "<kf-content-reference class=\"mceNonEditable\" postid=\"\(guid!)\">\(title)</kf-content-reference>";
        }else{//assume postreference
            pasteString = "<kf-post-reference class=\"mceNonEditable\" postid=\"\(guid!)\">\(title)</kf-post-reference>";
        }
        //        //NSLog(@"pasteString=%@", pasteString);
        self.performPasteAsReference!(pasteString);
        //        self.pasteAsReferenceTarget pasteAsReference: pasteString];
    }
    
    override func copy(sender: AnyObject!) {
        super.copy(sender);
        
        let pasteboard = UIPasteboard.generalPasteboard();
        
        if(self.kfModel != nil && pasteboard.numberOfItems > 0){
            self.putValueToPasteboard("kfmodel", value: "contentreference")
            self.putValueToPasteboard("kfmodel.guid", value: self.kfModel!.guid);
        }
    }
    
    private func getValueFromPasteboard(key:String) -> String?{
        let pasteboard = UIPasteboard.generalPasteboard();
        if(pasteboard.numberOfItems < 0){
            return nil;
        }
        
        let obj = pasteboard.items[0][key];
        if(obj! == nil){ //why obj == nil does not work? unwrap necessary if check nil
            return nil;
        }
        
        let data = obj as NSData;
        let dataStr = NSString(data:data, encoding:NSUTF8StringEncoding);
        return dataStr;
    }
    
    private func putValueToPasteboard(key:String, value:String){
        let pasteboard = UIPasteboard.generalPasteboard();
        if(pasteboard.numberOfItems < 0){
            return;
        }
        var newdic = NSMutableDictionary(dictionary:pasteboard.items[0] as NSDictionary);
        newdic[key] = value;
        pasteboard.items[0] = newdic;
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
