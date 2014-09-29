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
    
    func findDropTarget(view:UIView) -> KFDropTargetView?{
        for subview in self.subviews{
            if(subview is KFDropTargetView){
                let dropTarget = subview as KFDropTargetView;
                if(dropTarget.candrop(view)){
                    let viewFrame = view.convertRect(view.bounds, toView: self);
                    if(dropTarget.frame.intersects(viewFrame)){
                        return dropTarget;
                    }
                }
            }
        }
        return nil;
    }
}
