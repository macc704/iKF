//
//  iKFNoteReadViewController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKFNoteReadView.h"

@class KFNote;

@interface iKFNoteReadViewController : UIViewController

@property iKFNoteReadView* readView;
@property KFNote* note;

@end
