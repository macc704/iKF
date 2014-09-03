//
//  KFNoteReadView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNoteReadView: KFAbstractNoteView {

    var _webView:KFWebView!;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init();

        self._webView = KFWebView.create();
        self._webView.scrollView.scrollEnabled = true;
        self.addSubview(self._webView);
    }
    
    func showPage(urlString:String, title:String){
        self.setNavBarTitle(title);
        let url = NSURL(string: urlString);
        let req = NSURLRequest(URL: url);
        self._webView.loadRequest(req);
    }

    func showHTML(textString:String, title:String){
        self.setNavBarTitle(title);
        let template = KFResource.loadReadTemplate();
        let html = template.stringByReplacingOccurrencesOfString("%YOURCONTENT%", withString:textString);
        self._webView.loadHTMLString(html, baseURL:KFResource.getWebResourceURL());
    }    
    
    override func layoutContentWithRect(rect: CGRect) {
        let newRect = CGRectMake(rect.origin.x+20, rect.origin.y+20, rect.size.width-40, rect.size.height-40);
        self._webView.frame = newRect;
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
