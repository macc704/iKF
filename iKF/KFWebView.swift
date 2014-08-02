//
//  KFWebVIew.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-31.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class A:iKFLayerView{
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView! {
        println(event);
        println("a");
        let allTouches = event.allTouches();
        if(allTouches.count > 0){
            println("b");
            let touch:UITouch = allTouches.anyObject() as UITouch;
            if(touch.tapCount == 2){
                println("c");
                return self;
            }
        }
        if(point.x < 20 && point.y < 20){
            return self;
        }
        return super.hitTest(point, withEvent: event);
    }
}

class KFWebView: UIView {
    
    private let scrollView = UIScrollView();
    private let webView = UIWebView();
    let cover = A();
    
    init() {
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        
        //self.addSubview(scrollView);
        //scrollView.addSubview(webView);
        self.addSubview(webView);
        self.addSubview(cover);
        self.webView.scrollView.scrollEnabled = true;
        
        self.layer.borderColor = UIColor.blackColor().CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
        
//        self.webView.
    }
    
    func setURL(url:String){
        let url = NSURL(string: url);
        let req = NSURLRequest(URL: url);
        webView.loadRequest(req);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        let width:CGFloat = self.frame.size.width;
        let height:CGFloat = self.frame.size.height;
        
        let r:CGRect = CGRectMake(0,0,width,height);
        self.scrollView.frame = r;
        self.webView.frame = r;
        self.cover.frame = r;
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
