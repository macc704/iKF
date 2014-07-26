//
//  iKFNoteEditViewController.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFNoteEditViewController.h"
//#import "iKFConnector.h"

#import "iKFAbstractNoteEditView.h"
#import "iKFMainViewController.h"
#import "iKFNotePopupViewController.h"
#import "iKF-Swift.h"

@interface iKFNoteEditViewController ()

@end

@implementation iKFNoteEditViewController

- (id)initWithView: (iKFAbstractNoteEditView*) editview{
    self.editView = editview;
    return self;
}

-(void) loadView {
    [super loadView];
    self.view = self.editView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.note){
        [self.editView setText:self.note.content title: self.note.title];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.note){
        [self updateToModel];
    }
}

- (void) updateToModel{
    NSString* newTitle = [self.editView getTitle];
    bool dirty = false;
    if(![newTitle isEqualToString: self.note.title]){
        dirty = true;
    }
    NSString* newContent = [self.editView getText];
    if(![newContent isEqualToString: self.note.content]){
        dirty = true;
    }
    
    if(dirty){
        self.note.title = newTitle;
        self.note.content = newContent;
        [[KFService getInstance] updateNote: self.note];
        [self.note notify];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
