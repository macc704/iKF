//
//  KFWebBrowserView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-01.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFWebBrowserView: UIView, UIWebViewDelegate {
    
    //    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView! {
    //        let hitView = super.hitTest(point, withEvent: event);
    //        if(hitView == self){
    //            return nil;
    //        }else{
    //            return hitView;
    //        }
    //    }
    
    let statusBar:UIView = UIView();
    private let titleLabel:UILabel = UILabel();
    private let webView:iKFWebView = iKFWebView();
    
    //    private let toolContainer:UIView = UIView();
    private let toolContainer:UIView = UIView();
    
    private var urlTextfield:UITextField?;
    private var backButton:UIButton?;
    private var forwardButton:UIButton?;
    private var closeButton:UIButton?;
    private var reloadButton:UIButton?;
    private var stopButton:UIButton?;
    
    init() {
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        
        //this
        self.layer.borderColor = UIColor.blackColor().CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
        
        //status bar
        statusBar.backgroundColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1);
        statusBar.layer.borderColor = UIColor.blackColor().CGColor;
        statusBar.layer.borderWidth = 1.0;
        self.addSubview(statusBar);
        titleLabel.text = "hoge";
        titleLabel.textAlignment = NSTextAlignment.Center;
        titleLabel.sizeToFit();
        statusBar.addSubview(titleLabel);
        closeButton = createButton("X", selector: "close", border: false);
        statusBar.addSubview(closeButton);
        
        //tool bar
        toolContainer.backgroundColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1);
        toolContainer.layer.borderColor = UIColor.blackColor().CGColor;
        toolContainer.layer.borderWidth = 1.0;
        self.addSubview(toolContainer);
        backButton = createButton("<", selector: "back", border: true);
        toolContainer.addSubview(backButton);
        forwardButton = createButton(">", selector: "forward", border: true);
        toolContainer.addSubview(forwardButton);
        urlTextfield = UITextField();
        toolContainer.addSubview(urlTextfield);
        reloadButton = createButton("Go", selector: "reload", border: true);
        toolContainer.addSubview(reloadButton);
        stopButton = createButton("x", selector: "stop", border: true);
        toolContainer.addSubview(stopButton);
        
        //web view
        webView.delegate = self;
        webView.scalesPageToFit = true;
        self.addSubview(webView);
        
        //gestures
        let panGesture = UIPanGestureRecognizer(target: self, action: "pan:");
        self.statusBar.addGestureRecognizer(panGesture);
        let tapGestureDouble = UITapGestureRecognizer(target: self, action: "tapDouble:")
        tapGestureDouble.numberOfTapsRequired = 2;
        self.statusBar.addGestureRecognizer(tapGestureDouble);
        let tapGestureSingle = UITapGestureRecognizer(target: self, action: "tapSingle:")
        tapGestureSingle.numberOfTapsRequired = 1;
        self.addGestureRecognizer(tapGestureSingle);
    }
    
    func pan(recognizer:UIPanGestureRecognizer){
        switch(recognizer.state){
        case .Began:
            self.superview.bringSubviewToFront(self);
            break;
        case .Changed:
            let location = recognizer.translationInView(statusBar);
            let movePoint = CGPoint(x:self.center.x+location.x, y:self.center.y+location.y);
            self.center = movePoint;
            recognizer.setTranslation(CGPointZero, inView: statusBar);
            break;
        case .Ended:
            break;
        default:
            break;
        }
    }
    
    var doubleTapHandler:(()->())?;

    func tapDouble(recognizer:UITapGestureRecognizer){
        if(doubleTapHandler){
            doubleTapHandler!();
        }
    }
    
    func tapSingle(recognizer:UITapGestureRecognizer){
        // do nothing just suppress propagation
        self.superview.bringSubviewToFront(self);
    }

    
    func createButton(text:String, selector:Selector, border:Bool) -> UIButton{
        let b = UIButton();
        b.setTitle(text, forState: UIControlState.Normal);
        b.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        b.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled);
        b.backgroundColor = UIColor.whiteColor();
        if(border){
            b.layer.borderColor = UIColor.blackColor().CGColor;
            b.layer.borderWidth = 1.0;
        }
        b.layer.cornerRadius = 5;
        b.layer.masksToBounds = true;
        b.sizeToFit();
        let r = UITapGestureRecognizer(target: self, action: selector);
        r.numberOfTouchesRequired = 1;
        b.addGestureRecognizer(r);
        return b;
    }
    
    func close(){
        setURL("about:blank");
        self.removeFromSuperview();
    }
    
    func forward(){
        webView.goForward();
    }
    
    func back(){
        webView.goBack();
    }
    
    func reload(){
        let url = urlTextfield!.text;
        setURL(url);
    }
    
    func stop(){
        webView.stopLoading();
    }
    
    func setURL(url:String){
        let url = NSURL(string: url);
        let req = NSURLRequest(URL: url);
        webView.loadRequest(req);
    }
    
    var suppressWebLayout = false;
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        let width:CGFloat = self.frame.size.width;
        let height:CGFloat = self.frame.size.height;
        
        self.statusBar.frame = CGRectMake(0,0,width,22);
        self.titleLabel.frame = CGRectMake(21,1,width-40,20);
        self.closeButton!.frame = CGRectMake(width - self.closeButton!.frame.size.width, 1, 20, 20);
        
        self.toolContainer.frame = CGRectMake(0,22,width,44);
        var x = CGFloat(5);
        self.backButton!.frame = CGRectMake(x,5,35,35);
        x += 40;
        self.forwardButton!.frame = CGRectMake(x,5,35,35);
        var tfWidth:CGFloat = width;
        tfWidth -= 10;
        tfWidth -= (40 * 4);
        let tmp = tfWidth > 30;
        tfWidth = tmp ? tfWidth : 30;
        x += 40;
        self.urlTextfield!.frame = CGRectMake(x,5,tfWidth,35);
        x += tfWidth + 10;
        self.reloadButton!.frame = CGRectMake(x,5,35,35);
        x += 40;
        self.stopButton!.frame = CGRectMake(x,5,35,35);
        
        if(!suppressWebLayout){
            self.webView.frame = CGRectMake(0,22+44,width,height-22-44);
        }
        
        //self.webView.scrollView.zoomToRect(self.webView.frame, animated: false);//does not work
    }
    
    func reLayoutSubViews(){
    }
    
    let loading = KFLoadingView();
    
    func webViewDidStartLoad(webView: UIWebView!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        loading.showOnView(webView);
        updateStatus();
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        loading.hide();
        updateStatus();
        self.titleLabel.text = getTitle();
        self.urlTextfield!.text = getURL();
        //self.webView.scrollView.zoomToRect(self.webView.frame, animated: false);
    }
    
    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        loading.hide();
        updateStatus();
        KFAppUtils.showAlert("Error", msg: "Error for URL: " + self.urlTextfield!.text);
    }
    

//    - (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error | ウェ
    
    func updateStatus(){

        //println(webView.canGoBack);
        backButton!.enabled = webView.canGoBack;
        //println(webView.canGoForward);
        forwardButton!.enabled = webView.canGoForward;
        //reloadButton!.enabled = !(webView.loading);
        stopButton!.enabled = webView.loading;
    }
    
    func getTitle() -> String{
        return webView.stringByEvaluatingJavaScriptFromString("document.title");
    }
    
    func getURL() -> String{
        return webView.stringByEvaluatingJavaScriptFromString("document.URL");
    }
    
    
}
