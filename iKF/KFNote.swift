//
//  KFNote.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

var idCounter = 0;

class KFNote: NSObject {

    var guid = "";
    var title = "";
    var content = "";
    var primaryAuthor:KFUser?;
    var location = CGPoint(x:0, y:0);
    var buildsOn:KFNote?;
    var refId = "";

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
    
    func attach(observer:AnyObject, selector:Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: "CHANGED", object: self);
    }
    
    func notify(){
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "CHANGED", object: self));
    }

}

//- (void) attach: (id)observer selector: (SEL)selector{
//    [[NSNotificationCenter defaultCenter]
//        addObserver: observer selector: selector name: @"CHANGED" object: self];
//    }
//    
//- (void) notify{
//    [[NSNotificationCenter defaultCenter] postNotification:
//        [NSNotification notificationWithName: @"CHANGED" object: self userInfo: nil]];
//}
