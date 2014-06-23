//
//  iKFNotePopupViewController.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFNotePopupViewController.h"
#import "iKFWebView.h"

#import "iKFAbstractNoteEditView.h"
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

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[iKFConnector getInstance] readPost: self.note];
    self.note.beenRead = true;
    [self update];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) update{
    ((iKFWebView*)self.webView).kfModel = self.note;
    //self.view subviews
    self.titleLabel.text = self.note.title;
    [self.titleLabel setNumberOfLines:0];
    [self.titleLabel sizeToFit];
    self.textFieldAuthor.text = [self.note.primaryAuthor getFullName];
    [self.textFieldAuthor setNumberOfLines:0];
    [self.textFieldAuthor sizeToFit];
    
    //NSString* template = [[iKFConnector getInstance] getReadTemplate];
    //NSString* html = [template stringByReplacingOccurrencesOfString:@"%YOURCONTENT%" withString:self.note.content];
    NSString* html = [[iKFConnector getInstance] getNoteAsHTML: self.note];
    [self.webView loadHTMLString: html baseURL: [[iKFConnector getInstance] getBaseURL]];
    
    self.note.beenRead = true;
    [self.note notify];
}

- (IBAction)finishButtonPressed:(id)sender {
    [self.popController dismissPopoverAnimated:false];
}

- (IBAction)editButtonPressed:(id)sender {
    [self.popController dismissPopoverAnimated:false];
    [self.kfViewController openNoteEditController: self.note mode:@"edit"];
}

@end
