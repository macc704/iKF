//
//  iKFCompositeNoteViewController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKFModels.h"

@interface iKFCompositeNoteViewController : UITabBarController

- (void) setNote: (iKFNote*)note;

- (void) toEditMode;
- (void) toReadMode;

@end
