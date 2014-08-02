//
//  KFLayerView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-30.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFLayerView: UIView {

    init() {
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        self.backgroundColor = UIColor.clearColor();
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event);
        if(hitView == nil){//necessary?
            return nil;
        }
        if(hitView == self){
            return nil;
        }else{
            return hitView;
        }
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
