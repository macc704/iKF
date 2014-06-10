//
//  KFPostRefIconView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFPostRefIconView: UIView {
    
    var beenRead = false;
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext();  // コンテキストを取得
        CGContextSetRGBFillColor(context, 1, 1, 1, 1);  // 白
        CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));  // 塗りつぶす
        if(beenRead==false){
            CGContextSetRGBFillColor(context, 0, 0, 1, 1);  // 青
        }else{
            CGContextSetRGBFillColor(context, 1, 0, 0, 1);  // 赤
        }
        CGContextFillEllipseInRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));  // 円を塗りつぶす
        //CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);  // 黒
        //CGContextStrokeEllipseInRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));  // 円の描画
    }
}
