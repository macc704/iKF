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
    var webView:UIWebView;
    var svgwidth:CGFloat = CGFloat(100.0);
    var svgheight:CGFloat = CGFloat(100.0);
    
    init(controller: iKFMainViewController, ref: KFReference) {
        webView = UIWebView();
        
        super.init(controller: controller, ref: ref);

        self.bindEvents();

        let drawing = model.post as KFDrawing;
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
        webView.loadHTMLString(drawing.content, baseURL: baseURL);
    }
    
  
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!){
        if(elementName == "svg"){
            svgwidth =  CGFloat((attributeDict["width"] as String).bridgeToObjectiveC().floatValue);
            svgheight =  CGFloat((attributeDict["height"] as String).bridgeToObjectiveC().floatValue);
        }
    }
    
    override func handleSingleTap(recognizer: UIGestureRecognizer){
        let drawing = model.post as KFDrawing;
        println("drawing svg="+drawing.content);
    }
    
    override func handleDoubleTap(recognizer: UIGestureRecognizer){
        let drawing = model.post as KFDrawing;
        println("drawing svg="+drawing.content);
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
