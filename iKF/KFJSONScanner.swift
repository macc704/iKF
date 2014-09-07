//
//  KFJSONScanner.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFJSONScanner: NSObject {
    
    func scanRegistrations(json:JSON)->KFModelArray<KFRegistration>{
        var models = KFModelArray<KFRegistration>();
        
        for each in json.asArray!{
            let model = KFRegistration();
            model.guid = each["guid"].asString!;
            model.roleName = each["roleInfo"]["name"].asString!;
            let community = KFCommunity();
            community.guid = each["sectionId"].asString!;
            community.name = each["sectionTitle"].asString!;
            model.community = community;
            models.add(model);
        }
        
        return models;
    }
    
    
    func scanViews(json:JSON)->KFModelArray<KFView>{
        var models = KFModelArray<KFView>();
        
        for each in json.asArray!{
            let model = KFView();
            model.guid = each["guid"].asString!;
            model.title = each["title"].asString!;
            model.published = each["published"].asBool!;
            model.authors = scanUsers(each["authors"]).dic;
            model.primaryAuthor = getUserById(each["primaryAuthorId"].asString!)!;
            models.add(model);
        }
        
        return models;
    }
    
    func scanUsers(json:JSON)->KFModelArray<KFUser>{
        var models = KFModelArray<KFUser>();
        
        for each in json.asArray!{
            let userId = each["guid"].asString!;
            var user = self.getUserById(userId);
            if(user == nil){
                user = scanUser(each);
            }
            models.add(user!);
        }
        
        return models;
    }
    
    func scanUser(json:JSON)->KFUser{
        let model = KFUser();
        model.guid = json["guid"].asString!;
        model.firstName = json["firstName"].asString!;
        model.lastName = json["lastName"].asString!;
        return model;
    }
    
    func scanPosts(json:JSON)->KFModelArray<KFPost>{
        var models = KFModelArray<KFPost>();
        
        for each in json.asArray!{
            models.add(scanPost(each)!);
        }
        
        return models;
    }
    
    func scanPost(json:JSON)->KFPost?{
        var model:KFPost?;
        
        let postType = json["postType"].asString!;
        if(postType == "NOTE"){
            let note = KFNote();
            note.initWithoutAuthor();
            model = note;
            note.title = json["title"].asString!;
            note.content = json["body"].asString!;
        }
        else if(postType == "DRAWING"){
            let drawing = KFDrawing();
            model = drawing;
            if(!json["body"].isNull){//swift beta4 does not allow nil value
                drawing.content = json["body"].asString!;
            }
        }else{
            println("Warning: unsupported type= \(postType)");
            return nil;
        }
        
        // common
        model!.guid = json["guid"].asString!;
        model!.authors = scanUsers(json["authors"]).dic;
        model!.primaryAuthor = getUserById(json["primaryAuthorId"].asString!)!;
        model!.created = json["created"].asString!;
        model!.modified = json["modified"].asString!;
        
        return model;
    }
    
    func scanView(json:JSON)->KFModelArray<KFReference>{
        let refs = scanPostRefs(json["body"]);
        
        var posts:[String:KFPost] = [:];
        for ref in refs.array{
            if(ref.post != nil){
                posts[ref.post!.guid] = ref.post!;
            }
        }
        
        for each in json["buildsons"].asArray! {
            let fromId = each["from"].asString!;
            let toId = each["to"].asString!; //parent
            let from = posts[fromId];
            let to = posts[toId];
            if(from != nil && to != nil){
                from!.buildsOn = to;
            }
        }
        return refs;
    }
    
    func scanPostRefs(json:JSON)->KFModelArray<KFReference>{
        var models = KFModelArray<KFReference>();
        
        if(json["viewPostRefs"].isArray){
            for each in json["viewPostRefs"].asArray!{
                let ref = scanPostRef(each);
                models.add(ref);
            }
        }
        
        if(json["linkedViewReferences"].isArray){
            for each in json["linkedViewReferences"].asArray!{
                let ref = scanPostRef(each);
                models.add(ref);
            }
        }
        return models;
    }
    
    
    
    func scanPostRef(json:JSON)->KFReference{
        let model = KFReference();
        model.guid = json["guid"].asString!;
        let x = CGFloat(json["location"]["point"]["x"].asDouble!);
        let y = CGFloat(json["location"]["point"]["y"].asDouble!);
        let p = CGPointMake(x, y);
        model.location = p;
        
        if(json["viewReferenceId"].isString){
            let viewId = json["viewReferenceId"].asString!;
            let view = KFService.getInstance().currentRegistration.community.getView(viewId);
            model.post = view;
            return model;
        }
        
        //normal postinfo
        
        //scan reference
        model.displayFlags = json["display"].asInt!;
        model.width = CGFloat(json["width"].asInt!);
        model.height = CGFloat(json["height"].asInt!);
        model.rotation = CGFloat(json["rotation"].asDouble!);
        
        //scan postinfo
        let post = scanPost(json["postInfo"]);
        model.post = post;
        
        model.post!.beenRead = json["statusForAuthor"]["beenRead"].asBool!;
        model.post!.canEdit = json["statusForAuthor"]["canEdit"].asBool!;
        
        //    "statusForAuthor": {
        //        "authorGuid": "0b88232a-7016-47ac-bb5f-5a71e1512de6",
        //        "beenRead": true,
        //        "canEdit": false,
        //        "guid": "b1eb36ee-fafd-4ae6-a246-80bb2c2b82d9",
        //        "likes": false,
        //        "modified": "Jun 4, 2014 8:23:39 PM",
        //        "postGuid": "4ed978bb-b403-4a97-ae58-a4887858edef",
        //        "starred": false
        //    },
        
        return model;
    }
    
    func scanScaffolds(json:JSON)->KFModelArray<KFScaffold>{
        var models = KFModelArray<KFScaffold>();
        
        if(json.isArray){
            for each in json.asArray!{
                let model = KFScaffold();
                model.guid = each["guid"].asString!;
                model.title = each["title"].asString!;
                for eacheach in each["supports"].asArray! {
                    let support = KFSupport();
                    support.guid = eacheach["guid"].asString!;
                    support.title = eacheach["text"].asString!;
                    model.addSupport(support);
                }
                models.add(model);
            }
        }
        
        return models;
    }
    
    
    private func getUserById(userId:String) -> KFUser?{
        return KFService.getInstance().currentRegistration.community.getMember(userId);
    }
    
}
