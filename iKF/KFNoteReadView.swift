//
//  KFNoteReadView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNoteReadView: KFAbstractNoteView{
    
    var _webView:KFWebView!;
    private var _attachmentView:KFAttachmentView?;
    
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
        
        if(model.attachments.count > 0 && _attachmentView == nil){
            _attachmentView = KFAttachmentView(post: model, selectedHandler: {req in
                self._webView.loadRequest(req);
                return;
            });
            self.addSubview(_attachmentView!);
        }
        else if(model.attachments.count > 0 && _attachmentView != nil){
            _attachmentView?.reload();
        }
        else if(model.attachments.count <= 0 && _attachmentView != nil){
            _attachmentView?.removeFromSuperview();
            _attachmentView = nil;
        }
        
        self.setNavBarTitle(self.model!.title);
        self._webView.loadHTMLString(self.model!.getReadHtml(), baseURL:self.model!.getBaseURL());
    }
    
    override func layoutContentWithRect(rect: CGRect) {
        if(_attachmentView == nil){
            let newRect = CGRectMake(rect.origin.x+20, rect.origin.y+20, rect.size.width-40, rect.size.height-40);
            self._webView.frame = newRect;
        }else{
            let newRect = CGRectMake(rect.origin.x+20, rect.origin.y+20, rect.size.width-40, rect.size.height-40-170);
            self._webView.frame = newRect;
            let attachRect = CGRectMake(rect.origin.x+20, newRect.origin.y + newRect.size.height+20, rect.size.width-40, 150);
            self._attachmentView!.frame = attachRect;
        }
    }
    
}
