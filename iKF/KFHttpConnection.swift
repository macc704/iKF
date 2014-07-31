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
        KFAppUtils.debug("URL='\(req.nsRequest.URL)'");
        
        req.updateParams();
        var res :NSURLResponse?
        var error :NSError?
        
        KFAppUtils.debug("requestBody='\(req.getBodyAsString())'");
        
        let bodyData = NSURLConnection.sendSynchronousRequest(req.nsRequest, returningResponse: &res, error: &error);
        let kfres = KFHttpResponse();
        kfres.res = res as? NSHTTPURLResponse;
        kfres.error = error;
        kfres.bodyData = bodyData;
        
        KFAppUtils.debug("statusCode='\(kfres.getStatusCode())'");
        return kfres;
    }
    
}
