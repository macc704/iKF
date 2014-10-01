//
//  KFPost.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFPost: KFModel {

    var authors:[String:KFUser]=[:];
    var primaryAuthor:KFUser!;
    var canEdit = false;
    var beenRead = false;
    var created:String! = "";
    var modified:String! = "";
    
    var dirtyAuthors = false;
    var buildsOn:KFPost?;
    
    var attachments:[KFAttachment]=[];
    
    func marge(another: KFPost) {
        authors = another.authors;
        primaryAuthor = another.primaryAuthor;
        canEdit = another.canEdit;
        beenRead = another.beenRead;
        created = another.created;
        modified = another.modified;

        dirtyAuthors = another.dirtyAuthors;
        buildsOn = another.buildsOn;
        
        attachments = another.attachments;
    }
    
    func canEditMe() -> Bool{
        return canEdit(KFService.getInstance().currentUser);
    }
    
    func canEdit(user:KFUser)->Bool{
        return contains(authors.keys, user.guid);
    }
    
    func setAuthor(user:KFUser, value:Bool){
        if(!contains(authors.keys, user.guid) && value == true){            //add
            authors[user.guid] = user;
            dirtyAuthors = true;
        }else if(!contains(authors.keys, user.guid) && value == false) {           //remove
            authors.removeValueForKey(user.guid);
            dirtyAuthors = true;
        }
    }

    
}
