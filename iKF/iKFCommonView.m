//
//  iKFCommonView.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-04.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFCommonView.h"

@implementation iKFCommonView{
    
}

- (id)initWithHeader: (BOOL)isCreateHeader footer: (BOOL)isCreateFooter{
    self = [super init];
    
    self.backgroundColor = [UIColor whiteColor];
    self.bottommargin = 0.0;
    
    self.mainView = [[UIView alloc] init];    
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview: self.mainView];
    
    if(isCreateHeader){
        self.headerBar = [[UINavigationBar alloc] init];
        [self addSubview: self.headerBar];
        self.headerBarItem = [[UINavigationItem alloc] initWithTitle:@"Title"];
        [self.headerBar pushNavigationItem: self.headerBarItem animated:NO];
    }
    
    if(isCreateFooter){
        self.footerBar = [[UIToolbar alloc] init];
        [self addSubview: self.footerBar];
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    //referenced http://qiita.com/yuch_i/items/b4612fae110254c816f4
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    float y = 0;
    float bottom = height - self.bottommargin;
    
    // status bar
    float statusBarHeight = 20;
    y += statusBarHeight;
    
    // 固定の高さのヘッダー(UINavigationBar等)
    if(self.headerBar != nil){
        float barheight = 44;
        self.headerBar.frame = CGRectMake(0, y, width, barheight);
        y += barheight;
    }
    
    // 固定の高さのフッター(UITabBar,UIToolbar等)
    if(self.footerBar != nil){
        float barheight = 44;
        self.footerBar.frame = CGRectMake(0, bottom-barheight, width, barheight);
        bottom -= barheight;
    }//Tabbarは49
    
    // 可変の高さのコンテンツ(UITableView,UIScrollView等)
    if(self.mainView != nil){
        self.mainView.frame = CGRectMake(0, y, width, bottom-y);
    }
    [self layoutMainViewWidth:width height:bottom-y];
}

- (void)layoutMainViewWidth: (float)width height: (float)height{
}


- (void) createCloseButtonWithTitle: (NSString*)title target: (id)target selector: (SEL)selector{
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc]
                                    initWithTitle:title
                                    style:UIBarButtonItemStyleBordered
                                    target:target
                                    action:selector];
    self.headerBarItem.leftBarButtonItem = closeButton;
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
