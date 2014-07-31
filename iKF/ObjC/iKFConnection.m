//
//  iKFConnection.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFConnection.h"

#import "iKFAbstractNoteEditView.h"
//#import "iKFMainViewController.h"
#import "iKFNotePopupViewController.h"
#import "iKF-Swift.h"

@implementation iKFConnection{
    
}

- (id) initFrom: (KFPostRefView*)from To: (KFPostRefView*)to{
    self = [super init];
    if(self){
        self.from = from;
        self.to = to;
    }
    return self;
}


@end
