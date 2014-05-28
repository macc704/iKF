//
//  iKFNotePopupViewController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKF.h"
#import "iKFConnector.h"
#import "iKFModels.h"

@class iKFNoteView;

@interface iKFNotePopupViewController : UIViewController

@property iKFNote* note;
@property iKFConnector* connector;

@property iKFNoteView* noteView;//仮

@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (weak, nonatomic) IBOutlet UILabel *textFieldAuthor;
@property (weak, nonatomic) IBOutlet UITextView *textAreaContents;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)finishButtonPressed:(id)sender;


- (void) updateToModel;

@end
