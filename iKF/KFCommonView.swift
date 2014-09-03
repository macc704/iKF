//
//  KFCommonView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFCommonView: UIView {
    
    var mainView:UIView!;
    var headerBar:UINavigationBar!;
    var headerBarItem:UINavigationItem!;
    var footerBar:UIToolbar!;
    var bottommargin:CGFloat = 0.0; // never used
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(isCreateHeader:Bool,  isCreateFooter:Bool){
        super.init();
        
        self.backgroundColor = UIColor.whiteColor();
        
        self.mainView = UIView();
        self.mainView.backgroundColor = UIColor.whiteColor();
        self.addSubview(self.mainView);
        
        if(isCreateHeader){
            self.headerBar = UINavigationBar();
            self.addSubview(self.headerBar);
            self.headerBarItem = UINavigationItem(title: "Title");
            self.headerBar.pushNavigationItem(self.headerBarItem, animated:false);
        }
        
        if(isCreateFooter){
            self.footerBar = UIToolbar();
            self.addSubview(self.footerBar);
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        //referenced http://qiita.com/yuch_i/items/b4612fae110254c816f4
        
        let width = self.bounds.size.width;
        let height = self.bounds.size.height;
        
        var y:CGFloat = 0;
        var bottom:CGFloat = height - self.bottommargin;
        
        // status bar
        let statusBarHeight:CGFloat = 20;
        y = y + statusBarHeight;
        
        // 固定の高さのヘッダー(UINavigationBar等)
        if(self.headerBar != nil){
            let barheight:CGFloat = 44;
            self.headerBar.frame = CGRectMake(0, y, width, barheight);
            y = y + barheight;
        }
        
        // 固定の高さのフッター(UITabBar,UIToolbar等)
        if(self.footerBar != nil){
            let barheight:CGFloat = 44;
            self.footerBar.frame = CGRectMake(0, bottom-barheight, width, barheight);
            bottom = bottom - barheight;
        }//Tabbarは49
        
        // 可変の高さのコンテンツ(UITableView,UIScrollView等)
        if(self.mainView != nil){
            self.mainView.frame = CGRectMake(0, y, width, bottom-y);
        }
        self.layoutMainViewWidth(width, height: bottom-y);
    }
    
    func layoutMainViewWidth(width:CGFloat, height:CGFloat){
    }
    
    
    func createCloseButtonWithTitle(title:String, target:AnyObject, selector:Selector){
        let closeButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Bordered, target: target, action: selector);
        self.headerBarItem.leftBarButtonItem = closeButton;
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
    // Drawing code
    }
    */
    
}
