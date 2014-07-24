//
//  KFHttpRequest.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-23.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFHttpRequest: NSObject {
    let nsRequest :NSMutableURLRequest;
    
    init(urlString: String, method: String){
        let url = NSURL.URLWithString(urlString);
        nsRequest = NSMutableURLRequest(URL: url);
        nsRequest.HTTPMethod = method;
    }
}
