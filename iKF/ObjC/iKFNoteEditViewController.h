//
//  iKFNoteEditViewController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKFAbstractNoteEditView.h"

@class KFNote;

@interface iKFNoteEditViewController : UIViewController

@property iKFAbstractNoteEditView* editView;
@property KFNote* note;

- (id)initWithView: (iKFAbstractNoteEditView*) editview;

@end
