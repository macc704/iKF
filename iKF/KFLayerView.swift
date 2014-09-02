//
//  KFLayerView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFLayerView: UIView {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event);
        if(hitView == nil){//because hitView is UIView?
            return nil;
        }
        if(hitView! == self){
            return nil;
        }
        return hitView;
    }
}
