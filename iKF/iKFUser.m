//
//  iKFUser.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/29.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFUser.h"

@implementation iKFUser

- (NSString*) getFullName{
    return [NSString stringWithFormat: @"%@ %@", self.firstName, self.lastName];
}

@end
