//
//  KFCanvasView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-30.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFCanvasView: UIView {
    
    let noteLayer = KFLayerView();
    let connectionLayer = iKFConnectionLayerView();
    let drawingLayer = KFLayerView();
    
    init(frame: CGRect) {
        super.init(frame: frame)
        
        self.drawingLayer.userInteractionEnabled = true;
        
        //add layers by reversed order
        self.addSubview(self.drawingLayer);
        self.addSubview(connectionLayer);
        self.addSubview(self.noteLayer);
    }
    
    func setSizeWithWidth(width:CGFloat, height:CGFloat){
        self.frame = CGRectMake(0, 0, width, height);
        self.drawingLayer.frame = self.frame;
        self.connectionLayer.frame = self.frame;
        self.noteLayer.frame = self.frame;
    }
    
    func clearViews(){
        self.removeChildren(self.drawingLayer);
        self.removeChildren(self.noteLayer);
        self.connectionLayer.clearAllConnections();
    }
    
    private func removeChildren(view:UIView){
        for subview in view.subviews {
            subview.removeFromSuperview();
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
