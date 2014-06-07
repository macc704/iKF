//
//  iKFCompositeNoteViewController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KFNote;

@interface iKFCompositeNoteViewController : UITabBarController

- (void) setNote: (KFNote*)note;

- (void) toEditMode;
- (void) toReadMode;

@end
