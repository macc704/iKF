//
//  iKFResources.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-05-15.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFResources.h"

@implementation iKFResources


+ (NSString*) get: (NSString*) name{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSError *error;
    NSString *text = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    return text;
}

@end
