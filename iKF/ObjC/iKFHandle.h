//
//  iKFHandle.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iKF.h"
#import "iKFMainViewController.h"

@class iKFMainViewController;

@interface iKFHandle : UIView

- (id)init: (iKFMainViewController*)controller target: (UIView*)target;

@end
