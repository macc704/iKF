//
//  iKFLoadingView.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/29.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iKFLoadingView : UIView

- (void) show: (UIViewController*)controller;
- (void) showOnView: (UIView*)view;
- (void) hide;
    
@end
