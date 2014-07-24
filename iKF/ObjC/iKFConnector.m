//
//  iKFConnector.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-05-13.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFConnector.h"

#import "iKFAbstractNoteEditView.h"
#import "iKFNotePopupViewController.h"
#import "iKFMainViewController.h"
#import "iKF-Swift.h"

static iKFConnector* singleton;

@implementation iKFConnector
{
    KFRegistration* _registration;
    NSDictionary* _views;
    NSString* _editTemplate;
    NSString* _readTemplate;
    NSString* _mobileJS;
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

- (NSURL*) getBaseURL{
    NSString* baseURLStr = [NSString stringWithFormat: @"http://%@/", [iKFConnector getInstance].host ];
    NSURL* baseURL = [[NSURL alloc] initWithString:baseURLStr];
    return baseURL;
}

- (BOOL) testConnectionToTheHost{
    return [self testConnectionToTheURL: [NSString stringWithFormat: @"http://%@/", self.host]] == 200;
}

- (long) testConnectionToTheURL: (NSString*) urlString{
    return [self connectToTheURL: urlString bodyString: nil];
}

- (NSString*) getMobileJS{
    if(_mobileJS == nil){
        _mobileJS = [self getURL: @"https://dl.dropboxusercontent.com/u/11409191/ikf/kfmobile.js"];
    }
    return _mobileJS;
}

- (NSString*) getEditTemplate{
    if(_editTemplate == nil){
        _editTemplate = [self getURL: @"http://dl.dropboxusercontent.com/u/11409191/ikf/edit.html"];
    }
    return _editTemplate;
}

- (NSString*) getReadTemplate{
    if(_readTemplate == nil){
        _readTemplate = [self getURL: @"http://dl.dropboxusercontent.com/u/11409191/ikf/read.html"];
    }
    return _readTemplate;
}

- (NSString*) getURL: (NSString*) urlString{
    NSString* str = nil;
    long status = [self connectToTheURL: urlString bodyString: &str];
    if(status == 200){
        return str;
    }else{
        [self handleError: @"getURL"];
        return nil;
    }
}

- (long) connectToTheURL: (NSString*) urlString bodyString: (NSString**)bodyString{
    KFService* service = [KFService getInstance];
    KFHttpResponse* res = [service connectToTheURL: urlString];
    if([res getStatusCode] == 200 && bodyString != nil){
        *bodyString = [res getBodyAsString];
    }
    return [res getStatusCode];
}

//- (long) connectToTheURL: (NSString*) urlString bodyString: (NSString**)bodyString{
//    NSURL* url = [NSURL URLWithString: urlString];
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
//    [req setHTTPMethod: @"GET"];
//    [req setTimeoutInterval: 12.0];
//    NSHTTPURLResponse *res = nil;
//    NSError *error = nil;
//    if(bodyString != nil){
//        NSData* bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
//        *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
//    }else{
//        [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
//    }
//    if(res != nil){
//        return [res statusCode];
//    }else if(error != nil){
//        return [error code];
//    }else{
//        [self handleError: @"Neither res nor error."];
//    }
//    return 0;
//}

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
        [self handleError: @"login() failed"];
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
        [self handleError: @"at currentUser"];
        return nil;
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
        [self handleError: [NSString stringWithFormat: @"error happening in getRegistrations() code=%d", [res statusCode] ]];
        return nil;
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
        [self handleError: @"at registerCommunity"];
        return NO;
    }
    
    return YES;
}

- (BOOL) enterCommunity: (KFRegistration*)registration{
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/account/selectSection/%@", self.host, registration.guid]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"GET"];
    NSHTTPURLResponse *res = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    
    if([res statusCode] != 200){
        [self handleError: @"at currentUser"];
        return NO;
    }
    
    _registration = registration;
    return YES;
}

- (void) handleError: (NSString*)msg{
    NSLog(@"iKFConnectionError - %@", msg);
}

- (NSArray*) getViews: (NSString*)communityId {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/content/getSectionViews/%@", self.host, communityId]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    NSHTTPURLResponse *res;
    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    if([res statusCode] != 200){
        [self handleError: @"at getViews."];
        return nil;
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
        [self handleError: @"at getPosts."];
        return nil;
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
        [self handleError: @"at movePost."];
        return NO;
    }
    
    return YES;
}

- (NSString*) getNoteAsHTML: (KFPost*)post {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/getNoteAsHTMLwJS/%@", self.host, post.guid]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"GET"];
    NSHTTPURLResponse *res;
    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    NSString* bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];

    if([res statusCode] != 200){
        //[NSException raise:@"iKFConnectionException" format:@"at getNoteAsHTML."];

        return nil;
    }
    
    return bodyString;
}

