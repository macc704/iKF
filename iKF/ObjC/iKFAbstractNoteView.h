//
//  iKFAbstractNoteView.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KFNote;

@interface iKFAbstractNoteView : UIView

@property UIViewController* closableController;
@property KFNote* model;
@property UINavigationItem* navBarItem;

-(void) setNavBarTitle: title;
-(void) layoutContentWithRect: (CGRect) rect;

@end
