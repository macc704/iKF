//
//  iKFNoteView.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKF.h"

@class iKFMainViewController;
@class KFNote;

@interface iKFNoteView : UIView <UIPopoverControllerDelegate>

@property KFNote* model;
@property iKFConnector* connector;

- (id)init: (iKFMainViewController*)controller note: (KFNote*)note;
- (void) die;

- (void) openPopupViewer;
- (void) closePopupViewer;

@end
