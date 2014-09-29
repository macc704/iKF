//
//  KFNote.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

var idCounter = 0;

class KFNote: KFPost {

    var title = "";
    var content = "";
//    var location = CGPoint(x:0, y:0);
//    var buildsOn:KFNote?;
//    var refId = "";
    
    override func marge(another: KFPost) {
        super.marge(another);
        let anotherNote = another as KFNote;
        title = anotherNote.title;
        content = anotherNote.content;
    }
    
    func getReadHtml() -> String{
        //let template = KFService.getInstance().getReadTemplate();
        let template = KFResource.loadReadTemplate();
        var html = template;
        html = html.stringByReplacingOccurrencesOfString("%YOURCONTENT%", withString:content);
        var systemVersion = UIDevice.currentDevice().systemVersion;
        if(systemVersion.hasPrefix("7.") == false){
            html = html.stringByReplacingOccurrencesOfString("../kforum_uploads/", withString: KFService.getInstance().getHostURLString() + "kforum_uploads/");
        }
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
    
    override func toString() -> String {
        //        var text = "Note:";
        var text = "";
        text += "\"\(title)\"";
        if(self.primaryAuthor != nil){
            text = text + " by " + self.primaryAuthor.firstName;
        }
        if(self.modified != nil){
            text = text + " at " + self.modified;
        }
        return text;
    }
    
    class func createReferenceNoteTag(guid:String, title:String) -> String{
        return "<kf-post-reference class=\"mceNonEditable\" postid=\"\(guid)\">\(title)</kf-post-reference>";
    }
    
    class func createReferenceContentTag(guid:String, title:String) -> String{
        return "<kf-content-reference class=\"mceNonEditable\" postid=\"\(guid)\">\(title)</kf-content-reference>";
    }
    
    class func createSupportTag(support:KFSupport) -> String{
        let uniqueId = String(Int(NSDate.date().timeIntervalSince1970));
        let template = KFResource.loadScaffoldTagTemplate();
        var tagString = template;
        tagString = tagString.stringByReplacingOccurrencesOfString("%SUPPORTID%", withString: support.guid, options: nil, range: nil);
        tagString = tagString.stringByReplacingOccurrencesOfString("%UNIQUEID%", withString: uniqueId, options: nil, range: nil);
        tagString = tagString.stringByReplacingOccurrencesOfString("%TITLE%", withString: support.title, options: nil, range: nil);
        return tagString;
    }
    
    //temporary implementation
    func addReference(refNote:KFNote){        
        let tag = "<ul><li>\(KFNote.createReferenceNoteTag(refNote.guid, title: refNote.title))</li></ul>";
        self.content = self.content.stringByReplacingOccurrencesOfString("</body>", withString: "\(tag)</body>");
        self.notify();
    }
    
    func updateToServer(){
        KFAppUtils.executeInBackThread({
            let res = KFService.getInstance().updateNote(self);
            if(res == false){
                KFAppUtils.showDialog("Saving Failed", msg: "Would you like to save contents to clipboard?", okHandler:
                    {(UIAlertAction) in
                        let pasteboard = UIPasteboard.generalPasteboard();
                        pasteboard.string = self.content;
                        return;
                });
            }
        });
    }
    
}


