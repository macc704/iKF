//
//  KFCompositeNoteViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFCompositeNoteViewController: UITabBarController {
    
    var readController:KFNoteReadViewController!;
    var editController:KFNoteEditViewController!;
    var editMode = false;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init();
        
        readController = KFNoteReadViewController(view: KFNoteReadView());
        readController.view.backgroundColor = UIColor.whiteColor();
        readController.readView.closableController = self;
        readController.tabBarItem = UITabBarItem(title:"Read", image:nil, selectedImage:nil);
        
        editController = KFNoteEditViewController(view: KFNoteEditViewByTinyMCE());
        editController.view.backgroundColor = UIColor.whiteColor();
        editController.editView.closableController = self;
        editController.tabBarItem = UITabBarItem(title:"Edit", image:nil, selectedImage:nil);
        
        editMode = false;
    }
    
    func toReadMode(){
        if(readController.note != nil){
            self.selectedViewController = readController;
        }else{
            editMode = false;
        }
    }
    
    func toEditMode(){
        if(editController.note != nil){
            self.selectedViewController = editController;
        }else{
            editMode = true;
        }
    }
    
    func setNote(note:KFNote, viewId:String){
        readController.note = note;
        editController.note = note;
        editController.editView.viewId = viewId;
        
        self.addChildViewController(readController);
        if(note.canEditMe() == true){
            self.addChildViewController(editController);
        }
        
        if(editMode == true){
            self.toEditMode();
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
