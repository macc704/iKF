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
    NSDictionary* _views;
    NSMutableDictionary* _users;
}

- (id) init{
    _views = [[NSDictionary alloc] init];
    _users = [[NSMutableDictionary alloc] init];
    return self;
}

- (NSArray*) scanRegistrations: (id)jsonobj{
    NSMutableArray* models = [NSMutableArray array];
    for (id each in jsonobj) {
        KFRegistration* model = [[KFRegistration alloc] init];
        model.guid = each[@"guid"];
        model.communityId = each[@"sectionId"];
        model.communityName = each[@"sectionTitle"];
        model.roleName = each[@"roleInfo"][@"name"];
        [models addObject: model];
    }
    return models;
}

- (NSArray*) scanViews: (id)jsonobj{
    _views = [[NSMutableDictionary alloc] init];//create cash
    NSMutableArray* models = [NSMutableArray array];
    for (id each in jsonobj) {
        KFView* model = [[KFView alloc] init];
        model.guid = each[@"guid"];
        model.title = each[@"title"];
        model.published = [each[@"published"] boolValue];
        [models addObject: model];
        [_views setValue:model forKey:model.guid];//create cash
    }
    return models;
}

- (NSDictionary*) scanPosts: (id)jsonobj{
    NSMutableDictionary* models = [NSMutableDictionary dictionary];
    for (id each in jsonobj[@"viewPostRefs"]) {
        [self scanPostRef:each models:models];
    }
    
    for (id each in jsonobj[@"linkedViewReferences"]) {
        [self scanPostRef:each models:models];
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

- (void)scanPostRef:(id)each models:(NSMutableDictionary *)models {
    KFReference* reference = [[KFReference alloc] init];
    
    reference.guid = each[@"guid"];
    CGFloat x = [each[@"location"][@"point"][@"x"] floatValue];
    CGFloat y = [each[@"location"][@"point"][@"y"] floatValue];
    CGPoint p = CGPointMake(x, y);
    reference.location = p;
    
    if(each[@"viewReferenceId"] != nil){
        //KFView* model = [[KFView alloc] init];
        NSString* guid = each[@"viewReferenceId"];
        KFView* model = _views[guid];
        if(model == nil){
            [[KFService getInstance] refreshViews];
            model = _views[guid];//retry
            if(model == nil){
                NSLog(@"Warning: view link to not found id= %@", guid);
                return;
            }
        }
        reference.post = model;
        [models setObject: reference forKey: reference.guid];
        return;
    }else{//normal postinfo
        //NSLog(@"%@", each[@"display"]);
        reference.displayFlags = [each[@"display"] intValue];
        reference.width = [each[@"width"] intValue];
        reference.height = [each[@"height"] intValue];
        reference.rotation = [each[@"rotation"] doubleValue];
    }
    
    NSDictionary* eachPost = each[@"postInfo"];
    if([eachPost[@"postType"] isEqualToString: @"NOTE"]){
        KFNote* model = [[KFNote alloc] initWithoutAuthor];
        model.guid = eachPost[@"guid"];
        model.title = eachPost[@"title"];
        model.content = eachPost[@"body"];
        
        //KFUser* user = [[KFUser alloc] init];
        //user.firstName = eachPost[@"authors"][0][@"firstName"];
        //user.lastName = eachPost[@"authors"][0][@"lastName"];
        //model.primaryAuthor = user;
        model.authors = [self parseUsers: eachPost[@"authors"]];
        model.primaryAuthor = [self getUserById: eachPost[@"primaryAuthorId"]];
        reference.post = model;
    }
    else if([eachPost[@"postType"] isEqualToString: @"DRAWING"]){
        KFDrawing* model = [[KFDrawing alloc] init];
        model.guid = eachPost[@"guid"];
        if([[eachPost allKeys] containsObject: @"body"]){//swift beta4 does not allow nil value
            model.content = eachPost[@"body"];
        }
        reference.post = model;
    }else{
        NSLog(@"Warning: unsupported type= %@", eachPost[@"postType"]);
        return;
    }
    
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
    
    [models setObject: reference forKey: reference.guid];
}

- (NSArray*) parseUsers: (id)jsons {
    NSMutableArray* users = [[NSMutableArray alloc] init];
    for (id json in jsons) {
        NSString* guid = json[@"guid"];
        KFUser* user = [self getUserById: guid];
        user.guid = guid;
        user.firstName = json[@"firstName"];
        user.lastName = json[@"lastName"];
        [users addObject: user];
    }
    return users;
}

- (KFUser*) getUserById: (NSString*)userId{
    if(_users[userId] == nil){
       _users[userId] = [[KFUser alloc] init];
    }
    return _users[userId];
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
