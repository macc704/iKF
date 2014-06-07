//
//  iKFNote.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/29.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iKFModel.h"

@class KFUser;

@interface iKFNote : iKFModel

@property NSString* guid;
@property NSString* title;
@property NSString* content;
@property KFUser* primaryAuthor;
@property CGPoint location;
@property iKFNote* buildsOn;
@property NSString* refId;

- (id) initWithAuthor: (KFUser*) author;

@end
