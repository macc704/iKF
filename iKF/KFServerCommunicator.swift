//
//  KFServerCommunicator.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import Foundation

// just playing now by yoshiaki use iKFConnector
class KFServerCommunicator{
    
    //class var server:KFServerCommunicator;
    
    class func getInstance() -> KFServerCommunicator{
        return KFServerCommunicator();
    }
    
    let legacy = iKFConnector.getInstance();
    
    init(){
    }
    
    func login(userid:String, password:String) -> Bool {
        let url = NSURL(string: "http://%@/kforum/rest/account/userLogin");
        let req = NSMutableURLRequest(URL: url);
        req.HTTPMethod = "POST";
        //        String paramString
        //        req.HTTPBody
        var error:NSError! = nil;
        //        let res =
        //        var res:AutoreleaseingUnsafe<NSURLResponse?> = nil;
        //        NSURLConnection.sendSynchronousRequest(req, returningResponse: res, error: &error)
        return false;// dont use this.
    }
    
}