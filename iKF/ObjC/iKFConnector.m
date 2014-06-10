//
//  iKFConnector.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-05-13.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFConnector.h"

#import "iKFNotePopupViewController.h"
#import "iKFMainViewController.h"
#import "iKF-Swift.h"

static iKFConnector* singleton;

@implementation iKFConnector
{
    NSDictionary* _views;
    NSString* _editTemplate;
    NSString* _readTemplate;
}

+ (iKFConnector*) getInstance{
    if(singleton == nil){
        singleton = [[iKFConnector alloc] init];
    }
    return singleton;
}

- (BOOL) testConnectionToGoogle{
    return [[iKFConnector getInstance] testConnectionToTheURL: @"http://www.google.com/"] == 200;
}

- (id) initWithHost: (NSString*)host{
    id x = [self init];
    self.host = host;
    _views = [[NSDictionary alloc] init];
    return x;
}

- (BOOL) testConnectionToTheHost{
    return [self testConnectionToTheURL: [NSString stringWithFormat: @"http://%@/", self.host]] == 200;
}

- (long) testConnectionToTheURL: (NSString*) urlString{
    return [self connectToTheURL: urlString bodyString: nil];
}

- (NSString*) getEditTemplate{
    if(_editTemplate == nil){
        _editTemplate = [self getURL: @"http://dl.dropboxusercontent.com/u/11409191/test/edit.html"];
    }
    return _editTemplate;
}

- (NSString*) getReadTemplate{
    if(_readTemplate == nil){
        _readTemplate = [self getURL: @"http://dl.dropboxusercontent.com/u/11409191/test/read.html"];
    }
    return _readTemplate;
}

- (NSString*) getURL: (NSString*) urlString{
    NSString* str = nil;
    long status = [self connectToTheURL: urlString bodyString: &str];
    if(status == 200){
        return str;
    }else{
        [NSException raise:@"iKFConnectionException" format:@"getURL() error"];
        return nil;
    }
}

- (long) connectToTheURL: (NSString*) urlString bodyString: (NSString**)bodyString{
    NSURL* url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"GET"];
    NSHTTPURLResponse *res = nil;
    NSError *error = nil;
    if(bodyString != nil){
        NSData* bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
        *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    }else{
        [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    }
    if(res != nil){
        return [res statusCode];
    }else if(error != nil){
        return [error code];
    }else{
        [NSException raise:@"iKFConnectionException" format:@"Neither res nor error."];
    }
    return 0;
}

- (BOOL) loginWithName: (NSString*)name password: (NSString*)password{
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/account/userLogin", self.host]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
    NSString *paramString = [NSString stringWithFormat: @"userName=%@&password=%@", name, password];
    NSData *param = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody: param];
    NSHTTPURLResponse *res = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    
    if([res statusCode] != 200){
        //[NSException raise:@"iKFConnectionException" format:@"at loginWithName."];
        return NO;
    }
    
    return YES;
}

- (KFUser*) getCurrentUser{
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/account/currentUser", self.host]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"GET"];
    NSHTTPURLResponse *res = nil;
    NSError *error = nil;
    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at currentUser."];
        return NO;
    }
    
    id jsonobj = [NSJSONSerialization JSONObjectWithData: bodyData options:NSJSONReadingAllowFragments error:nil];
    id each = jsonobj;
    KFUser* model = [[KFUser alloc] init];
    model.guid = each[@"guid"];
    model.firstName = each[@"firstName"];
    model.lastName = each[@"lastName"];
    
    return model;
}

- (NSArray*) getRegistrations{
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/account/registrations", self.host]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"GET"];
    NSHTTPURLResponse *res = nil;
    NSError *error = nil;
    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at regsitrations."];
        return NO;
    }
    
    id jsonobj = [NSJSONSerialization JSONObjectWithData: bodyData options:NSJSONReadingAllowFragments error:nil];
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

- (BOOL) registerCommunity: (NSString*)registrationCode{
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/register/%@", self.host, registrationCode]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
    NSHTTPURLResponse *res = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at registerCommunity."];
        return NO;
    }
    return YES;
}

