//
//  iKFNoteEditViewByTinyMCE.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKFAbstractNoteEditView.h"
//#import "iKFWebView.h"

@interface iKFNoteEditViewByTinyMCE : iKFAbstractNoteEditView <UIWebViewDelegate>

-(void) insertText: text;

@end
