//
//  iKFNotePopupViewController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iKFConnector.h"
#import "iKFMainViewController.h"

@class iKFNoteView;
@class KFCanvasViewController;
@class iKFPostRefView;
@class KFNote;

@interface iKFNotePopupViewController : UIViewController

//@property iKFConnector* connector;
@property KFNote* note;
@property KFPostRefView* noteView;//仮

@property KFCanvasViewController* kfViewController;
@property UIPopoverController* popController;

@property (weak, nonatomic) IBOutlet UILabel *textFieldAuthor;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)finishButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;

//- (void) updateToModel;

@end
