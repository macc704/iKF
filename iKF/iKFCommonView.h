//
//  iKFCommonView.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-04.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iKFCommonView : UIView

@property UIView* mainView;
@property UINavigationBar* headerBar;
@property UINavigationItem* headerBarItem;
@property UIToolbar* footerBar;
@property float bottommargin;

- (id)initWithHeader: (BOOL)isCreateHeader footer: (BOOL)isCreateFooter;
- (void)createCloseButtonWithTitle: (NSString*)title target: (id)target selector: (SEL)selector;
- (void)layoutMainViewWidth: (float)width height: (float)height;

@end
