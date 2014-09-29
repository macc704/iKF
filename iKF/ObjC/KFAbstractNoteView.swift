//
//  KFAbstractNoteView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFAbstractNoteView: UIView {
    
    var closableController:UIViewController?;
    var model:KFNote!;
    var navBarItem:UINavigationItem!;
    var _headerView:UINavigationBar!;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        
        _headerView = UINavigationBar();
        self.addSubview(_headerView);
        self.navBarItem = UINavigationItem(title: "Title");
        let closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Bordered, target: self, action: "closePressed");
        
        self.navBarItem.leftBarButtonItem = closeButton;
        _headerView.pushNavigationItem(self.navBarItem, animated:false);
    }
    
    func closePressed(){
        self.closableController?.dismissViewControllerAnimated(false, completion: nil);
    }
    
    func setNavBarTitle(title:String){
        self.navBarItem.title = title;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        //参考：http://qiita.com/yuch_i/items/b4612fae110254c816f4
        
        var y:CGFloat = 0;
        let width:CGFloat = self.bounds.size.width;
        let height:CGFloat = self.bounds.size.height;
        
        // status bar
        let statusBarHeight:CGFloat = 20;
        y = y + statusBarHeight;
        
        // 固定の高さのヘッダー(UINavigationBar等)
        _headerView.frame = CGRectMake(0, y, width, 44);
        y += _headerView.frame.size.height;
        
        // 固定の高さのフッター(UITabBar,UIToolbar等)
        let footerHeight:CGFloat = 49;//TabBar
        //_footerView.frame = CGRectMake(height - 44, 0, width, 44);
        
        // 可変の高さのコンテンツ(UITableView,UIScrollView等)
        self.layoutContentWithRect(CGRectMake(0, y, width,  height - (y + footerHeight)));
    }
    
    func layoutContentWithRect(rect:CGRect){
    }
    
}
