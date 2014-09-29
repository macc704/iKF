//
//  KFNoteEditViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNoteEditViewController: UIViewController {
    
    var editView:KFNoteEditViewByTinyMCE!;
    var note:KFNote?;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(view: KFNoteEditViewByTinyMCE){
        super.init(nibName: nil, bundle: nil);
        self.editView = view;
    }
    
    override func loadView() {
        super.loadView();
        self.view = self.editView;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        if(note != nil){
            self.editView.setText(note!.content, title: note!.title);
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        if(note != nil && editView.isDirty()){
            self.updateToModel();
        }
    }
    
    private func updateToModel(){
        self.note!.title = editView.getTitle()!;
        self.note!.content = editView.getText()!;
        self.note!.updateToServer();
        self.note!.notify();
    }
    
}
