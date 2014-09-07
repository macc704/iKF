//
//  KFMobileCometManager.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-05.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFMobileCometManager: NSObject, UIWebViewDelegate {
    
    private let webView = UIWebView();
    
    private var host:String!;
    private var username:String!;
    private var password:String!;
    
    private var onLoginProcess = false;
    
    var busFailed:(()->())?;
    var busInitialized:(()->())?;
    var messageReceived:((type:String?, method:String?, target:String?)->())?
    
    override init(){
        super.init();
        webView.delegate = self;
    }
    
    func start(host:String, username:String, password:String){
        self.host = host;
        self.username = username;
        self.password = password;
        requestLogin();
    }
    
    func stop(){
        let req = NSURLRequest(URL: NSURL(string: "about:blank"));
        self.webView.loadRequest(req);
    }
    
    private func requestLogin(){
        let req = KFHttpRequest(urlString: "http://\(host)/kforum/rest/account/userLogin", method: "POST");
        req.addParam("userName", value: username);
        req.addParam("password", value: password);
        req.updateParams();
        onLoginProcess = true;
        webView.loadRequest(req.nsRequest);
    }
    
    private func requestCometPage(){
        let req = KFHttpRequest(urlString: "http://\(host)/kforum/mobilecomet.html", method: "GET");
        webView.loadRequest(req.nsRequest);
    }
    
    func subscribeViewEvent(viewId:String) -> Bool{
        let res = webView.stringByEvaluatingJavaScriptFromString("subscribeViewEvent('\(viewId)');");
        return res != nil && res! == "true";
    }
    
    func subscribeCommunityEvent(communityId:String) -> Bool{
        let res = webView.stringByEvaluatingJavaScriptFromString("subscribeCommunityEvent('\(communityId)');");
        return res != nil && res! == "true";
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let host = request.URL.host;
        if(host != nil && host == "kfbus.initialized"){
            busInitialized?();
            return false;
        }
        if(host != nil && host == "kfbus.receiveevent"){
            var jsonStr = request.URL.lastPathComponent;
            let json = JSON.parse(jsonStr);
            messageReceived?(type: json["type"].asString, method: json["method"].asString, target: json["target"].asString);
            return false;
        }
        return true;
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if(onLoginProcess == true){
            onLoginProcess = false;
            requestCometPage();
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        if(onLoginProcess == true){
            onLoginProcess = false;
        }
        busFailed?();
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
