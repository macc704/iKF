//
//  KFAbstractNoteEditView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFAbstractNoteEditView: KFAbstractNoteView {
    
    var scaffoldButton:UIBarButtonItem!;
    var viewId:String!;
    
    //UIPopoverController* popController;
    //    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init();
        
        // Initialization code
        self.scaffoldButton = UIBarButtonItem(title: "Scaffold", style: UIBarButtonItemStyle.Bordered, target: self, action: "scaffoldPressed");
        self.navBarItem!.rightBarButtonItem = self.scaffoldButton;
    }
    
    func scaffoldPressed(){
        if(self.viewId == nil){
            return;
        }
        let controller = KFScaffoldingTableViewController(nibName: nil, bundle: nil);
        controller.selectedHandler = {(support:KFSupport) in
            let uniqueId = String(Int(NSDate.date().timeIntervalSince1970));
            let template = KFResource.loadScaffoldTagTemplate();
            var insertString = template;
            insertString = insertString.stringByReplacingOccurrencesOfString("%SUPPORTID%", withString: support.guid, options: nil, range: nil);
            insertString = insertString.stringByReplacingOccurrencesOfString("%UNIQUEID%", withString: uniqueId, options: nil, range: nil);
            insertString = insertString.stringByReplacingOccurrencesOfString("%TITLE%", withString: support.title, options: nil, range: nil);
            self.insertText(insertString);
        }
        
        controller.scaffolds = KFService.getInstance().getScaffolds(self.viewId);
        KFPopoverManager.getInstance().openInPopoverFromBarButton(scaffoldButton, controller: controller);
    }
    
    func isDirty()->Bool{
        return true;
    }
    
    func insertText(text:String){
    }
    
    func setText(text:String, title:String){
    }
    
    func getText()->String?{
        return nil;
    }
    
    func getTitle()->String?{
        return nil;
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
