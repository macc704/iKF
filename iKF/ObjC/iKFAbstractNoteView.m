//
//  iKFAbstractNoteView.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFAbstractNoteView.h"

@implementation iKFAbstractNoteView{
    UINavigationBar* _headerView;
    UINavigationItem* _navBarItem;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //header
        _headerView = [[UINavigationBar alloc] init];
        [self addSubview: _headerView];
        _navBarItem= [[UINavigationItem alloc] initWithTitle:@"Title"];
        UIBarButtonItem* closeButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Close"
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(closePressed)];
        _navBarItem.rightBarButtonItem = closeButton;
        [_headerView pushNavigationItem:_navBarItem animated:NO];
    }
    return self;
}

-(void)closePressed{
    if(self.closableController){
        [self.closableController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) setNavBarTitle: title{
    _navBarItem.title = title;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    //参考：http://qiita.com/yuch_i/items/b4612fae110254c816f4
    
    float y = 0;
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    // status bar
    float statusBarHeight = 20;
    y += statusBarHeight;
    
    // 固定の高さのヘッダー(UINavigationBar等)
    _headerView.frame = CGRectMake(0, y, width, 44);
    y += _headerView.frame.size.height;
    
    // 固定の高さのフッター(UITabBar,UIToolbar等)
    float footerHeight = 49;//TabBar
    //_footerView.frame = CGRectMake(height - 44, 0, width, 44);
    
    // 可変の高さのコンテンツ(UITableView,UIScrollView等)
    [self layoutContentWithRect: CGRectMake(0, y, width,  height - (y + footerHeight))];
}

-(void) layoutContentWithRect: (CGRect) rect{
    
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
