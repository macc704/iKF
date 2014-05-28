//
//  iKFMainViewController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKF.h"
#import "iKFModels.h"
#import "iKFConnector.h"

@class iKFNoteView;

@interface iKFMainViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIPickerViewDelegate>

@property iKFUser* user;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bgButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIPickerView *viewchooser;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)bgButtonPressed:(id)sender;
- (IBAction)notePlusButtonPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;
- (IBAction)viewSelectionPressed:(id)sender;

- (void) showHandle: (UIView*)view;
- (void) createNote: (CGPoint)p;
- (void) createNote: (CGPoint)p buildson: (iKFNoteView*)from;
- (void) removeNote: (iKFNoteView*) view;
- (void) requestConnectionsRepaint;

- (void) initServer: (iKFConnector*)connector communityId: (NSString*)communityId;
//- (void) setJSON: (id)json;

- (void) postLocationChanged: (iKFNoteView*) noteview;

@end
