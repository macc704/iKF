//
//  iKFAbstractNoteEditView.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKFAbstractNoteView.h"

@interface iKFAbstractNoteEditView : iKFAbstractNoteView

@property UIBarButtonItem* scaffoldButton;
@property NSString* viewId;

-(void) setText: text title: title;
-(void) insertText: text;

-(NSString*)getText;
-(NSString*)getTitle;

@end
