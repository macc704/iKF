//
//  iKFMainViewController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iKF.h"
#import "iKFConnector.h"
#import "iKFViewSelectionController.h"

//@class iKFNoteView;
@class KFPostRefView;
@class KFUser;
@class KFNote;

@interface iKFMainViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIPickerViewDelegate, iKFTableSelectionListener>

@property KFUser* user;

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewSelectionButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewSelectionButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bgButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)bgButtonPressed:(id)sender;
- (IBAction)notePlusButtonPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;
- (IBAction)viewSelectionPressed:(id)sender;

- (void) showHandle: (UIView*)view;
- (void) createNote: (CGPoint)p;
- (void) createNote: (CGPoint)p buildson: (KFPostRefView*)from;
- (void) removeNote: (KFPostRefView*) view;
- (void) requestConnectionsRepaint;
- (void) openNoteEditController: (KFNote*)note mode: (NSString*)mode;

- (void) initServer: (iKFConnector*)connector communityId: (NSString*)communityId;
//- (void) setJSON: (id)json;

- (void) postLocationChanged: (KFPostRefView*) noteview;

@end
