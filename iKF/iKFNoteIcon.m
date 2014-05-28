//
//  iKFNoteIcon.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFNoteIcon.h"

@implementation iKFNoteIcon

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void) drawRect: (CGRect) rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();  // コンテキストを取得
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);  // 白
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));  // 塗りつぶす
    CGContextSetRGBFillColor(context, 0, 0, 1, 1);  // 青
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));  // 円を塗りつぶす
    //CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);  // 黒
    //CGContextStrokeEllipseInRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));  // 円の描画
}

@end
