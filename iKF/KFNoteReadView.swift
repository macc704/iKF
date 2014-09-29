//
//  KFNoteReadView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNoteReadView: KFAbstractNoteView, UIWebViewDelegate {
    
    var _webView:KFWebView!;
    var _attachmentView:KFWebView!;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init();
        
        self._webView = KFWebView.create();
        self._webView.scrollView.scrollEnabled = true;
        self.addSubview(self._webView);
    }
    
    func load(){
        if(model == nil){
            return;
        }
        
        self.setNavBarTitle(self.model!.title);
        self._webView.loadHTMLString(self.model!.getReadHtml(), baseURL:self.model!.getBaseURL());
        
        //attachments
        if(model!.attachments.count > 0){
            if(_attachmentView == nil){
                _attachmentView = KFWebView.create();
                self._attachmentView.scrollView.scrollEnabled = true;
                self._attachmentView.layer.borderWidth = 1;
                self._attachmentView.layer.borderColor = UIColor.blackColor().CGColor;
                self._attachmentView.delegate = self;
                self.addSubview(self._attachmentView);
            }
            var html = "<html><head></head><body><h1>Attachments:</h1><ul>";
            for att in model!.attachments{
                    html = html + "<li><a href='\(att.url)'>\(att.title)</a></li>";
            }
            html = html + "</ul></body></html>";
            self._attachmentView.loadHTMLString(html, baseURL:KFResource.getWebResourceURL());
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.URL.scheme! == "http"){
            self._webView.loadRequest(request);
            return false;
        }
        return true;
    }
    
    override func layoutContentWithRect(rect: CGRect) {
        if(_attachmentView == nil){
            let newRect = CGRectMake(rect.origin.x+20, rect.origin.y+20, rect.size.width-40, rect.size.height-40);
            self._webView.frame = newRect;
        }else{
            let newRect = CGRectMake(rect.origin.x+20, rect.origin.y+20, rect.size.width-40, rect.size.height-40-220);
            self._webView.frame = newRect;
            let attachRect = CGRectMake(rect.origin.x+20, newRect.origin.y + newRect.size.height+20, rect.size.width-40, 200);
            self._attachmentView.frame = attachRect;
        }
    }
    
}
