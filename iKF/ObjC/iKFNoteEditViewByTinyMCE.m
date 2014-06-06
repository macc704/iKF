//
//  iKFNoteEditViewByTinyMCE.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFNoteEditViewByTinyMCE.h"
#import "iKFConnector.h"

@implementation iKFNoteEditViewByTinyMCE{
    UIView* _containerView;
    UILabel* _titleLabel;
    UITextField* _titleView;
    UILabel* _sourceLabel;
    UIWebView* _webView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // container
        _containerView = [[UIView alloc] init];
        [self addSubview: _containerView];
        
        
        {// titleview
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.text = @"Title:";
            [_titleLabel setFont:[UIFont systemFontOfSize:24]];
            [_containerView addSubview:_titleLabel];
            
            _titleView = [[UITextField alloc] init];
            [_titleView setFont:[UIFont systemFontOfSize:24]];
            [_titleView.layer setBorderColor:[UIColor blackColor].CGColor];
            [_titleView.layer setBorderWidth:1.0];
            [_containerView addSubview:_titleView];
        }
        
        {// textview
            _sourceLabel = [[UILabel alloc] init];
            _sourceLabel.text = @"Editor:";
            [_sourceLabel setFont:[UIFont systemFontOfSize:24]];
            [_containerView addSubview:_sourceLabel];
            
            _webView
            = [[UIWebView alloc] init];
            //[_sourceView setFont:[UIFont systemFontOfSize:24]];
            [_webView.layer setBorderColor:[UIColor blackColor].CGColor];
            [_webView.layer setBorderWidth:1.0];
            [_containerView addSubview:_webView];
        }
    }
    return self;
}

-(void) setText: text title: title{
    [self setNavBarTitle: @"Edit"];
    [_titleView setText: title];
    
    //NSURL* url = [[NSURL alloc] initWithString: @"http://dl.dropboxusercontent.com/u/11409191/test/test4.html"];
    //NSURLRequest * req = [[NSURLRequest alloc] initWithURL:url];
    //[_webView loadRequest:req];
    
    NSString* template = [[iKFConnector getInstance] getURL: @"http://dl.dropboxusercontent.com/u/11409191/test/test4.html"];
    NSString* html = [template stringByReplacingOccurrencesOfString:@"%YOURCONTENT%" withString:text];
    [_webView loadHTMLString: html baseURL:nil];
}

-(NSString*)getText{
    NSString* text = [_webView stringByEvaluatingJavaScriptFromString:@"getHTML();"];
    return text;
}

-(NSString*)getTitle{
    return _titleView.text;
}

-(void) layoutContentWithRect: (CGRect) rect{
    _containerView.frame = rect;
    
    //_textView.frame = CGRectMake(100,100,100,100);
    float x = 20.0;
    float y = 20.0;
    float fullWidth = rect.size.width-40;
    float fullHeight = rect.size.height-40;
    
    _titleLabel.frame = CGRectMake(x, 20, 100, 35);
    _titleView.frame = CGRectMake(x+100, 20, fullWidth-100, 35);
    y+=40;
    
    _sourceLabel.frame = CGRectMake(x, y, fullWidth, 35);
    y+=40;
    _webView.frame = CGRectMake(x, y, fullWidth, fullHeight-y);
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
