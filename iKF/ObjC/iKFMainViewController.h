//
//  iKFMainViewController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iKF.h"
//#import "iKFConnector.h"
#import "iKFViewSelectionController.h"

//@class iKFNoteView;
@class KFPostRefView;
@class KFReference;
@class KFUser;
@class KFNote;
@class KFView;
@class KFRegistration;

@interface iKFMainViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

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
//- (IBAction)updateButtonPressed:(id)sender;

- (void) showHandle: (UIView*)view;
- (void) removeHandle;

- (void) createNote: (CGPoint)p;
- (void) createNote: (CGPoint)p buildson: (KFPostRefView*)from;
- (void) deletePostRef: (KFPostRefView*) view;
- (void) requestConnectionsRepaint;
- (void) openNoteEditController: (KFNote*)note mode: (NSString*)mode;
- (void) updatePostRef: (KFReference*) ref;

- (void) setKFView: (KFView*) view;
    
- (void) go:(KFRegistration*)registration;
//- (void) setJSON: (id)json;

- (void) postLocationChanged: (KFPostRefView*) noteview;

@end
