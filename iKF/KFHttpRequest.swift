//
//  KFHttpRequest.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-23.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFHttpRequest: NSObject {
    
    var nsRequest :NSMutableURLRequest;
    
    private var params = [String: String]();
    //Swift note
    //let params = Dictionary<String, String>();
    //let -> immutable, var -> mutable
    
    init(urlString: String, method: String){
        let url = NSURL.URLWithString(urlString);
        nsRequest = NSMutableURLRequest(URL: url);
        nsRequest.HTTPMethod = method;
    }
    
    func addParam(key:String, value:String){
        params[key] = escapeString(value);
    }
    
    func updateParams(){
        if(params.count <= 0){
            //nsRequest.setValue(nil, forHTTPHeaderField:"Content-Type");
            //nsRequest.HTTPBody = nil;
            return;
        }
        
        var paramStr = "";
        for key in params.keys{
            let value = params[key];
            if(!paramStr.isEmpty){
                paramStr += "&";
            }
            paramStr += "\(key)=\(value!)";
        }
        let data = paramStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false);
        nsRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField:"Content-Type");
        nsRequest.HTTPBody = data!;
    }
    
    func getBodyAsString() -> String {
        return KFNetworkUtil.dataToString(self.nsRequest.HTTPBody);
    }
    
    private func escapeString(unescaped:String) -> String{
        let raw:CFString = ((unescaped as NSString) as CFString);
        return CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,raw, nil,  "!*'();:@&=+$,/?%#[]\" ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) as NSString;
    }

}
