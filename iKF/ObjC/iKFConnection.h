//
//  iKFConnection.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "iKF.h"

@class KFPostRefView;

@interface iKFConnection : NSObject

@property KFPostRefView* from;
@property KFPostRefView* to;

- (id) initFrom: (KFPostRefView*)from To: (KFPostRefView*)to;
    
@end
