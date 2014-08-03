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
//#import "iKFMainViewController.h"
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

    dispatch_queue_t sub_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(sub_queue, ^{
        [[KFService getInstance] readPost: self.note];
    });

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
    
    //v1
    //NSString* template = [[iKFConnector getInstance] getReadTemplate];
    //NSString* html = [template stringByReplacingOccurrencesOfString:@"%YOURCONTENT%" withString:self.note.content];
    
    //v2
    //NSString* html = [[iKFConnector getInstance] getNoteAsHTML: self.note];
    //[self.webView loadHTMLString: html baseURL: [[iKFConnector getInstance] getBaseURL]];
    
    //v3
    NSString* mobileJS = [[KFService getInstance] getMobileJS];
    if(mobileJS != nil){
        [((iKFWebView*)self.webView) stringByEvaluatingJavaScriptFromString: mobileJS];
    }
    NSString* template = [[KFService getInstance] getReadTemplate];
    NSString* html;
    if(template != nil){
        html = [template stringByReplacingOccurrencesOfString:@"%YOURCONTENT%" withString:self.note.content];
    }else{
        html = self.note.content;
    }
    NSString* baseURLStr = [[KFService getInstance] getHostURL];
    NSURL* baseURL = [[NSURL alloc] initWithString:baseURLStr];
    [self.webView loadHTMLString: html baseURL: baseURL];
    
    self.note.beenRead = true;
    [self.note notify];
}

- (IBAction)finishButtonPressed:(id)sender {
//    [self.popController dismissPopoverAnimated:false];
    [[KFPopoverManager getInstance] closeCurrentPopoverWithAnimated:false];
}

- (IBAction)editButtonPressed:(id)sender {
//    [self.popController dismissPopoverAnimated:false];
    [[KFPopoverManager getInstance] closeCurrentPopoverWithAnimated:false];
    [self.kfViewController openNoteEditController: self.note mode:@"edit"];
}

@end
