//
//  iKFConnector.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-05-13.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iKFModels.h"

@class KFUser;
@class KFNote;

@interface iKFConnector : NSObject

@property NSString* host;
//@property NSMutableArray* registrations;

+ (iKFConnector*) getInstance;
    
//- (id) initWithHost: (NSString*)host;

- (BOOL) testConnectionToGoogle;
- (BOOL) testConnectionToTheHost;
- (NSString*) getURL: (NSString*) urlString;
    
- (BOOL) loginWithName: (NSString*)name password: (NSString*)password;
- (KFUser*) getCurrentUser;
- (NSArray*) getRegistrations;
- (BOOL) registerCommunity: (NSString*)registrationCode;
- (BOOL) enterCommunity: (NSString*)communityId;
- (NSArray*) getViews: (NSString*)communityId;

- (id) getPosts: (NSString*)viewid;

- (BOOL) movePost: (NSString*)viewId note: (KFNote*)note;
- (BOOL) createNote: (NSString*)viewId buildsOn: (KFNote*)buildsonNote location: (CGPoint)p;
- (BOOL) updatenote: (KFNote*)note;

@end
