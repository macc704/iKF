//
//  KFService.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-23.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

private let instance = KFService();

class KFService: NSObject {
    class func getInstance() -> KFService{
        return instance;
    }
    
    private var host:String?
    
    private init(){
    }
    
    func initialize(host:String){
        self.host = host;
    }
    
    func connectToTheURL(urlString:String) -> KFHttpResponse{
        let req = KFHttpRequest(urlString: urlString, method: "GET");
        req.nsRequest.timeoutInterval = 12.0;
        let res = KFHttpConnection.connect(req);
        return res;
    }
    
}
