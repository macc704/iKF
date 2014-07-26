//
//  iKFNoteReadView.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFNoteReadView.h"
//#import "iKFConnector.h"
#import "iKFWebView.h"
#import "iKF-Swift.h"

@implementation iKFNoteReadView{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //web
        self._webView = [[iKFWebView alloc] init];
        self._webView.scrollView.scrollEnabled = TRUE;
        [self addSubview: self._webView];
    }
    return self;
}

-(void) showPage: (NSString*)urlString title: (NSString*) title{
    [self setNavBarTitle: title];
    NSURL* url = [[NSURL alloc] initWithString: urlString];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:url];
    [self._webView loadRequest:req];
}

-(void) showHTML: (NSString*)textString title: (NSString*) title{
    [self setNavBarTitle: title];
    
    NSString* template = [[KFService getInstance] getReadTemplate];
    NSString* html = [template stringByReplacingOccurrencesOfString:@"%YOURCONTENT%" withString:textString];
    [self._webView loadHTMLString: html baseURL:nil];
    //[_webView loadHTMLString: textString baseURL:nil];
}


-(void) layoutContentWithRect: (CGRect) rect{
    CGRect newRect = CGRectMake(rect.origin.x+20, rect.origin.y+20, rect.size.width-40, rect.size.height-40);
    self._webView.frame = newRect;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
