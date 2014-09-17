//
//  KFConnectionLayer.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

import QuartzCore

class KFConnectionLayer: CALayer {
    
    var connections:[KFConnectionViewModel] = [];
    
    //    required init(coder aDecoder: NSCoder!) {
    //        super.init(coder: aDecoder)
    //    }
    //
    //    override init(){
    //        super.init(frame: KFAppUtils.DEFAULT_RECT());
    //
    ////        let a = CALayer();
    //        self.layer.
    //        self.userInteractionEnabled = false;
    //        self.backgroundColor = UIColor.clearColor();
    //    }
    
    func clearAllConnections(){
        connections = [];
        self.requestRepaint();
    }
    
    func requestRepaint(){
        self.setNeedsDisplay();
    }
    
    func noteRemoved(removedNoteRef:KFPostRefView){
        var newConnections:[KFConnectionViewModel] = [];
        
        for conn in connections{
            if(conn.from != removedNoteRef && conn.to != removedNoteRef){
                newConnections.append(conn);
            }
            
            if(newConnections.count != connections.count){
                connections = newConnections;
                self.requestRepaint();
            }
        }
    }
    
    func addConnection( from:KFPostRefView, to:KFPostRefView){
        let conn = KFConnectionViewModel(from: from, to: to);
        connections.append(conn);
        self.requestRepaint();
    }
    
    override func drawInContext(ctx: CGContext!) {
        self.drawAll(ctx);
    }
    
    
    //    override func drawRect(rect: CGRect) {
    //        let context = UIGraphicsGetCurrentContext();
    //
    //        CGContextClearRect(context, rect);
    //
    //        CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor);
    //        CGContextSetLineWidth(context, 2.0);
    //
    //        for conn in connections {
    //            //CGPoint fromP = conn.from.center;
    //            let fromP = self.createChopBoxAnchor(conn.to, to: conn.from);
    //            let toP = self.createChopBoxAnchor(conn.from, to: conn.to);
    //            CGContextMoveToPoint(context, fromP.x, fromP.y);
    //            CGContextAddLineToPoint(context, toP.x, toP.y);
    //            CGContextStrokePath(context);
    //
    //            //Arrow
    //            self.createArrow(context, from: fromP, to: toP);
    //        }
    //    }
    
    private func drawAll(context: CGContext!){
        //CGContextClearRect(context, rect);
        
        CGContextSetStrokeColorWithColor(context, UIColor(red: 0, green: 0, blue: 1.0, alpha: 0.8).CGColor);
        CGContextSetLineWidth(context, 2.0);
        
        for conn in connections {
            //CGPoint fromP = conn.from.center;
            let fromP = self.createChopBoxAnchor(conn.to, toView: conn.from);
            let toP = self.createChopBoxAnchor(conn.from, toView: conn.to);
            CGContextMoveToPoint(context, fromP.x, fromP.y);
            CGContextAddLineToPoint(context, toP.x, toP.y);
            CGContextStrokePath(context);
            
            //Arrow
            self.createArrow(context, from: fromP, to: toP);
        }
    }
    
    func createArrow(context:CGContextRef, from:CGPoint, to:CGPoint){
        var baseDir = atan2(to.y - from.y, to.x - from.x);
        baseDir = baseDir + 3.141592 * 1;//逆向き
        
        let dir1 = baseDir + 0.5;
        let dir2 = baseDir - 0.5;
        
        var newX = to.x + cos(dir1) * 13;
        var newY = to.y + sin(dir1) * 13;
        CGContextMoveToPoint(context, to.x, to.y);
        CGContextAddLineToPoint(context, newX, newY);
        CGContextStrokePath(context);
        
        newX = to.x + cos(dir2) * 13;
        newY = to.y + sin(dir2) * 13;
        CGContextMoveToPoint(context, to.x, to.y);
        CGContextAddLineToPoint(context, newX, newY);
        CGContextStrokePath(context);
    }
    
    func createChopBoxAnchor(fromView:KFPostRefView, toView:KFPostRefView) -> CGPoint{
        let from = center(fromView.getReference());
        let chopbox = toView.getReference().size;
        let to = center(toView.getReference());
        
        // This avoids divide-by-zero
        if (/*r.isEmpty()*/ chopbox.width <= 0 || chopbox.height <= 0 ||
            (from.x == to.x && from.y == to.y)){
                return CGPointMake(to.x, to.y);
        }
        
        var dx = from.x - to.x;
        var dy = from.y - to.y;
        let scale = 0.5 / max(abs(dx) / chopbox.width, abs(dy) / chopbox.height);
        dx *= scale;
        dy *= scale;
        return CGPointMake(to.x + dx, to.y + dy);
    }
    
    private func center(rect:CGRect) -> CGPoint{
        return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
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
