//
//  iKFConnector.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-05-13.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iKFModels.h"

@interface iKFConnector : NSObject

@property NSString* host;
@property NSMutableArray* registrations;

- (id) initWithHost: (NSString*)host;

- (BOOL) testConnectionToGoogle;
- (BOOL) testConnectionToTheHost;
    
- (BOOL) loginWithName: (NSString*)name password: (NSString*)password;
- (BOOL) enterCommunity: (NSString*)communityId;
- (NSArray*) getViews: (NSString*)communityId;

- (id) getPosts: (NSString*)viewid;

- (BOOL) movePost: (NSString*)viewId note: (iKFNote*)note;
- (BOOL) createNote: (NSString*)viewId buildsOn: (iKFNote*)buildsonNote location: (CGPoint)p;
- (BOOL) updatenote: (iKFNote*)note;

@end