- (BOOL) enterCommunity: (NSString*)communityId{
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/account/selectSection/%@", self.host, communityId]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"GET"];
    NSHTTPURLResponse *res = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at enterCommunity."];
        return NO;
    }
    return YES;
}

- (NSArray*) getViews: (NSString*)communityId {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/content/getSectionViews/%@", self.host, communityId]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    NSHTTPURLResponse *res;
    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at getViews."];
        return NO;
    }
    
    //[self printContents: bodyData];
    id jsonobj = [NSJSONSerialization JSONObjectWithData: bodyData options:NSJSONReadingAllowFragments error:nil];
    _views = [[NSMutableDictionary alloc] init];//create cash
    NSMutableArray* models = [NSMutableArray array];
    for (id each in jsonobj) {
        KFView* model = [[KFView alloc] init];
        model.guid = each[@"guid"];
        model.title = each[@"title"];
        [models addObject: model];
        [_views setValue:model forKey:model.guid];//create cash
    }
    
    return models;
}

- (NSDictionary*) getPosts: (NSString*)viewId {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/content/getView/%@", self.host, viewId]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    NSHTTPURLResponse *res;
    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    //[self printContents: bodyData];
    
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at getPosts."];
        return NO;
    }
    
    //NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF32StringEncoding];
    //    NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    //    NSLog(@"UTF8%@", bodyString);
    //    bodyString = [[NSString alloc] initWithData:bodyData encoding:NSASCIIStringEncoding];
    //    NSLog(@"ASCII%@", bodyString);
    id jsonobj = [NSJSONSerialization JSONObjectWithData: bodyData options:NSJSONReadingAllowFragments error:nil];
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
        reference.post = model;
        [models setObject: reference forKey: reference.guid];
        return;
    }
    
    NSDictionary* eachPost = each[@"postInfo"];
    if([eachPost[@"postType"] isEqualToString: @"NOTE"]){
        KFNote* model = [[KFNote alloc] initWithoutAuthor];
        model.guid = eachPost[@"guid"];
        model.title = eachPost[@"title"];
        model.content = eachPost[@"body"];
        
        KFUser* user = [[KFUser alloc] init];
        user.firstName = eachPost[@"authors"][0][@"firstName"];
        user.lastName = eachPost[@"authors"][0][@"lastName"];
        model.primaryAuthor = user;
        reference.post = model;
    }
    else if([eachPost[@"postType"] isEqualToString: @"DRAWING"]){
        KFDrawing* model = [[KFDrawing alloc] init];
        model.guid = eachPost[@"guid"];
        model.content = eachPost[@"body"];
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

- (BOOL) movePost: (NSString*)viewId note: (KFReference*)postRef {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/updatePostref/%@/%@", self.host, viewId, postRef.guid]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
    NSString* formStr = [NSString stringWithFormat: @"x=%d&y=%d", (int)postRef.location.x, (int)postRef.location.y];
    NSData *formdata = [formStr dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody: formdata];
    NSHTTPURLResponse *res;
    /*NSData *bodyData =*/ [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    //[self printContents: bodyData];
    
    //NSLog(@"%d", [res statusCode]);
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at movePost."];
        return NO;
    }
    
    return YES;
}

- (BOOL) readPost: (KFPost*)post {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/readPost/%@", self.host, post.guid]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
    NSHTTPURLResponse *res;
    /*NSData *bodyData =*/ [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    //NSLog(@"%d", [res statusCode]);
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at readPost."];
        return NO;
    }
    
    return YES;
}

- (BOOL) createNote: (NSString*)viewId buildsOn: (KFReference*)buildsonNoteRef location: (CGPoint)p{
    NSURL *url;
    if(buildsonNoteRef != nil){
        url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/createNote/%@/%@", self.host, viewId, buildsonNoteRef.guid]];//!!現在はrefId!!
    }else{
        url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/createNote/%@/%@", self.host, viewId, nil]];
    }
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
    NSString* formStr = [NSString stringWithFormat: @"x=%d&y=%d", (int)p.x, (int)p.y];
    NSData *formdata = [formStr dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody: formdata];
    NSHTTPURLResponse *res;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at createNoted"];
        return NO;
    }
    
    return YES;
}

