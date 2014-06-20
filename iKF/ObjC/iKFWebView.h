//
//  iKFWebView.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-19.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iKFCanPasteReference
- (void) pasteAsReference: (NSString*)text;
@end

@class KFModel;

@interface iKFWebView : UIWebView

@property KFModel* kfModel;
@property id<iKFCanPasteReference> pasteAsReferenceTarget;

@end
