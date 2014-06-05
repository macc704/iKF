//
//  iKFAbstractNoteView.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKFModels.h"

@interface iKFAbstractNoteView : UIView

@property UIViewController* closableController;
@property iKFNote* model;

-(void) setNavBarTitle: title;

-(void) layoutContentWithRect: (CGRect) rect;

@end
