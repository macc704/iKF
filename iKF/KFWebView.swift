//
//  KFWebView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class WeakReference<T: AnyObject> {
    weak var value: T?
    init (value: T) {
        self.value = value
    }
}

private var postInstances:[WeakReference<KFWebView>] = [];
private var instances:[WeakReference<KFWebView>] = [];//others

class KFWebView: UIWebView {
    
    class func createAsPost() -> KFWebView{
        let one = KFWebView();
        postInstances.append(WeakReference(value: one));
        return one;
    }
    
    class func create() -> KFWebView{
        let one = KFWebView();
        instances.append(WeakReference(value: one));
        return one;
    }
    
    class func clearPostInstances(){
        for instance in postInstances{
            if(instance.value != nil){
                instance.value!.close();
            }
        }
        postInstances = [];
    }
    
    class func clearAllInstances(){
        self.clearPostInstances();
        for instance in instances{
            if(instance.value != nil){
                instance.value!.close();
            }
        }
        instances = [];
    }
    
    var performPasteAsReference:((String)->())?;//(id)
    var performPasteAsHtml:((String)->())?;
    var kfModel:KFModel?;//KFModel*
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        //TODO to global
        let pasteReference = UIMenuItem(title: "Paste As Reference", action: Selector("onPasteAsReference:"));
        let pasteHtml = UIMenuItem(title: "Paste As HTML", action: Selector("onPasteAsHtml:"));
        UIMenuController.sharedMenuController().menuItems = [pasteReference, pasteHtml];
    }
    
    /*****************************
    * Utilities
    ******************************/
    
    func close(){
        self.setURL("about:blank");
    }
    
    func setURL(url:String){
        let url = NSURL(string: url);
        let req = NSURLRequest(URL: url!);
        self.loadRequest(req);
    }
    
    class func encodingForJS(text:String) -> String{
        var encoded = text;
        //order important
        encoded = encoded.stringByReplacingOccurrencesOfString("\\", withString: "\\\\");
        encoded = encoded.stringByReplacingOccurrencesOfString("\r", withString: "");
        encoded = encoded.stringByReplacingOccurrencesOfString("\n", withString: "");
        encoded = encoded.stringByReplacingOccurrencesOfString("'", withString: "\\'");
        return encoded;
    }
    
    func evalJavascript(js:String) -> String?{
        return self.stringByEvaluatingJavaScriptFromString(js);
    }
    
    /*****************************
    * Copy and Pasting
    ******************************/
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        if(action == Selector("onPasteAsHtml:")){
            return self.performPasteAsHtml != nil;
        }
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
            pasteString = KFNote.createReferenceContentTag(guid!, title: title!);
        }else{//assume postreference
            pasteString = KFNote.createReferenceNoteTag(guid!, title: title!);
        }
        self.performPasteAsReference!(pasteString);
    }
    
    func onPasteAsHtml(sender:UIMenuController){
        let pasteboard = UIPasteboard.generalPasteboard();
        let html:String! = pasteboard.string;
        self.performPasteAsHtml?(html);
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
        if(pasteboard.numberOfItems <= 0){
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

    
}
