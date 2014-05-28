//
//  iKFNotePopupViewController.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFNotePopupViewController.h"

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
    self.textFieldTitle.text = self.note.title;
    self.textFieldAuthor.text = [self.note.primaryAuthor getFullName];
    [self.webView loadHTMLString: self.note.content baseURL: nil];
    self.textAreaContents.text = self.note.content;
}

- (void) updateToModel{
    self.note.title = self.textFieldTitle.text;
    self.note.content = self.textAreaContents.text;
    if(self.connector != nil){
        [self.connector updatenote: self.note];
    }
    [self.note notify];
}

- (IBAction)finishButtonPressed:(id)sender {
    [self.noteView closePopupViewer];
}

@end
