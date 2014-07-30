//
//  KFCanvasView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-30.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFCanvasView: UIView, UIScrollViewDelegate{
    
    let scrollView = UIScrollView();
    let layerContainerView = UIView();
    
    let noteLayer = KFLayerView();
    let connectionLayer = iKFConnectionLayerView();
    let drawingLayer = KFLayerView();
    
    init(frame: CGRect) {
        super.init(frame: frame)

        //basic structure
        self.addSubview(scrollView);
        scrollView.addSubview(layerContainerView);
        scrollView.delegate = self;
        
        //add layers by reversed order
        self.drawingLayer.userInteractionEnabled = true;
        layerContainerView.addSubview(self.drawingLayer);
        layerContainerView.addSubview(connectionLayer);
        layerContainerView.addSubview(self.noteLayer);
    }
    
    func setSize(size:CGSize){
        self.frame.size = size;
        self.scrollView.frame.size = size;
    }
    
    func setCanvasSize(width:CGFloat, height:CGFloat){
        layerContainerView.frame = CGRectMake(0, 0, width, height);
        drawingLayer.frame = layerContainerView.frame;
        connectionLayer.frame = layerContainerView.frame;
        noteLayer.frame = layerContainerView.frame;
        
        scrollView.contentSize = layerContainerView.frame.size;
        scrollView.maximumZoomScale = 4.0;
        scrollView.minimumZoomScale = 0.4;
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
    
    /* Scrollling (only one method) */
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return layerContainerView;
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
