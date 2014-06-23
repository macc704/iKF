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
    if(action == @selector(onPasteAsReference:)){
        return [self canPerformPasteAsReference];
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (BOOL) canPerformPasteAsReference{
    return self.pasteAsReferenceTarget != nil && ([self getValue: @"kfmodel.guid"] != nil);
}

- (void) onPasteAsReference: (UIMenuController*) sender{
    if (![self canPerformPasteAsReference]){
        return;
    }
    
    NSString* guid = [self getValue: @"kfmodel.guid"];
    NSString* pasteString;
    if ([[self getValue: @"kfmodel"] isEqualToString: @"contentreference"]){
        pasteString = [NSString stringWithFormat: @"<kf-content-reference class=\"mceNonEditable\" postid=\"%@\">%@</kf-content-reference>", guid, [UIPasteboard generalPasteboard].string];
    }else{//assume postreference
        pasteString = [NSString stringWithFormat: @"<kf-post-reference class=\"mceNonEditable\" postid=\"%@\">%@</kf-post-reference>", guid, [UIPasteboard generalPasteboard].string];
        NSLog(@"%@", pasteString);
    }
    [self.pasteAsReferenceTarget pasteAsReference: pasteString];
}

- (void) copy: (UIMenuController*) sender
{
    [super copy: sender];
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    
    if(self.kfModel != nil && pasteboard.numberOfItems > 0){
        [self setValue: @"contentreference" forKey: @"kfmodel"];
        [self setValue: self.kfModel.guid forKey: @"kfmodel.guid"];
    }
}

- (NSString*) getValue: (NSString*) key {
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if(pasteboard.numberOfItems < 0){
        return nil;
    }
    NSData* data = [[pasteboard items][0] valueForKey: key];
    if (data == nil){
        return nil;
    }
    NSString* dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return dataStr;
}

- (void) setValue: (NSString*)value forKey: (NSString*) key{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if(pasteboard.numberOfItems < 0){
        return;
    }
    NSMutableDictionary* newdic = [NSMutableDictionary dictionaryWithDictionary: [pasteboard items][0]];
    [newdic setValue: value forKey: key];
    pasteboard.items = @[newdic];
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
