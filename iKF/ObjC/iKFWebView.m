//
//  iKFWebView.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-19.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFWebView.h"

#import "iKFAbstractNoteEditView.h"
#import "iKFMainViewController.h"
#import "iKFNotePopupViewController.h"
#import "iKF-Swift.h"

@implementation iKFWebView{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIMenuItem* menu = [[UIMenuItem alloc] initWithTitle: @"Paste As Reference" action:@selector(onPasteAsReference:)] ;
        UIMenuController* mc = [UIMenuController sharedMenuController];
        mc.menuItems = @[menu];
    }
    return self;
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    //NSLog(@"can perform action");
    if( action == @selector(onPasteAsReference:)){
        if (self.pasteAsReferenceTarget != nil && [self hasReference]){
            return YES;
        }else{
            return NO;
        }
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (BOOL) hasReference{
    return [self getGuidFromPasteboard] != nil;
}

- (NSString*) getGuidFromPasteboard{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if(pasteboard.numberOfItems < 0){
        return nil;
    }
    NSData* guidData = [[pasteboard items][0] valueForKey: @"kfmodel.guid"];
    if (guidData == nil){
        return nil;
    }
    NSString* guid = [[NSString alloc] initWithData:guidData encoding:NSUTF8StringEncoding];
    return guid;
}

- (void) onPasteAsReference: (UIMenuController*) sender{
    //NSLog(@"paste as reference");
    
    if (self.pasteAsReferenceTarget == nil){
        return;
    }
    
    NSString* guid = [self getGuidFromPasteboard];
    if(guid == nil){
        return;
    }
    
    NSString* pasteString = [NSString stringWithFormat: @"<kf:postreference postId=\"%@\">%@</kf:postreference>", guid, [UIPasteboard generalPasteboard].string];
    [self.pasteAsReferenceTarget pasteAsReference: pasteString];
}

- (void) copy: (UIMenuController*) sender
{
    [super copy: sender];
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    
    if(self.kfModel != nil && pasteboard.numberOfItems > 0){
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary: [pasteboard items][0]];
        [dic setValue: self.kfModel.guid forKey: @"kfmodel.guid"];
        pasteboard.items = @[dic];
    }
}

// This was overriden by javascript on tinyMCE -- yoshiaki
//- (void) paste: (UIMenuController*) sender
//{
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
