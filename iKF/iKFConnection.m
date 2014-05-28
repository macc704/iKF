//
//  iKFConnection.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFConnection.h"
#import "iKF.h"

@implementation iKFConnection{
    
}

- (id) initFrom: (iKFNoteView*)from To: (iKFNoteView*)to{
    self = [super init];
    if(self){
        self.from = from;
        self.to = to;
    }
    return self;
}


@end
