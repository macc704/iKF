//
//  KFCanvasView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-30.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFCanvasView: UIView, UIScrollViewDelegate{
    
    private let scrollView = UIScrollView();
    private let layerContainerView = UIView();
    let windowsLayer = iKFLayerView();
    let noteLayer = iKFLayerView();
    let connectionLayer = KFConnectionLayer();
    let drawingLayer = iKFLayerView();
    
    var doubleTapHandler:((CGPoint)->())?;
    
    private var halo:KFHalo?;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        
        //basic structure
        self.addSubview(scrollView);
        scrollView.addSubview(layerContainerView);
        scrollView.delegate = self;
        //scrollView.decelerationRate = UIScrollViewDecelerationRateFast; //normal
        //scrollView.canCancelContentTouches = false;//important for subview recognition
        scrollView.delaysContentTouches = false;//important for subview recognition
        
        //add layers by reversed order
        //self.drawingLayer.userInteractionEnabled = true;//not necessary
        layerContainerView.addSubview(self.drawingLayer);
        //layerContainerView.addSubview(connectionLayer);
        self.noteLayer.layer.addSublayer(connectionLayer);
        layerContainerView.addSubview(self.noteLayer);
        layerContainerView.addSubview(self.windowsLayer);
        
        //halo disappear
        let singleRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:");
        singleRecognizer.numberOfTapsRequired = 1;
        layerContainerView.addGestureRecognizer(singleRecognizer);
        
        let doubleRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTap:");
        doubleRecognizer.numberOfTapsRequired = 2;
        layerContainerView.addGestureRecognizer(doubleRecognizer);
        
        singleRecognizer.requireGestureRecognizerToFail(doubleRecognizer);
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
        windowsLayer.frame = layerContainerView.frame;
        
        scrollView.contentSize = layerContainerView.frame.size;
        scrollView.maximumZoomScale = 4.0;
        scrollView.minimumZoomScale = 0.2;
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

    /* halo management */
    
    func handleDoubleTap(recognizer: UIGestureRecognizer){
        let loc = recognizer.locationInView(layerContainerView);
        self.doubleTapHandler?(loc);
    }
    
    func handleSingleTap(recognizer: UIGestureRecognizer){
        if(halo != nil){
            hideHalo();
        }else{
            //showhalo
        }
    }
    
    func showHalo(newHalo:KFHalo){
        self.hideHalo();        
        self.halo = newHalo;
        self.halo!.showWithAnimation(self.layerContainerView);
    }
    
    func hideHalo(){
        if(self.halo != nil){
            self.halo!.removeFromSuperview();
            self.halo = nil;
        }
    }
    
    /* Scrollling */
    
    func translateToCanvas(fromViewP:CGPoint) -> CGPoint{
        let offset = scrollView.contentOffset;
        let scale = scrollView.zoomScale;
        return CGPointMake((fromViewP.x + offset.x) / scale, (fromViewP.y + offset.y) / scale);
    }
    
    func suppressScroll(){
        self.scrollView.canCancelContentTouches = false;
    }
    
    func unlockSuppressScroll(){
        self.scrollView.canCancelContentTouches = true;
    }
    
    /* Scrollling Enabling (only one method) */
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return layerContainerView;
    }
    
    //    func scrollViewDidZoom(scrollView: UIScrollView!) {
    //        if(scrollView.zoomScale > 1.0){
    //            scrollView.canCancelContentTouches = false;
    //        }else{
    //            scrollView.canCancelContentTouches = true;
    //        }
    //    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
    // Drawing code
    }
    */
    
}