- (BOOL) readPost: (KFPost*)post {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/readPost/%@", self.host, post.guid]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
    NSHTTPURLResponse *res;
    /*NSData *bodyData =*/ [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    //NSLog(@"%d", [res statusCode]);
    if([res statusCode] != 200){
        [self handleError: @"at readPost."];
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
        [self handleError: @"at createNoted"];
        return NO;
    }
    
    return YES;
}

- (BOOL) updatenote: (KFNote*)note{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/updateNote/%@", self.host, note.guid]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
    [req setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString* title = [self escapeString: note.title];
    NSString* body = [self escapeString: note.content];
    //NSLog(@"%@", body);
    NSString* formStr = [NSString stringWithFormat: @"title=%@&body=%@", title, body];
    NSData *formdata = [formStr dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody: formdata];
    NSHTTPURLResponse *res;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    if([res statusCode] != 200){
        [self handleError: @"at createNoted"];
        return NO;
    }
    
    return YES;
}

- (NSString*) escapeString: unescaped{
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                              NULL,
                                                              (CFStringRef)unescaped,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]\" ",
                                                              kCFStringEncodingUTF8));
}

- (NSArray*) getScaffolds: (NSString*)viewId {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/getScaffolds/%@", self.host, viewId]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    NSHTTPURLResponse *res;
    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    if([res statusCode] != 200){
        [self handleError: @"at getScaffolds."];
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

- (BOOL) createPicture: (UIImage*)image onView:(NSString*)viewId location:(CGPoint)p{
    NSData* imageData = UIImagePNGRepresentation(image);
    NSString* filename = [NSString stringWithFormat: @"%@.jpg", [self generateRandomString:8]];
    id jsonobj = [self sendAttachment:imageData mime:@"image/jpeg" filename: filename];
    if(jsonobj == nil){
        return NO;
    }
    
    int w = (int)image.size.width;
    int h = (int)image.size.height;
    NSString* attachmentURL = jsonobj[@"url"];
    NSMutableString* svg = [[NSMutableString alloc] init];
    [svg appendFormat: @"<svg width=\"%d\" height=\"%d\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:svg=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">", w, h];
    [svg appendFormat: @"<g id=\"group\">"];
    [svg appendFormat: @"<title>Layer 1</title>"];
    [svg appendFormat: @"<image xlink:href=\"/%@\" id=\"svg_5\" x=\"0\" y=\"0\" width=\"%d\" height=\"%d\" />", attachmentURL, w, h];
    [svg appendFormat: @"</g></svg>"];
    
    return [self createDrawing:viewId svg:svg location:p];
}


- (id) sendAttachment: (NSData*)data mime: (NSString*)mime filename: (NSString*) filename{
    // generate url
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/file/easyUpload/%@", self.host, _registration.communityId]];
    
    // generate form boundary
    NSString* formBoundary = [NSString stringWithFormat:@"----FormBoundary%@", [self generateRandomString:16]];
    NSString *path = [NSString stringWithFormat: @"C\\fakepath\\%@", filename];
    
    // generate post body
    NSMutableData* postbody = [[NSMutableData alloc] init];
    [postbody appendData:[[NSString stringWithFormat:@"--%@\n", formBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"%@\"\n", filename ] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Type: %@\n\n", mime] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:data];
    [postbody appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"--%@\n", formBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"%@", path] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"--%@--\n", formBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // generate req
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
    [req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", formBoundary] forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody: postbody];
    [req setValue: [NSString stringWithFormat: @"%d", [postbody length] ] forHTTPHeaderField:@"Content-Length"];

    // send request
    NSHTTPURLResponse *res;
    NSData* bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    if([res statusCode] != 200){
        //[NSException raise:@"iKFConnectionException" format:@"at createNoted"];
        return nil;
    }

    id jsonobj = [NSJSONSerialization JSONObjectWithData: bodyData options:NSJSONReadingAllowFragments error:nil];
    return jsonobj;
    // {"size":"1309004","url":"kforum_uploads/a6748b4d-5491-459d-9a4d-e3b43d430985/hoge.jpg"}
}

- (BOOL) createDrawing: (NSString*)viewId svg: (NSString*)svg location: (CGPoint)p{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/createDrawing/%@", self.host, viewId]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
    NSString* formStr = [NSString stringWithFormat: @"svg=%@&x=%d&y=%d", svg, (int)p.x, (int)p.y];
    NSData *formdata = [formStr dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody: formdata];
    NSHTTPURLResponse *res;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    if([res statusCode] != 200){
        //[NSException raise:@"iKFConnectionException" format:@"at createNoted"];
        return NO;
    }
    
    return YES;
}

- (int) getNextViewVersionAsync: (NSString*)viewId currentVersion: (int) currentVersion{
    NSString* currentVersionStr = [NSString stringWithFormat:@"%d", currentVersion];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@/kforum/rest/mobile/getNextViewVersionAsync/%@/%@", self.host, viewId, currentVersionStr]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"GET"];
    NSHTTPURLResponse *res;
    NSData *bodyData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
    
    if([res statusCode] != 200){
        [self handleError: @"at getNextViewVersionAsync."];
        return -1;
    }
    
    NSString* bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    return bodyString.intValue;
}

- (void) debugPrint: (NSData*) bodyData{
    NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", bodyString);
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
