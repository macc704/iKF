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
    private let layerContainerView = iKFLayerView();//should be layer for subview recognition

    let windowsLayer = iKFLayerView();
    let noteLayer = iKFLayerView();
    let connectionLayer = iKFConnectionLayerView();
    let drawingLayer = iKFLayerView();
    
    private var halo:KFHalo?;
    
    init() {
        super.init(frame: KFAppUtils.DEFAULT_RECT());

        //basic structure
        self.addSubview(scrollView);
        scrollView.addSubview(layerContainerView);
        scrollView.delegate = self;
        //scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        //scrollView.canCancelContentTouches = false;//important for subview recognition
        scrollView.delaysContentTouches = false;//important for subview recognition
        
        //add layers by reversed order
        //self.drawingLayer.userInteractionEnabled = true;//not necessary
        layerContainerView.addSubview(self.drawingLayer);
        layerContainerView.addSubview(connectionLayer);
        layerContainerView.addSubview(self.noteLayer);
        layerContainerView.addSubview(self.windowsLayer);
        
        //halo disappear
        let recognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:");
        recognizer.numberOfTapsRequired = 1;
        //layerContainerView.addGestureRecognizer(recognizer);
        scrollView.addGestureRecognizer(recognizer); //important for subview recognition
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
    
    /* halo management */
    
    func handleSingleTap(recognizer: UIGestureRecognizer){
        if(halo){
            hideHalo();
        }else{
            //showhalo
        }
    }
    
    func showHalo(newHalo:KFHalo){
        self.hideHalo();
        
        self.halo = newHalo;
        self.halo!.alpha = 0.0;
        self.layerContainerView.addSubview(self.halo);
        func animation(){
            self.halo!.alpha = 1.0;
        }
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: animation, completion: nil);
    }
    
    func hideHalo(){
        if(self.halo){
            self.halo!.removeFromSuperview();
            self.halo = nil;
        }
    }
    
    /* Scrollling (only one method) */
    
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