- (BOOL) updatenote: (KFNote*)note{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/updateNote/%@", self.host, note.guid]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
    [req setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString* formStr = [NSString stringWithFormat: @"title=%@&body=%@", note.title, note.content];
    NSData *formdata = [formStr dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody: formdata];
    NSHTTPURLResponse *res;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at createNoted"];
        return NO;
    }
    
    return YES;
}

- (NSArray*) getScaffolds: (NSString*)viewId {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/getScaffolds/%@", self.host, viewId]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    NSHTTPURLResponse *res;
    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    if([res statusCode] != 200){
        [NSException raise:@"iKFConnectionException" format:@"at getScaffolds."];
        return nil;
    }
    
    id jsonobj = [NSJSONSerialization JSONObjectWithData: bodyData options:NSJSONReadingAllowFragments error:nil];
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
    
    //    [
    //     {
    //         "guid": "8bd3faac-0f94-4d1e-ae72-f32c2bc857f5",
    //         "title": "Theory Building",
    //         "supports": [
    //                      {
    //                          "guid": "dcc8d697-36b9-487f-9c38-601c0e99b415",
    //                          "text": "I need to understand",
    //                          "scaffoldGuid": "8bd3faac-0f94-4d1e-ae72-f32c2bc857f5",
    //                          "markedForDelete": false
    //                      },
    //                      {
    //                          "guid": "2bcea3d2-a797-497a-a641-1f74defb899e",
    //                          "text": "Putting our knowledge together",
    //                          "scaffoldGuid": "8bd3faac-0f94-4d1e-ae72-f32c2bc857f5",
    //                          "markedForDelete": false
    //                      },

}


//OLD version
//- (BOOL) movePost: (NSString*)viewId note: (iKFNote*)note {
//    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/forum/setPostLocation/%@", self.host, viewId]];
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
//    [req setHTTPMethod: @"POST"];
//    [req setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
//    NSString* jsonStr = [NSString stringWithFormat:
//    @"{"
//"        '^EncodedType': 'org.ikit.kbe.kf.shared.portable.PositionRef',"
//"        '^ObjectID': '2',"
//"        'point': {"
//"            '^EncodedType': 'org.ikit.kbe.kf.shared.portable.Point',"
//"            '^ObjectID': '3',"
//"            'x': %d,"
//"            'y': %d"
//"        },"
//"        'refType': {"
//"            '^EncodedType': 'org.ikit.kbe.kf.shared.portable.PositionRef$RefType',"
//"            '^EnumStringValue': 'VIEWPOSTREF'"
//"        },"
//"        'referenceId': '%@'"
//"    }", (int)note.location.x, (int)note.location.y, note.refId];
//    NSData *jsondata = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//    [req setHTTPBody: jsondata];
//    NSHTTPURLResponse *res;
//    /*NSData *bodyData =*/ [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
//    //[self printContents: bodyData];
//
//    //NSLog(@"%d", [res statusCode]);
//    if([res statusCode] != 200){
//        [NSException raise:@"iKFConnectionException" format:@"at getPosts."];
//        return NO;
//    }
//
//    return YES;
//}



//For debug
- (void) printContents: (NSData*) data{
    NSString *bodyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", bodyString);
}

//なんと，ここでもcookieは入れなくて良い．なんで？ keep/aliveしていなければそんなことできないはずだけど．
//- (void) kfauthor {
//    NSURL *url = [NSURL URLWithString:@"http://132.203.154.41:8080/kforum/rest/forum/author"];
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
//    //[req addValue: cookie forHTTPHeaderField: @"Cookie"];
//    NSHTTPURLResponse *res;
//    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
//    NSLog(@"statusCode=%d", [res statusCode]);
//    NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", [[res allHeaderFields] description]);
//    NSLog(@"%@", bodyString);
//
//}

//// old
//- (id) getPosts: (NSString*)viewid {
//    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/forum/allPostsInView/%@", self.host, viewid]];
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
//    NSHTTPURLResponse *res;
//    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
//    id jsonobj = [NSJSONSerialization JSONObjectWithData: bodyData options:NSJSONReadingAllowFragments error:nil];
//    return jsonobj;
//}

@end
