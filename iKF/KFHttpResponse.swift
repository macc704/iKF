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
    
    override init(){
    }
    
    func getStatusCode() -> Int{
        if(res != nil){
            return res!.statusCode;
        }
        if(error != nil){
            return error!.code;
        }
        return -1;
    }
    
    func getBodyAsString() -> String {
        return KFNetworkUtil.dataToString(bodyData);
    }
    
    func getBodyAsJSON() -> JSON{
        return JSON.parse(getBodyAsString());
    }

}
