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
@class KFPost;
@class KFReference;
@class KFRegistration;

@interface iKFConnector : NSObject

@property NSString* host;
//@property NSMutableArray* registrations;

+ (iKFConnector*) getInstance;
    
//- (id) initWithHost: (NSString*)host;

- (NSURL*) getBaseURL;
- (BOOL) testConnectionToGoogle;
- (BOOL) testConnectionToTheHost;
- (NSString*) getURL: (NSString*) urlString;

- (NSString*) getEditTemplate;
- (NSString*) getReadTemplate;

- (BOOL) loginWithName: (NSString*)name password: (NSString*)password;
- (KFUser*) getCurrentUser;
- (NSArray*) getRegistrations;
- (BOOL) registerCommunity: (NSString*)registrationCode;
- (BOOL) enterCommunity: (KFRegistration*)registration;
- (NSArray*) getViews: (NSString*)communityId;
- (NSArray*) getScaffolds: (NSString*)viewId;

- (NSString*) getNoteAsHTML: (KFPost*)post;
- (id) getPosts: (NSString*)viewid;

- (BOOL) movePost: (NSString*)viewId note: (KFReference*)ref;
- (BOOL) readPost: (KFPost*)post;
- (BOOL) createNote: (NSString*)viewId buildsOn: (KFReference*)buildsonNoteRef location: (CGPoint)p;
- (BOOL) updatenote: (KFNote*)note;

- (BOOL) createPicture: (UIImage*)image onView:(NSString*)viewId location:(CGPoint)p;


@end
