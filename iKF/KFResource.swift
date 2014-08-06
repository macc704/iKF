//
//  KFResource.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFResource: NSObject {
    
    class func loadWebResource(name:String, ext:String) -> String{
        let path = NSBundle.mainBundle().pathForResource(name, ofType: ext, inDirectory: "WebResources");
        //        println(path);
        //        let dir = NSBundle.mainBundle().pathForResource("/", ofType: "", inDirectory: "WebResources");
        //        println(dir);
        //
        //        println(path);
//        println(NSBundle.mainBundle().bundlePath);
//        println(NSBundle.mainBundle().bundleURL);
        let text = NSString.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil);
//        //println(a);
//        let url = NSURL(fileURLWithPath: path);
//        let req = NSURLRequest(URL: url);
//        println(req);

        return text;//KFResource.encodingForJS(text);
    }
    
    class func getReadTemplate() -> String{
        let text = loadWebResource("read", ext: "html");
        return text;
    }
    
    class func getWebResourceURL() -> NSURL{
//        let path = NSBundle.mainBundle().bundlePath;
//        let url = NSURL(fileURLWithPath: path);
//        return url;
//    }
//    
//    class func getWebResourceURL2() -> NSURL{
        return NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent("WebResources");
    }
    
    class func loadEditTemplate() -> String{
        let text = loadWebResource("edit", ext:"html");
        return text;
//        return KFResource.encodingForJS(text);
    }
    
    class func encodingForJS(text:String) -> String{
        var insertString = text;
        insertString = insertString.stringByReplacingOccurrencesOfString("\\", withString: "\\\\");//order important
        insertString = insertString.stringByReplacingOccurrencesOfString("\r", withString: "");
        insertString = insertString.stringByReplacingOccurrencesOfString("\n", withString: "");
        insertString = insertString.stringByReplacingOccurrencesOfString("'", withString: "\\'");
        return insertString;
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
    // Drawing code
    }
    */
    
}
