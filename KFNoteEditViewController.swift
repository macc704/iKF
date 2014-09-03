//
//  KFNoteEditViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNoteEditViewController: UIViewController {
    
    var editView:KFAbstractNoteEditView!;
    var note:KFNote?;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(view: KFAbstractNoteEditView){
        super.init();
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
        KFAppUtils.executeInBackThread({
            KFService.getInstance().updateNote(self.note!);
            return;
        });
        self.note!.notify();
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
