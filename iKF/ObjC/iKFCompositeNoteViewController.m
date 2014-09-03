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
//#import "iKFNoteEditViewByTinyMCE.h"
#import "iKF-Swift.h"

@implementation iKFCompositeNoteViewController{
    iKFNoteReadViewController* controllerA;
    iKFNoteEditViewController* controllerB;
    iKFNoteEditViewController* controllerC;
    BOOL editMode;
}

-(id) init{
    self = [super init];
    if(self){
        controllerA = [[iKFNoteReadViewController alloc] initWithNibName:nil bundle:nil];
        controllerA.view.backgroundColor = [UIColor whiteColor];
        controllerA.readView.closableController = self;
        controllerA.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Read" image:nil selectedImage:nil];
        
        controllerC = [[iKFNoteEditViewController alloc] initWithView:(iKFAbstractNoteEditView*)[[KFNoteEditViewByTinyMCE alloc] init]];
        controllerC.view.backgroundColor = [UIColor whiteColor];
        controllerC.editView.closableController = self;
        controllerC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Edit" image:nil selectedImage:nil];
        
        controllerB = [[iKFNoteEditViewController alloc] initWithView:(iKFAbstractNoteEditView*)[[iKFNoteEditViewBySource alloc] init]];
        controllerB.view.backgroundColor = [UIColor whiteColor];
        controllerB.editView.closableController = self;
        controllerB.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Source" image:nil selectedImage:nil];
        
        editMode = false;
        
    }
    return self;
}

- (void) toReadMode{
    if(controllerA.note != nil){
        self.selectedViewController = controllerA;
    }else{
        editMode = false;
    }
}

- (void) toEditMode{
    if(controllerA.note != nil){
        self.selectedViewController = controllerC;
    }else{
        editMode = true;
    }
}

- (void) setNote: (KFNote*)note andViewId: (NSString*)viewId{
    controllerA.note = note;
    controllerB.note = note;
    controllerC.note = note;
    controllerB.editView.viewId = viewId;
    controllerC.editView.viewId = viewId;

    [self addChildViewController: controllerA];
    if([note canEditMe] == true){
        [self addChildViewController: controllerC];
        //[self addChildViewController: controllerB];
    }
    
    if(editMode == true){
        [self toEditMode];
    }
}

@end
