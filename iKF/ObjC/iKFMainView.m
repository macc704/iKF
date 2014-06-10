//
//  iKFMainPanel.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/29.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFMainView.h"
#import "iKFLayerView.h"

@implementation iKFMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.drawingLayer = [[iKFLayerView alloc] init];
        self.drawingLayer.backgroundColor = [UIColor clearColor];
        self.drawingLayer.userInteractionEnabled = YES;
        [self addSubview: self.drawingLayer];
        
        self.connectionLayer = [[iKFConnectionLayerView alloc] init];
        [self addSubview: _connectionLayer];
        //[self.scrollView addSubview: _connectionLayer];//NG for scaling
        
        self.noteLayer = [[iKFLayerView alloc] init];
        self.noteLayer.backgroundColor = [UIColor clearColor];
        [self addSubview: self.noteLayer];
    }
    return self;
}

- (void) setSizeWithWidth: (float)width height: (float)height{
    self.frame = CGRectMake(0, 0, width, height);
    self.drawingLayer.frame = self.frame;
    self.connectionLayer.frame = self.frame;
    self.noteLayer.frame = self.frame;
}

- (void) clearViews{
    [self removeChildren: self.drawingLayer];
    [self removeChildren: self.noteLayer];
    [self.connectionLayer clearAllConnections];
}

- (void) removeChildren: (UIView*)view{
    for (UIView* subview in view.subviews) {
        [subview removeFromSuperview];
    }
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
