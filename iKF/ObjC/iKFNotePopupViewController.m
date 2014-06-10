//
//  iKFNotePopupViewController.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFNotePopupViewController.h"

#import "iKFMainViewController.h"
#import "iKF-Swift.h"

@interface iKFNotePopupViewController ()

@end

@implementation iKFNotePopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self update];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) update{
    //self.view subviews
    self.titleLabel.text = self.note.title;
    [self.titleLabel setNumberOfLines:0];
    [self.titleLabel sizeToFit];
    self.textFieldAuthor.text = [self.note.primaryAuthor getFullName];
    [self.textFieldAuthor setNumberOfLines:0];
    [self.textFieldAuthor sizeToFit];
    
    NSString* template = [[iKFConnector getInstance] getReadTemplate];
    NSString* html = [template stringByReplacingOccurrencesOfString:@"%YOURCONTENT%" withString:self.note.content];
    [self.webView loadHTMLString: html baseURL: nil];
}

- (IBAction)finishButtonPressed:(id)sender {
    [self.popController dismissPopoverAnimated:false];
}

- (IBAction)editButtonPressed:(id)sender {
    [self.popController dismissPopoverAnimated:false];
    [self.kfViewController openNoteEditController: self.note mode:@"edit"];
}

@end
