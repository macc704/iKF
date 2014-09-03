//
//  KFNoteReadViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNoteReadViewController: UIViewController {
    
    var readView:KFNoteReadView!;
    var note:KFNote?;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(view: KFNoteReadView){
        self.readView = view;
        super.init();
    }
    
    override func loadView() {
        super.loadView();
        self.view = self.readView;
    }
    
    //- (void)viewWillAppear:(BOOL)animated 反映されない
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        if(self.note != nil){
            self.readView._webView.kfModel = self.note!;
            self.note!.beenRead = true;
            self.note!.notify();
            self.readView.showHTML(self.note!.content, title:self.note!.title);
            KFAppUtils.executeInBackThread({
                KFService.getInstance().readPost(self.note!);
                return;
            });
        }
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
