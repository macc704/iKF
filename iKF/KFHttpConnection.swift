//
//  KFHttpConnection.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-23.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFHttpConnection: NSObject {
    class func connect(req: KFHttpRequest) -> KFHttpResponse{
        debug(String(format: "URL='%@'", req.nsRequest.URL));
        
        req.updateParams();
        var res :NSURLResponse?
        var error :NSError?
        
        debug(String(format: "requestBody='%@'", req.getBodyAsString()));
        
        let bodyData = NSURLConnection.sendSynchronousRequest(req.nsRequest, returningResponse: &res, error: &error);
        let kfres = KFHttpResponse();
        kfres.res = res as? NSHTTPURLResponse;
        kfres.error = error;
        kfres.bodyData = bodyData;
        
        debug(String(format: "statusCode='%d'", kfres.getStatusCode()));
        return kfres;
    }
    
    private class func debug(text:String){
        println("Debug: connect() " + text);
    }
}
