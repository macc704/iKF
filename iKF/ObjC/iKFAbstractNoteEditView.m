//
//  iKFAbstractNoteEditView.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFAbstractNoteEditView.h"

#import "iKFAbstractNoteEditView.h"
#import "iKFMainViewController.h"
#import "iKFNotePopupViewController.h"
#import "iKF-Swift.h"

@implementation iKFAbstractNoteEditView{
    UIPopoverController* popController;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.scaffoldButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Scaffold"
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(scaffoldPressed)];
        self.navBarItem.rightBarButtonItem = self.scaffoldButton;
    }
    return self;
}

-(void) scaffoldPressed{
    if(self.viewId == nil){
        return;
    }
    KFScaffoldingTableViewController* controller = [[KFScaffoldingTableViewController alloc] initWithNibName:nil bundle:nil];
    controller.noteEditView = self;
    controller.scaffolds = [[iKFConnector getInstance] getScaffolds: self.viewId];
    popController = [[UIPopoverController alloc] initWithContentViewController:controller];
    [popController presentPopoverFromBarButtonItem:self.scaffoldButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void) insertText: text{
}

-(void) setText: text title: title{
}

-(NSString*)getText{
    return nil;
}

-(NSString*)getTitle{
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
