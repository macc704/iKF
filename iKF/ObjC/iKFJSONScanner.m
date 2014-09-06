//
//  iKFJSONScanner.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-24.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFJSONScanner.h"

#import "iKF-Swift.h"

@implementation iKFJSONScanner{
    //    NSDictionary* _views;
    //    NSMutableDictionary* _users;
}

- (id) init{
    //    _views = [[NSDictionary alloc] init];
    //    _users = [[NSMutableDictionary alloc] init];
    return self;
}

- (NSArray*) scanRegistrations: (id)jsonobj{
    NSMutableArray* models = [NSMutableArray array];
    for (id each in jsonobj) {
        KFRegistration* model = [[KFRegistration alloc] init];
        model.guid = each[@"guid"];
        model.roleName = each[@"roleInfo"][@"name"];
        KFCommunity* community = [[KFCommunity alloc] init];
        community.guid = each[@"sectionId"];
        community.name = each[@"sectionTitle"];
        model.community = community;
        
        [models addObject: model];
    }
    return models;
}

- (NSArray*) scanViews: (id)jsonobj{
    NSMutableArray* models = [[NSMutableArray alloc] init];
    for (id each in jsonobj) {
        KFView* model = [[KFView alloc] init];
        model.guid = each[@"guid"];
        model.title = each[@"title"];
        model.published = [each[@"published"] boolValue];
        model.authors = [self scanAuthors: each[@"authors"]];
        model.primaryAuthor = [self getUserById: each[@"primaryAuthorId"]];
        
        [models addObject: model];
    }
    return models;
}

- (NSDictionary*) scanAuthors: (id) jsonobj{
    NSMutableDictionary* authors = [[NSMutableDictionary alloc] init];
    for (id eachAuthor in jsonobj) {
        NSString* authorGUID = eachAuthor[@"guid"];
        KFUser* user = [self getUserById: authorGUID];
        if(user == nil){
            NSLog(@"nil user for guid=%@", authorGUID);
            continue;
        }
        authors[authorGUID] = user;
    }
    return authors;
}

- (NSArray*) scanUsers: (id)jsonobj{
    NSMutableArray* models = [[NSMutableArray alloc] init];
    for (id json in jsonobj) {
        NSString* guid = json[@"guid"];
        KFUser* model = [[KFUser alloc] init];
        model.guid = guid;
        model.firstName = json[@"firstName"];
        model.lastName = json[@"lastName"];
        [models addObject: model];
    }
    return models;
}

- (NSArray*) scanPosts: (id)jsonobj{
    NSMutableArray* models = [[NSMutableArray alloc] init];
    for (id each in jsonobj) {
        KFPost* post = [self scanPost: each];
        if(post != nil){
            [models addObject: post];
        }
    }
    return models;
}

- (KFPost*) scanPost: (id)eachPost{
    
    KFPost* model;
    if([eachPost[@"postType"] isEqualToString: @"NOTE"]){
        KFNote* note = [[KFNote alloc] initWithoutAuthor];
        model = note;
        note.title = eachPost[@"title"];
        note.content = eachPost[@"body"];
    }
    else if([eachPost[@"postType"] isEqualToString: @"DRAWING"]){
        KFDrawing* drawing = [[KFDrawing alloc] init];
        model = drawing;
        if([[eachPost allKeys] containsObject: @"body"]){//swift beta4 does not allow nil value
            drawing.content = eachPost[@"body"];
        }
    }else{
        NSLog(@"Warning: unsupported type= %@", eachPost[@"postType"]);
        return nil;
    }
    
    // common
    model.guid = eachPost[@"guid"];
    model.authors = [self scanAuthors: eachPost[@"authors"]];
    model.primaryAuthor = [self getUserById: eachPost[@"primaryAuthorId"]];
    model.created = eachPost[@"created"];
    model.modified = eachPost[@"modified"];
    
    return model;
}

