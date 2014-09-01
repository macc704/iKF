//
//  KFLoadingView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-30.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFLoadingView: UIView {

//    init(frame: CGRect) {
//        super.init(frame: frame)
//        // Initialization code
//    }
    
    let indicator = UIActivityIndicatorView();
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
        
        // fun-iki dasutame black transparent color
        self.backgroundColor = UIColor.blackColor();
        self.alpha = 0.5;
        
        // big guruguru
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge;
        self.addSubview(indicator);
    }
    
    func showOnView(view:UIView){
        let rect = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        self.frame = rect;
        indicator.center = self.center;
        view.addSubview(self);
    
        // guruguru start
        indicator.startAnimating();
    }
    
    func hide(){
        // guruguru stop
        indicator.stopAnimating();
    
        //　delete
        self.removeFromSuperview();
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
