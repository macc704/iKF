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
        super.init(nibName: nil, bundle: nil);
        self.readView = view;
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
            self.readView.model = self.note!;
            self.readView.load();
            KFAppUtils.executeInBackThread({
                KFService.getInstance().readPost(self.note!);
                return;
            });
        }
    }
    
}
