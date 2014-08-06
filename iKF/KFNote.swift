//
//  KFNote.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

var idCounter = 0;

class KFNote: KFPost {

    var title = "";
    var content = "";
//    var location = CGPoint(x:0, y:0);
    var buildsOn:KFNote?;
//    var refId = "";
    
    func getReadHtml() -> String{
        //let template = KFService.getInstance().getReadTemplate();
        let template = KFResource.getReadTemplate();
        var html = content;
        html = template.stringByReplacingOccurrencesOfString("%YOURCONTENT%", withString:content);
        return html;
    }
    
    func getBaseURL() -> NSURL{
        return KFResource.getWebResourceURL();
    }

    func initWithoutAuthor() -> KFNote{
        self.guid = "temporary-\(idCounter)";
        idCounter++;
        return self;
    }
    
    func initWithAuthor(author:KFUser) -> KFNote{
        self.guid = "temporary-\(idCounter)";
        idCounter++;
        self.primaryAuthor = author;
        self.title =  "New Note";
        self.content = "Test";
        return self;
    }

}