- (NSDictionary*) scanPostRefs: (id)jsonobj{
    NSMutableDictionary* models = [NSMutableDictionary dictionary];
    for (id each in jsonobj[@"viewPostRefs"]) {
        KFReference* ref = [self scanPostRef:each];
        if(ref != nil){
            [models setObject: ref forKey: ref.guid];
        }
    }
    
    for (id each in jsonobj[@"linkedViewReferences"]) {
        KFReference* ref = [self scanPostRef:each];
        if(ref != nil){
            [models setObject: ref forKey: ref.guid];
        }
    }
    
    for (id each in jsonobj[@"buildOns"]) {
        NSString* toRefId = each[@"built"];
        NSString* fromRefId = each[@"buildsOn"];
        //NSLog(@"builds from %@ to %@", fromId, toId);
        ((KFNote*)((KFReference*)models[fromRefId]).post).buildsOn = (KFNote*)((KFReference*)models[toRefId]).post;
        //NSLog(@"buildson %@", [models[fromId] buildsOn]);
    }
    return models;
}

- (KFReference*)scanPostRef:(id)each {
    KFReference* reference = [[KFReference alloc] init];
    
    reference.guid = each[@"guid"];
    CGFloat x = [each[@"location"][@"point"][@"x"] floatValue];
    CGFloat y = [each[@"location"][@"point"][@"y"] floatValue];
    CGPoint p = CGPointMake(x, y);
    reference.location = p;
    
    if(each[@"viewReferenceId"] != nil){
        //KFView* model = [[KFView alloc] init];
        NSString* guid = each[@"viewReferenceId"];
        KFView* model = [[KFService getInstance].currentRegistration.community getView: guid];
        if(model == nil){
            [[KFService getInstance] refreshViews];
            model = [[KFService getInstance].currentRegistration.community getView: guid];//retry
            if(model == nil){
                NSLog(@"Warning: view link to not found id= %@", guid);
                return nil;
            }
        }
        reference.post = model;
        return reference;
    }
    
    //normal postinfo
    //NSLog(@"%@", each[@"display"]);
    reference.displayFlags = [each[@"display"] intValue];
    reference.width = [each[@"width"] intValue];
    reference.height = [each[@"height"] intValue];
    reference.rotation = [each[@"rotation"] doubleValue];
    
    // scan postinfo
    KFPost* post = [self scanPost: each[@"postInfo"]];
    if(post == nil){
        return nil;
    }
    reference.post = post;
    
    reference.post.beenRead = [each[@"statusForAuthor"][@"beenRead"] boolValue];
    reference.post.canEdit = [each[@"statusForAuthor"][@"canEdit"] boolValue];
    
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
    
    return reference;
}

//- (NSDictionary*) getUsers{
//    return _users;
//}

- (KFUser*) getUserById: (NSString*)userId{
    return [[KFService getInstance].currentRegistration.community getMember: userId];
}

- (NSArray*) scanScaffolds:(id)jsonobj{
    NSMutableArray* models = [[NSMutableArray alloc] init];
    for (id scaffoldJ in jsonobj) {
        KFScaffold* scaffold = [[KFScaffold alloc] init];
        scaffold.guid = scaffoldJ[@"guid"];
        scaffold.title = scaffoldJ[@"title"];
        for (id supportJ in scaffoldJ[@"supports"]) {
            KFSupport* support = [[KFSupport alloc] init];
            support.guid = supportJ[@"guid"];
            support.title = supportJ[@"text"];
            [scaffold addSupport: support];
        }
        [models addObject:scaffold];
    }
    return models;
}

// http://kelp.phate.org/2012/06/post-picture-to-google-image-search.html
-(NSString *)generateRandomString: (int)len {
    static const char randomSeedCharArray[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q',
        'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
        'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
    char *result;   // result with c-string
    result = malloc(len + 1);
    
    for (int index = 0; index < len; index++) {
        result[index] = randomSeedCharArray[arc4random() % sizeof(randomSeedCharArray)];
    }
    result[len] = '\0';
    
    // result NSString
    NSString *resultString = [NSString stringWithCString:result encoding:NSUTF8StringEncoding];
    free(result);
    return resultString;
}

@end
