//
//  iKFUtil.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-01.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFUtil.h"

@implementation iKFUtil

+ (NSString*) getBuildDate{
    return [NSString stringWithUTF8String:__DATE__];
}

+ (NSString*) getBuildTime{
    return [NSString stringWithUTF8String:__TIME__];
}

@end
