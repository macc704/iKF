//
//  iKFConnection.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iKF.h"

@interface iKFConnection : NSObject

@property iKFNoteView* from;
@property iKFNoteView* to;

- (id) initFrom: (iKFNoteView*)from To: (iKFNoteView*)to;
    
@end
