//
//  iKFNoteEditViewByTinyMCE.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//


#import "iKFNoteEditViewByTinyMCE.h"
//#import "iKFConnector.h"
//#import "iKFWebView.h"
//#import "iKFLoadingView.h"
#import "iKF-Swift.h"

@implementation iKFNoteEditViewByTinyMCE{
    UIView* _containerView;
    UILabel* _titleLabel;
    UITextField* _titleView;
    UILabel* _sourceLabel;
    KFWebView* _webView;
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
            
            _webView = [[KFWebView alloc] init];
            _webView.delegate = self;
//            _webView.pasteAsReferenceTarget = self;
            _webView.performPasteAsReference = ^(NSString* text){
                [self insertText:text];
            };
            _webView.scrollView.scrollEnabled = FALSE;
            [_webView.layer setBorderColor:[UIColor blackColor].CGColor];
            [_webView.layer setBorderWidth:1.0];
            [_containerView addSubview:_webView];
        }
    }
    return self;
}

- (void) pasteAsReference: (NSString*)text{
    [self insertText:text];
}

-(void) insertText: text{
    //NSLog(@"%@", text);
    NSString* insertString = text;
    insertString = [insertString stringByReplacingOccurrencesOfString: @"\\" withString: @"\\\\"];//order important
    insertString = [insertString stringByReplacingOccurrencesOfString: @"\r" withString: @""];
    insertString = [insertString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
    insertString = [insertString stringByReplacingOccurrencesOfString: @"'" withString: @"\\'"];
    [_webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat: @"tinymce.activeEditor.insertContent('%@')", insertString]];
}

//NSString* cashe;

-(void) setText: text title: title{
    //cashe = text;
    [self setNavBarTitle: @"Edit"];
    [_titleView setText: title];

    //1
    //NSURL* url = [[NSURL alloc] initWithString: @"http://dl.dropboxusercontent.com/u/11409191/test/test4.html"];
    //NSURLRequest * req = [[NSURLRequest alloc] initWithURL:url];
    //[_webView loadRequest:req];
    
    //2
    //NSString* template = [[iKFConnector getInstance] getEditTemplate];
    //NSString* html = [template stringByReplacingOccurrencesOfString:@"%YOURCONTENT%" withString:text];
    //[_webView loadHTMLString: html baseURL:nil];

    //v3
//    if(!loaded){
//        globalLoadingView = [[KFLoadingView alloc] init];
//        [globalLoadingView showOnView: _webView];
//        NSString* template = [[KFService getInstance] getEditTemplate];
//        NSString* html = [template stringByReplacingOccurrencesOfString:@"%YOURCONTENT%" withString:text];
//        [_webView loadHTMLString: html baseURL:nil];
//    }else{
//        [_webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat: @"tinymce.activeEditor.setContent('%@')", text]];
//    }
    if([self initialized]){
        NSString* insertString = [KFResource encodingForJS: text];
        NSString* js = [NSString stringWithFormat: @"tinymce.activeEditor.setContent('%@');", insertString];
        [_webView stringByEvaluatingJavaScriptFromString:js];
        return;
    }
    
    //v4 (local)
    NSString* insertString = [KFResource encodingForJS: text];
    NSString* js = [NSString stringWithFormat: @"window.onload = function(){tinymce.activeEditor.setContent('%@');}", insertString];
    [_webView stringByEvaluatingJavaScriptFromString:js];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"edit" ofType:@"html" inDirectory: @"WebResources"];
    NSLog(@"path? = %@", path);
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL: [[NSURL alloc] initWithString: path]];    
    [_webView loadRequest: req];
    
    //v5 (local 2)
//    NSString* template = [[KFService getInstance] getEditTemplate];
    //        NSString* html = [template stringByReplacingOccurrencesOfString:@"%YOURCONTENT%" withString:text];
    //        [_webView loadHTMLString: html baseURL:nil];
    
    
//    NSString* html = [template stringByReplacingOccurrencesOfString:@"%YOURCONTENT%" withString:text];
//    [_webView loadHTMLString: html baseURL:nil];
    
//    let path = NSBundle.mainBundle().pathForResource("edit", ofType: "html", inDirectory: "tinymce");
//    let req = NSURLRequest(URL: NSURL(fileURLWithPath: path));
//    webView.loadRequest(req);

}

- (BOOL) webView:(UIWebView*) webView shouldStartLoadWithRequest:(NSURLRequest*) request navigationType:(UIWebViewNavigationType) type{
    NSLog(@"shoud start? = %@", [request URL]);
    return true;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
//    NSLog(@"start\n");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

//    NSLog(@"a= %@\n", [_webView stringByEvaluatingJavaScriptFromString: @"tinymce.activeEditor;}"]);
    //    NSString* js = [NSString stringWithFormat: @"tinymce.activeEditor.setContent('aaa')"];
//    [_webView stringByEvaluatingJavaScriptFromString:js];
//    [_webView stringByEvaluatingJavaScriptFromString:@"window.alert('didfinish');"];
}

- (BOOL) initialized{
    NSString* res = [_webView stringByEvaluatingJavaScriptFromString:@"tinymce.activeEditor.isDirty();"];
    //returns true or false or ""
    if([res length] == 0){
        return false;
    }
//    NSLog(@"res = %@", res);
    return true;
}

-(NSString*)getText{
    NSString* text = [_webView stringByEvaluatingJavaScriptFromString:@"tinymce.activeEditor.getContent();"];
    //NSLog(@"getText: %@", text);
    //    if(text == nil || text.length == 0){
    //        return cashe;
    //    }
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
