//
//  iKFUser.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/29.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iKFModel.h"

@interface iKFUser : iKFModel

@property NSString* guid;
@property NSString* firstName;
@property NSString* lastName;

- (NSString*) getFullName;

@end
