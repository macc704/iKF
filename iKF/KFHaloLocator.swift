//
//  KFHaloLocator.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-31.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFHaloLocator: NSObject {

    private var halo:KFHalo;
    private var size:CGFloat;
    
    init(halo:KFHalo, size:CGFloat = 20){
        self.halo = halo;
        self.size = size;
    }
    
    private func topP() ->CGFloat{
        return 0.0;
    }
    
    private func bottomP() ->CGFloat{
        return (self.halo.frame.size.height - self.size);
    }
    
    private func leftP() ->CGFloat{
        return 0.0;
    }
    
    private func rightP() ->CGFloat{
        return (self.halo.frame.size.width - self.size);
    }
    
    private func horizontalCenterP() ->CGFloat{
        return ((self.halo.frame.size.width - self.size)/2.0);
    }
    
    private func quarterLeftP() ->CGFloat{
        return ((self.halo.frame.size.width - self.size) * (1.0/4.0));
    }
    
    private func quarterRightP() ->CGFloat{
        return ((self.halo.frame.size.width - self.size) * (3.0/4.0));
    }
    
    private func verticalCenterP() ->CGFloat{
        return ((self.halo.frame.size.height - self.size)/2.0);
    }

    func TOP_LEFT() -> (()->CGRect){
        return {return CGRect(x: self.leftP(), y: self.topP(), width: self.size, height: self.size)};
    }
    
    func TOP_RIGHT() -> (()->CGRect){
        return {return CGRect(x: self.rightP(), y: self.topP(), width: self.size, height: self.size)};
    }
    
    func BOTTOM_LEFT() -> (()->CGRect){
        return {return CGRect(x: self.leftP(), y: self.bottomP(), width: self.size, height: self.size)};
    }
    
    func BOTTOM_RIGHT() -> (()->CGRect){
        return {return CGRect(x: self.rightP(), y: self.bottomP(), width: self.size, height: self.size)};
    }
    
    func TOP() -> (()->CGRect){
        return {return CGRect(x: self.horizontalCenterP(), y: self.topP(), width: self.size, height: self.size)};
    }
    
    func BOTTOM() -> (()->CGRect){
        return {return CGRect(x: self.horizontalCenterP(), y: self.bottomP(), width: self.size, height: self.size)};
    }
    
    func LEFT() -> (()->CGRect){
        return {return CGRect(x: self.leftP(), y: self.verticalCenterP(), width: self.size, height: self.size)};
    }
    
    func RIGHT() -> (()->CGRect){
        return {return CGRect(x: self.rightP(), y: self.verticalCenterP(), width: self.size, height: self.size)};
    }
    
    func TOP_QUARTER_LEFT() -> (()->CGRect){
        return {return CGRect(x: self.quarterLeftP(), y: self.topP(), width: self.size, height: self.size)};
    }
    
    func TOP_QUARTER_RIGHT() -> (()->CGRect){
        return {return CGRect(x: self.quarterRightP(), y: self.topP(), width: self.size, height: self.size)};
    }
    
    
    //        CGRectMake((self.frame.size.width - SIZE) , 0, SIZE, SIZE)]; anchor
    //        GRectMake(self.frame.size.width - SIZE , self.frame.size.height - SIZE, SIZE, SIZE)]; resize
    //        CGRectMake( , 0, SIZE, SIZE)];//move
    //        CGRectMake(0, self.frame.size.height - SIZE, SIZE, SIZE)];//rotation
    //        [button setFrame: CGRectMake(0 , 0, SIZE, SIZE)];//bin
    //        CGRectMake((self.frame.size.width - SIZE)/2 , 0, SIZE, SIZE)];//edit
    //        [button setFrame: CGRectMake(self.frame.size.width - SIZE , 0, SIZE, SIZE)];
    //         [button setFrame: CGRectMake((self.frame.size.width - SIZE)*3/4, 0, SIZE, SIZE)];//clip


}
