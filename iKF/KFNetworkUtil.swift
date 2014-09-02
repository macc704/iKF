//
//  KFNetworkUtil.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-24.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNetworkUtil: NSObject {
   
    class func dataToString(data:NSData?) -> String {
        if(data == nil){
            return "nil";
        }
        var str:NSString? = NSString(data: data!, encoding:NSUTF8StringEncoding);
        if(str == nil){
            return "nil";
        }
        return str!;
    }
}
