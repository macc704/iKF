//
//  iKFModel.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/29.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFModel.h"

@implementation iKFModel

- (void) attach: (id)observer selector: (SEL)selector{
    [[NSNotificationCenter defaultCenter]
     addObserver: observer selector: selector name: @"CHANGED" object: self];
}

- (void) notify{
    [[NSNotificationCenter defaultCenter] postNotification:
     [NSNotification notificationWithName: @"CHANGED" object: self userInfo: nil]];
}

@end
