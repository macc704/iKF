//
//  iKFNoteReadViewController.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFNoteReadViewController.h"
#import "iKFWebView.h"

#import "iKFAbstractNoteEditView.h"
#import "iKFNotePopupViewController.h"
#import "iKFMainViewController.h"
#import "iKF-Swift.h"

@interface iKFNoteReadViewController ()

@end

@implementation iKFNoteReadViewController{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void) loadView {
    [super loadView];
    self.readView = [[iKFNoteReadView alloc] init];
    self.view = self.readView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//- (void)viewWillAppear:(BOOL)animated 反映されない
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.note){
        self.readView._webView.kfModel = self.note;
        [[iKFConnector getInstance] readPost: self.note];
        self.note.beenRead = true;
        //[self.readView showPage: @"http://www.google.co.jp" title: @"google"];
        [self.readView showHTML:self.note.content title:self.note.title];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
