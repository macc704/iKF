//
//  iKFConnectionLayerView.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iKF.h"

@class KFPostRefView;

@interface iKFConnectionLayerView : UIView

//@property NSMutableArray* connections;
- (void) addConnectionFrom: (KFPostRefView*)from To: (KFPostRefView*)to;

- (void) requestRepaint;

- (void) noteRemoved: (KFPostRefView*)removedNote;

- (void) clearAllConnections;

@end
