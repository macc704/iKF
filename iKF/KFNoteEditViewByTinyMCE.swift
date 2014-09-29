//
//  KFNoteEditViewByTinyMCE.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-02.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNoteEditViewByTinyMCE: KFAbstractNoteView {

    var scaffoldButton:UIBarButtonItem!;
    var viewId:String!;
    
    var containerView:UIView!;
    var titleLabel:UILabel!;
    var titleView:UITextField!;
    var sourceLabel:UILabel!;
    var webView:KFTinyMCEView!;
    
    private var cachedTitle:String?;
    
    private var portrait = true;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init();
        
        // Initialization code
        self.scaffoldButton = UIBarButtonItem(title: "Scaffold", style: UIBarButtonItemStyle.Bordered, target: self, action: "scaffoldPressed");
        self.navBarItem!.rightBarButtonItem = self.scaffoldButton;

        // container
        containerView = UIView();
        self.addSubview(containerView);
        
        // titleview
        titleLabel = UILabel();
        titleLabel.text = "Title:";
        titleLabel.font = UIFont.systemFontOfSize(24);
        containerView.addSubview(titleLabel);
        
        titleView = UITextField();
        titleView.font = UIFont.systemFontOfSize(24);
        titleView.layer.borderColor = UIColor.blackColor().CGColor;
        titleView.layer.borderWidth = 1.0;
        containerView.addSubview(titleView);
        
        
        // textview
        sourceLabel = UILabel();
        sourceLabel.text = "Editor:";
        sourceLabel.font = UIFont.systemFontOfSize(24);
        containerView.addSubview(sourceLabel);
        
        webView = KFTinyMCEView();
        webView.scrollView.scrollEnabled = true;
        webView.scrollView.bounces = false;
        containerView.addSubview(webView);
    }
    
    func scaffoldPressed(){
        if(self.viewId == nil){
            return;
        }
        let controller = KFScaffoldingTableViewController(nibName: nil, bundle: nil);
        controller.selectedHandler = {(support:KFSupport) in
            self.webView.insertSupport(support);
        }
        controller.scaffolds = KFService.getInstance().getScaffolds(self.viewId);
        KFPopoverManager.getInstance().openInPopoverFromBarButton(scaffoldButton, controller: controller);
    }
    
    func setText(text:String, title:String) {
        self.setNavBarTitle("Edit");
        self.cachedTitle = title;
        titleView.text = title;
        
        webView.setText(text);
    }
    
    func getText() -> String?{
        return webView.getText();
    }
    
    func getTitle() -> String?{
        return titleView.text;
    }
    
    func isDirty() -> Bool{
        return isTitleDirty() || webView.isDirty();
    }
    
    private func isTitleDirty() -> Bool {
        return cachedTitle != nil && cachedTitle! != titleView.text;
    }
    
    override func layoutContentWithRect(rect: CGRect) {
        containerView.frame = rect;
        
        //_textView.frame = CGRectMake(100,100,100,100);
        var x:CGFloat = 20.0;
        var y:CGFloat = 20.0;
        let fullWidth = rect.size.width-40;
        let fullHeight = rect.size.height-40;
        
        self.portrait = fullWidth < fullHeight;
        
        //title label
        titleLabel.frame = CGRectMake(x, y, 100, 35);
        titleView.frame = CGRectMake(x+100, y, fullWidth-100, 35);
        y=y+40;
        
        //source label
        sourceLabel.frame = CGRectMake(x, y, fullWidth, 35);
        if(portrait){
            y=y+40;
            webView.frame = CGRectMake(x, y, fullWidth, 520);
            webView.refreshAreaHeight(400);
        }else{//landscape
            webView.frame = CGRectMake(x+100, y, fullWidth-100, 220);
            webView.refreshAreaHeight(100);
        }
    }

}
