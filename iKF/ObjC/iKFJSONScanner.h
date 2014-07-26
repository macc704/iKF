//
//  iKFJSONScanner.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-24.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KFUser;
@class KFNote;
@class KFPost;
@class KFReference;
@class KFRegistration;

@interface iKFJSONScanner : NSObject

- (NSArray*) scanRegistrations: (id)jsonobj;
- (NSArray*) scanViews: (id)jsonobj;
- (NSDictionary*) scanPosts: (id)jsonobj;
- (NSArray*) scanScaffolds:(id)jsonobj;
- (NSString*) generateRandomString: (int)len;

@end
