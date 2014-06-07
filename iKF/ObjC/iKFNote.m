//
//  iKFNote.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/29.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFNote.h"
//#import "iKF-Swift.h"

static int idCounter;

@implementation iKFNote{
}

- (id) init{
    [self setGuid: [NSString stringWithFormat: @"temporary-%d",idCounter]];
    idCounter++;
    return self;
}

- (id) initWithAuthor: (KFUser*) author{
    [self setGuid: [NSString stringWithFormat: @"temporary-%d",idCounter]];
    idCounter++;
    self.primaryAuthor = author;
    self.title =  @"New Note";
    self.content = @"Test";
    return self;
}

@end
