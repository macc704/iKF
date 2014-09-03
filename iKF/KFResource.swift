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
        let text = NSString.stringWithContentsOfFile(path!, encoding: NSUTF8StringEncoding, error: nil);
        return text;//KFResource.encodingForJS(text);
    }
    
    class func loadReadTemplate() -> String{
        let text = loadWebResource("read", ext: "html");
        return text;
    }
    
    class func loadEditTemplate() -> String{
        let text = loadWebResource("edit", ext:"html");
        return text;
    }
    
    class func loadScaffoldTagTemplate() -> String{
        let text = loadWebResource("scaffoldtag", ext: "txt");
        return text;
    }
    
    class func getWebResourceURL() -> NSURL{
        return NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent("WebResources");
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
