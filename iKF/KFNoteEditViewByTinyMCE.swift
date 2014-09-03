//
//  KFNoteEditViewByTinyMCE.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNoteEditViewByTinyMCE: KFAbstractNoteEditView, UIWebViewDelegate {
    
    var containerView:UIView!;
    var titleLabel:UILabel!;
    var titleView:UITextField!;
    var sourceLabel:UILabel!;
    var webView:KFWebView!;
    
    private var cachedTitle:String?;
    
    private var portrait = true;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init();

        // container
        containerView = UIView();
        self.addSubview(containerView);
        
        // titleview
        titleLabel = UILabel();
        titleLabel.text = "Title:";
        titleLabel.font = UIFont.systemFontOfSize(24);
        containerView.addSubview(titleLabel);
        
        titleView = UITextField();
        titleView.font = UIFont.systemFontOfSize(24);
        titleView.layer.borderColor = UIColor.blackColor().CGColor;
        titleView.layer.borderWidth = 1.0;
        containerView.addSubview(titleView);
        
        
        // textview
        sourceLabel = UILabel();
        sourceLabel.text = "Editor:";
        sourceLabel.font = UIFont.systemFontOfSize(24);
        containerView.addSubview(sourceLabel);
        
        webView = KFWebView.create();
        webView.delegate = self;
        webView.performPasteAsReference = {(text:String)->() in
            self.insertText(text);
        };
        webView.scrollView.scrollEnabled = false;
        webView.layer.borderColor = UIColor.blackColor().CGColor;
        webView.layer.borderWidth = 1.0;
        containerView.addSubview(webView);
    }
    
    private func pasteAsReference(text:String){
        self.insertText(text);
    }
    
    override func insertText(text:String) {
        let insertString = KFResource.encodingForJS(text);
        webView.stringByEvaluatingJavaScriptFromString("tinymce.activeEditor.insertContent('\(insertString)')");
    }
    
    override func setText(text:String, title:String) {
        self.setNavBarTitle("Edit");
        self.cachedTitle = title;
        titleView.text = title;
        
        let setString = KFResource.encodingForJS(text);
        if(self.isInitialized()){
            webView.stringByEvaluatingJavaScriptFromString("tinymce.activeEditor.setContent('\(setString)')");
            webView.stringByEvaluatingJavaScriptFromString(getSetHeightJS());
            return;
        }
        
        //else not initialized
        webView.stringByEvaluatingJavaScriptFromString("window.onload = function(){tinymce.activeEditor.setContent('\(setString)');\(getSetHeightJS())}");
        
        let path = NSBundle.mainBundle().pathForResource("edit", ofType: "html", inDirectory: "WebResources");
        let req = NSURLRequest(URL: NSURL(string: path!));
        webView.loadRequest(req);
    }
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        //        NSLog(@"shoud start? = %@", [request URL]);
        return true;
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
    }
    
    func isInitialized()->Bool{
        let res = webView.stringByEvaluatingJavaScriptFromString("tinymce.activeEditor.isDirty();");
        if(res == nil || res!.isEmpty){
            return false;
        }
        return true;
    }
    
    override func getText() -> String?{
        return webView.stringByEvaluatingJavaScriptFromString("tinymce.activeEditor.getContent();");
    }
    
    override func getTitle() -> String?{
        return titleView.text;
    }
    
    override func layoutContentWithRect(rect: CGRect) {
        containerView.frame = rect;
        
        //_textView.frame = CGRectMake(100,100,100,100);
        var x:CGFloat = 20.0;
        var y:CGFloat = 20.0;
        let fullWidth = rect.size.width-40;
        let fullHeight = rect.size.height-40;
        
        self.portrait = fullWidth < fullHeight;
        
        //title label
        titleLabel.frame = CGRectMake(x, y, 100, 35);
        titleView.frame = CGRectMake(x+100, y, fullWidth-100, 35);
        y=y+40;
        
        //source label
        sourceLabel.frame = CGRectMake(x, y, fullWidth, 35);
        if(portrait){
            y=y+40;
            webView.frame = CGRectMake(x, y, fullWidth, 520);
            if(isInitialized()){
                webView.stringByEvaluatingJavaScriptFromString(getSetHeightJS());
            }
        }else{//landscape
            webView.frame = CGRectMake(x+100, y, fullWidth-100, 220);
            if(isInitialized()){
                webView.stringByEvaluatingJavaScriptFromString(getSetHeightJS());
            }
        }
    }
    
    private func getSetHeightJS() -> String{
        if(portrait){
            return "document.getElementById('mcearea1').style.height='400px';";
        }else{//landscape
            return "document.getElementById('mcearea1').style.height='110px';";
        }
    }
    
    override func isDirty() -> Bool{
        return isTitleDirty() || isTextDirty();
    }
    
    private func isTitleDirty() -> Bool {
        return cachedTitle != nil && cachedTitle! == titleView.text;
    }
    
    private func isTextDirty() -> Bool{
        let res = webView.stringByEvaluatingJavaScriptFromString("tinymce.activeEditor.isDirty();");
        println(res)
        return res == "true";
    }
    
    //NSString* newTitle = [self.editView getTitle];
    //bool dirty = false;
    //if(![newTitle isEqualToString: self.note.title]){
    //    dirty = true;
    //}
    //NSString* newContent = [self.editView getText];
    //if(![newContent isEqualToString: self.note.content]){
    //    dirty = true;
    //}
    //
    //if(dirty){
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
    // Drawing code
    }
    */
    
}
