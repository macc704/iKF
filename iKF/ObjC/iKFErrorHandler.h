//
//  iKFErrorHandler.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iKFErrorHandler : NSObject

+ (void) hookErrorHandler: (UIApplication*)application;

@end
