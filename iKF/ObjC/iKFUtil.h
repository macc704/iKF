//
//  iKFUtil.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-01.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iKFUtil : NSObject

+ (NSString*) getBuildDate;
+ (NSString*) getBuildTime;
+ (NSString*) generateRandomString: (int)len;

@end
