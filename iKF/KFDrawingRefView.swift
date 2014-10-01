//
//  KFDrawingRefView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFDrawingRefView: KFPostRefView, NSXMLParserDelegate{
    
    //let ref: KFReference;
    var webView:KFWebView!;
    var imgview:UIImageView?;//tmp for ios7
    var svgwidth = CGFloat(100.0);
    var svgheight = CGFloat(100.0);
    var rotation = CGFloat(0.0);
    var scaleX = CGFloat(1.0);
    var scaleY = CGFloat(1.0);
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(controller: KFCanvasViewController, ref: KFReference) {
        webView = KFWebView.createAsPost();
        webView.userInteractionEnabled = false;
        
        super.init(controller: controller, ref: ref);
        
        let drawing = getModel().post as KFDrawing;
        let data = drawing.content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        let parser = NSXMLParser(data: data);
        parser.delegate = self;
        parser.parse();
        
        self.frame = CGRectMake(ref.location.x, ref.location.y, svgwidth, svgheight);
        webView.frame = CGRectMake(0, 0, svgwidth, svgheight);
        webView.scrollView.scrollEnabled = false;
        webView.scrollView.bounces = false;
        self.addSubview(webView);
        
        let baseURLStr = "http://" + KFService.getInstance().getHost();
        let baseURL = NSURL(string: baseURLStr);
        
        var systemVersion = UIDevice.currentDevice().systemVersion;
        
        webView.loadHTMLString(drawing.content, baseURL: baseURL);
    }
    
    //for ios 7
    var imageName:String?;
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!){
        if(elementName == "svg"){
            svgwidth =  CGFloat((attributeDict["width"] as NSString).floatValue);
            svgheight =  CGFloat((attributeDict["height"] as NSString).floatValue);
        }
        if(elementName == "image"){
            imageName = attributeDict["xlink:href"] as String?;
        }
    }
    
    override func kfSetSize(width:CGFloat, height:CGFloat){
        kfSetScale(width/svgwidth, newScaleY: height/svgheight);
    }
    
    func kfSetScale(newScaleX:CGFloat, newScaleY:CGFloat){
        scaleX = newScaleX;
        if(scaleX < 0.05){
            scaleX = 0.05;
        }
        scaleY = newScaleY;
        if(scaleY < 0.05){
            scaleY = 0.05;
        }
        let newWidth = scaleX * svgwidth;
        let newHeight = scaleY * svgheight;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth,newHeight);
        webView.transform = CGAffineTransformMakeScale(self.scaleX, self.scaleY);//necessary
        
        webView.frame = CGRectMake(0, 0, newWidth, newHeight);
        updateTransform();
    }
    
    override func updateToModel() {
        super.updateToModel();
        getModel().location = self.frame.origin;
        getModel().width = self.svgwidth * self.scaleX;
        getModel().height = self.svgheight * self.scaleY;
        getModel().rotation = self.rotation;
        getModel().setShowInPlace(true);
    }
    
    override func updateFromModel(){
        super.updateFromModel();
        self.updateEventBinding();
        if(getModel().isShowInPlace()){
            kfSetSize(getModel().width, height: getModel().height);
            kfSetRotation(getModel().rotation);
        }
    }
    
    func kfSetRotation(newRotation:CGFloat){
        self.rotation = newRotation;
        updateTransform();
    }
    
    private func updateTransform(){
        let scaleT = CGAffineTransformMakeScale(self.scaleX, self.scaleY);
        let rotationT = CGAffineTransformMakeRotation(self.rotation);
        webView.transform = CGAffineTransformConcat(rotationT, scaleT);
        if(self.imgview != nil){
            let newWidth = scaleX * svgwidth;
            let newHeight = scaleY * svgheight;
            imgview!.transform = CGAffineTransformIdentity;
            imgview!.frame = CGRectMake(0, 0, newWidth, newHeight);
            imgview!.transform = rotationT;//CGAffineTransformConcat(scaleT, rotationT);
        }
    }
    
}
