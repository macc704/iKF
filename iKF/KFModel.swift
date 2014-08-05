//
//  KFModel.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFModel: NSObject{

    var guid = "";
    
    override init(){
    }
    
    func detach(observer:AnyObject){
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: "CHANGED", object: self);
    }
    
    func attach(observer:AnyObject, selector:Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: "CHANGED", object: self);
    }
    
    func notify(){
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "CHANGED", object: self));
    }

    override func isEqual(object: AnyObject!) -> Bool{
        if let model = object as? KFModel{
            return guid == model.guid;
        }else{
            return false;
        }
    }
    
//    override func hash() -> UInt{
//        return 3;
//    }
    

}

//- (void) attach: (id)observer selector: (SEL)selector{
//    [[NSNotificationCenter defaultCenter]
//        addObserver: observer selector: selector name: @"CHANGED" object: self];
//    }
//
//- (void) notify{
//    [[NSNotificationCenter defaultCenter] postNotification:
//        [NSNotification notificationWithName: @"CHANGED" object: self userInfo: nil]];
//}
