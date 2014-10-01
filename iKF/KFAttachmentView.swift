//
//  KFAttachmentView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-10-01.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFAttachmentView: UIView, UIWebViewDelegate {
    
    private var post:KFPost!;
    private var selectedHandler:((NSURLRequest)->())!;
    
    private var _attachmentView:KFWebView!;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(post:KFPost, selectedHandler:((NSURLRequest)->())){
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        
        self.post = post;
        self.selectedHandler = selectedHandler;
        
        self._attachmentView = KFWebView.create();
        self._attachmentView.scrollView.scrollEnabled = true;
        self._attachmentView.layer.borderWidth = 1;
        self._attachmentView.layer.borderColor = UIColor.blackColor().CGColor;
        self._attachmentView.delegate = self;
        self.addSubview(self._attachmentView);

        reload();
    }
    
    func reload(){
        var html = "<html><head></head><body><h2>Attachments:</h2><ul>";
        for att in post.attachments{
            html = html + "<li><a href='\(att.url)'>\(att.title)</a></li>";
        }
        html = html + "</ul></body></html>";
        self._attachmentView.loadHTMLString(html, baseURL:KFResource.getWebResourceURL());
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.URL.scheme! == "http"){
            selectedHandler(request);
            return false;
        }
        return true;
    }
    
    override func layoutSubviews() {
        _attachmentView.frame.size = self.frame.size;
        println(self.frame.size);
    }
}
