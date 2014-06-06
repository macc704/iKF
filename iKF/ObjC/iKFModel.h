//
//  iKFModel.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/29.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iKFModel : NSObject

- (void) attach: (id)observer selector: (SEL)selector;
- (void) notify;

@end
