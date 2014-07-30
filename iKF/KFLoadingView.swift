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
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
        
        // 雰囲気出すために背景を黒く半透明する
        self.backgroundColor = UIColor.blackColor();
        self.alpha = 0.5;
        
        // でっかいグルグル
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge;
        self.addSubview(indicator);
    }
    
    func showOnView(view:UIView){
        let rect = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        self.frame = rect;
        indicator.center = self.center;
        view.addSubview(self);
    
        // ぐるぐる開始
        indicator.startAnimating();
    }
    
    func hide(){
        // ぐるぐる停止
        indicator.stopAnimating();
    
        //　削除
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
