//
//  KFReference.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFReference: KFModel {
    
    let HIDDEN_BIT = 0x01;
    let LOCKED_BIT = 0x02;
    let SHOWINPLACE_BIT = 0x04;
    
    var post:KFPost?;
    var location = CGPoint(x:0, y:0);
    var width = CGFloat(0);
    var height = CGFloat(0);
    var rotation = CGFloat(0);
    var displayFlags = Int(0);
    
    init(){
    }
    
    func isHidden() -> Bool{
        return displayFlags & HIDDEN_BIT == HIDDEN_BIT;
    }
    
    func setHidden(hidden:Bool){
        if(hidden){
            displayFlags = displayFlags | HIDDEN_BIT;
        }else{
            displayFlags = displayFlags & ~HIDDEN_BIT;
        }
    }
    
    func isLocked() -> Bool{
        return displayFlags & LOCKED_BIT == LOCKED_BIT;
    }
    
    func setLocked(locked:Bool){
        if(locked){
            displayFlags = displayFlags | LOCKED_BIT;
        }else{
            displayFlags = displayFlags & ~LOCKED_BIT;
        }
    }
    
    func isShowInPlace() -> Bool{
        return displayFlags & SHOWINPLACE_BIT == SHOWINPLACE_BIT;
    }
    
    func setShowInPlace(showInPlace:Bool){
        if(showInPlace){
            displayFlags = displayFlags | SHOWINPLACE_BIT;
        }else{
            displayFlags = displayFlags & ~SHOWINPLACE_BIT;
        }
    }

}
