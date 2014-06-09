//
//  KFModel.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFModel: NSObject {

    var guid = "";

    
    func attach(observer:AnyObject, selector:Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: "CHANGED", object: self);
    }
    
    func notify(){
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "CHANGED", object: self));
    }

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
