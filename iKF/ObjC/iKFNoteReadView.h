//
//  iKFNoteReadView.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKFAbstractNoteView.h"
//#import "iKFWebView.h"

@class KFWebView;

@interface iKFNoteReadView : iKFAbstractNoteView

@property KFWebView* _webView;

-(void) showPage: (NSString*)urlString title: (NSString*) title;
-(void) showHTML: (NSString*)textString title: (NSString*) title;
    
@end
