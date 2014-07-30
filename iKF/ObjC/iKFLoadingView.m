//
//  iKFLoadingView.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/29.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFLoadingView.h"

@implementation iKFLoadingView

UIActivityIndicatorView* _indicator;

- (id) init
{
    self = [super init];
    if (self) {
        // 雰囲気出すために背景を黒く半透明する
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5f;
        
        // でっかいグルグル
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self addSubview: _indicator];
    }
    return self;
}

- (void) show: (UIViewController*)controller{
    [self showOnView: controller.view];
}

- (void) showOnView: (UIView*)view{
    CGRect rect = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    self.frame = rect;
    [_indicator setCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)];
    [view addSubview: self];
    
    // ぐるぐる開始
    [_indicator startAnimating];
}

- (void) hide{
    // ぐるぐる停止
    [_indicator stopAnimating];
    
    //　削除
    [self removeFromSuperview];
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
