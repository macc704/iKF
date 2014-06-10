//
//  iKFMainPanel.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/29.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iKFConnectionLayerView.h"

@interface iKFMainView : UIView

@property UIView* noteLayer;
@property UIView* drawingLayer;
@property iKFConnectionLayerView* connectionLayer;

- (void) setSizeWithWidth: (float)width height: (float)height;
- (void) clearViews;

@end
