//
//  iKFJSONScanner.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-24.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KFModelArray;
@class KFUser;
@class KFNote;
@class KFPost;
@class KFReference;
@class KFRegistration;

@interface iKFJSONScanner : NSObject

- (NSArray*) scanRegistrations: (id)jsonobj;
- (NSArray*) scanViews: (id)jsonobj;
- (NSArray*) scanUsers: (id)jsonobj;
- (NSArray*) scanPosts: (id)jsonobj;
- (KFPost*) scanPost: (id)jsonobj;
- (NSDictionary*) scanPostRefs: (id)jsonobj;
- (KFReference*) scanPostRef: (id)jsonobj;
- (NSArray*) scanScaffolds:(id)jsonobj;
- (NSString*) generateRandomString: (int)len;

//- (NSDictionary*) getUsers;

@end
