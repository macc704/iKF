//
//  KFWebBrowserView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-01.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFWebBrowserView: KFDropTargetView, UIWebViewDelegate {
    
    var mainController:KFCanvasViewController?;
    
    let BORDER_COLOR = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0);
    let TITLEBAR_COLOR = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 0.8);
    
    let statusBar:UIView = UIView();
    private let titleLabel:UILabel = UILabel();
    private let webView = KFWebView.create();
    
    private var _attachmentView:KFAttachmentView?;
    
    private let toolContainer:UIView = UIView();
    
    private var urlTextfield:UITextField?;
    private var backButton:UIButton?;
    private var forwardButton:UIButton?;
    private var closeButton:UIButton?;
    private var reloadButton:UIButton?;
    private var stopButton:UIButton?;
    
    private var showToolBar = true;
    
    var noteRef:KFPostRefView?;//model is wrong this is temporary
    var note:KFNote?;
    
    private var dummyRef:KFViewRefView?;
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        mainController?.suppressScroll();
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
        mainController?.unlockSuppressScroll();
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        mainController?.unlockSuppressScroll();
    }
    
    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(showToolBar:Bool = true) {
        self.showToolBar = showToolBar;
        
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        
        //this
        self.layer.borderColor = BORDER_COLOR.CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
        
        //status bar
        statusBar.backgroundColor = TITLEBAR_COLOR;
        statusBar.layer.borderColor = BORDER_COLOR.CGColor;
        statusBar.layer.borderWidth = 1.0;
        self.addSubview(statusBar);
        titleLabel.text = "";
        titleLabel.backgroundColor = UIColor.clearColor();
        titleLabel.textAlignment = NSTextAlignment.Center;
        titleLabel.sizeToFit();
        statusBar.addSubview(titleLabel);
        closeButton = createButton("X", selector: "close", border: false);
        closeButton!.backgroundColor = UIColor.clearColor();
        statusBar.addSubview(closeButton!);
        
        //tool bar
        toolContainer.backgroundColor = UIColor.whiteColor();
        toolContainer.layer.borderColor = BORDER_COLOR.CGColor;
        toolContainer.layer.borderWidth = 1.0;
        if(showToolBar && toolContainer.superview == nil){
            self.addSubview(toolContainer);
        }
        backButton = createButton("<", selector: "back", border: true);
        toolContainer.addSubview(backButton!);
        forwardButton = createButton(">", selector: "forward", border: true);
        toolContainer.addSubview(forwardButton!);
        urlTextfield = UITextField();
        urlTextfield!.backgroundColor = UIColor.whiteColor();
        toolContainer.addSubview(urlTextfield!);
        reloadButton = createButton("Go", selector: "reload", border: true);
        toolContainer.addSubview(reloadButton!);
        stopButton = createButton("x", selector: "stop", border: true);
        toolContainer.addSubview(stopButton!);
        
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
        
        //suppress canvas scrolling
        //almost ok but still parent scroll would be happened in scale up
        let noPanGesture = UIPanGestureRecognizer(target: self, action: "nopan:");
        self.addGestureRecognizer(noPanGesture);
        
        
    }
    
    func setShowToolbar(show:Bool){
        self.showToolBar = show;
        if(!showToolBar && toolContainer.superview != nil){
            toolContainer.removeFromSuperview();
        }
        else if(showToolBar && toolContainer.superview == nil){
            self.addSubview(toolContainer);
        }
    }
    
    func isShowToolbar() -> Bool{
        return self.showToolBar;
    }
    
    func nopan(recognizer:UIPanGestureRecognizer){
    }
    
    func pan(recognizer:UIPanGestureRecognizer){
        switch(recognizer.state){
        case .Began:
            self.superview!.bringSubviewToFront(self);
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
    
    override func candrop(view:UIView) -> Bool{
        if(self.note != nil && view is KFNoteRefView){
            if(self.note!.canEditMe()){
                return true;
            }
        }
        return false;
    }
    
    override func dropped(view: UIView) {
        let refNote = (view as KFNoteRefView).getModel().post! as KFNote;
        self.note!.addReference(refNote);
        self.note!.updateToServer();
    }
    
    var doubleTapHandler:(()->())?;
    
    func tapDouble(recognizer:UITapGestureRecognizer){
        if(doubleTapHandler != nil){
            doubleTapHandler!();
        }
    }
    
    func tapSingle(recognizer:UITapGestureRecognizer){
        // do nothing just suppress propagation
        self.superview!.bringSubviewToFront(self);
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
        webView.close();
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
    
    func setURL(url:String){
        self.webView.setURL(url);
    }
    
    func setRequest(req:NSURLRequest){
        self.webView.loadRequest(req);
    }
    
    func stop(){
        webView.stopLoading();
    }
    
    func kfSetNote(note:KFNote?){
        unhook();
        self.note = note;
        self.webView.kfModel = note;
        hook();
        updateFromNote();
    }
    
    private func updateFromNote(){
        if(self.note == nil){
            return;
        }
        
        webView.scalesPageToFit = false;//necessary
        self.titleLabel.text = self.note!.title;
        let html = self.note!.getReadHtml();
        let baseURL = self.note!.getBaseURL();
        self.webView.loadHTMLString(html, baseURL: baseURL);
        
        if(note!.attachments.count > 0 && _attachmentView == nil){
            _attachmentView = KFAttachmentView(post: note!, selectedHandler: {req in
                let loc = CGPointMake(self.frame.origin.x + 10, self.frame.origin.y + 10);
                self.mainController!.openBrowser(loc, size: self.frame.size, url: req.URL.absoluteString!);
                return;
            });
            self.addSubview(_attachmentView!);
            self.setNeedsLayout();
        }
        else if(note!.attachments.count > 0 && _attachmentView != nil){
            _attachmentView?.reload();
        }
        else if(note!.attachments.count <= 0 && _attachmentView != nil){
            _attachmentView?.removeFromSuperview();
            _attachmentView = nil;
            self.setNeedsLayout();
        }
    }
    
    deinit{
        unhook();
        self.note = nil;
    }
    
    private func unhook(){
        if(self.note != nil){
            self.note!.detach(self);
        }
    }
    
    private func hook(){
        if(self.note != nil){
            self.note!.attach(self, selector: "noteChanged");
        }
    }
    
    func noteOpened(){
        if(self.note == nil){
            return;
        }
        if(note!.beenRead == false){
            note!.beenRead = true;
            note!.notify();
            KFAppUtils.executeInBackThread(){
                KFService.getInstance().readPost(self.note!);
                return;
            }
        }
    }
    
    func noteChanged(){
        updateFromNote();
    }
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        let host = request.URL.host;
        if(host != nil && host == "kfpost"){
            var guid = request.URL.lastPathComponent;
            let frame = CGRectMake(self.frame.origin.x + 50, self.frame.origin.y + 50, self.frame.size.width, self.frame.size.height);
            self.mainController?.openPostById(guid!, frame: frame);
            return false;
        }else if(request.URL.absoluteString! == "about:blank"){
            self.kfSetNote(nil);//important to close
        }
        return true;
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        loading.showOnView(webView);
        updateStatus();
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        loading.hide();
        updateStatus();
        if(note != nil){
            noteOpened();
        }else{
            self.titleLabel.text = getTitle();
        }
        self.urlTextfield!.text = getURL();
    }

    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        loading.hide();
        updateStatus();
        KFAppUtils.showAlert("Error", msg: "Error for URL: " + self.urlTextfield!.text);
    }
    
    
    func updateStatus(){
        backButton!.enabled = webView.canGoBack;
        forwardButton!.enabled = webView.canGoForward;
        stopButton!.enabled = webView.loading;
    }
    
    func getTitle() -> String{
        return webView.stringByEvaluatingJavaScriptFromString("document.title")!;
    }
    
    func getURL() -> String{
        return webView.stringByEvaluatingJavaScriptFromString("document.URL")!;
    }
    
    var suppressWebLayout = false;
    let loading = KFLoadingView();
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        let width:CGFloat = self.frame.size.width;
        let height:CGFloat = self.frame.size.height;
        
        let statusBarH:CGFloat = 44.0;
        self.statusBar.frame = CGRectMake(0,0,width,statusBarH);
        self.titleLabel.frame = CGRectMake(1,1,width-2,statusBarH-2);
        self.closeButton!.frame = CGRectMake(width - (statusBarH-2), 1, statusBarH-2, statusBarH-2);
        
        var toolBarH:CGFloat = 44.0;
        if(!self.showToolBar){
            toolBarH = 0.0;
        }
        self.toolContainer.frame = CGRectMake(0,statusBarH,width,44);
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
            var webViewHeight = height-(statusBarH+toolBarH);
            if(self._attachmentView != nil){
                let attachHeight = min(webViewHeight-1, 100);
                webViewHeight = webViewHeight - attachHeight;
                self._attachmentView!.frame = CGRectMake(0,(statusBarH+toolBarH)+webViewHeight,width,attachHeight);
            }
            self.webView.frame = CGRectMake(0,(statusBarH+toolBarH),width,webViewHeight);
            loading.frame.size = self.webView.frame.size;
            //self.webView.scrollView.zoomToRect(self.webView.frame, animated: false);//does not work
        }
    }

    
}
