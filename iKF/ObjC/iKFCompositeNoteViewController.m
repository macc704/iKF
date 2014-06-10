//
//  iKFCompositeNoteViewController.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFCompositeNoteViewController.h"
#import "iKFNoteReadViewController.h"
#import "iKFNoteEditViewController.h"
#import "iKFNoteEditViewBySource.h"
#import "iKFNoteEditViewByTinyMCE.h"

@implementation iKFCompositeNoteViewController{
    iKFNoteReadViewController* controllerA;
    iKFNoteEditViewController* controllerB;
    iKFNoteEditViewController* controllerC;
}

-(id) init{
    self = [super init];
    if(self){
        controllerA = [[iKFNoteReadViewController alloc] initWithNibName:nil bundle:nil];
        controllerA.view.backgroundColor = [UIColor whiteColor];
        controllerA.readView.closableController = self;
        controllerA.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Read" image:nil selectedImage:nil];
        [self addChildViewController: controllerA];
        
        controllerC = [[iKFNoteEditViewController alloc] initWithView:(iKFAbstractNoteEditView*)[[iKFNoteEditViewByTinyMCE alloc] init]];
        controllerC.view.backgroundColor = [UIColor whiteColor];
        controllerC.editView.closableController = self;
        controllerC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Edit" image:nil selectedImage:nil];
        [self addChildViewController: controllerC];
        
        controllerB = [[iKFNoteEditViewController alloc] initWithView:(iKFAbstractNoteEditView*)[[iKFNoteEditViewBySource alloc] init]];
        controllerB.view.backgroundColor = [UIColor whiteColor];
        controllerB.editView.closableController = self;
        controllerB.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Source" image:nil selectedImage:nil];
        [self addChildViewController: controllerB];
        
        [self toEditMode];
    }
    return self;
}

- (void) toReadMode{
    self.selectedViewController = controllerA;
}

- (void) toEditMode{
    self.selectedViewController = controllerC;
}

- (void) setNote: (KFNote*)note andViewId: (NSString*)viewId{
    controllerA.note = note;
    controllerB.note = note;
    controllerC.note = note;
    controllerB.editView.viewId = viewId;
    controllerC.editView.viewId = viewId;
}

@end
