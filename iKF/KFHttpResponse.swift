//
//  KFHttpResponse.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-23.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import Foundation
import UIKit

class KFHttpResponse: NSObject {
    var res :NSHTTPURLResponse?
    var error :NSError?
    var bodyData :NSData?
    
    init(){
    }
    
    func getBodyAsString() -> NSString {
        if(bodyData == nil){
            return "";
        }
        var bodyString = NSString(data: bodyData, encoding:NSUTF8StringEncoding);
        if(bodyString == nil){
            return "";
        }
        return bodyString;
    }
    
    func getStatusCode() -> Int{
        if(res != nil){
            return res!.statusCode;
        }else if(error != nil){
            return error!.code;
        }else{
            return -1;
        }
    }
}
