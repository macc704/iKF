//
//  KFLabelNoteRefView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-01.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFLabelNoteRefView: UIView {

    let model:KFReference;
    var icon: KFPostRefIconView;
    var titleLabel: UILabel;
    var authorLabel: UILabel;
    
    init(ref: KFReference) {
        self.model = ref;
        icon = KFPostRefIconView(frame: CGRectMake(5, 5, 20, 20));
        titleLabel = UILabel(frame: CGRectMake(40, 7, 200, 20));
        authorLabel = UILabel(frame: CGRectMake(50, 23, 120, 10));
        
        super.init(frame: KFAppUtils.DEFAULT_RECT());
        
        //self.backgroundColor = UIColor.whiteColor();
        self.backgroundColor = UIColor.clearColor();
        self.frame = CGRectMake(0, 0, 230, 40);
        
        self.addSubview(icon);
        
        titleLabel.font = UIFont.systemFontOfSize(13);
        self.addSubview(titleLabel);
        
        authorLabel.font = UIFont.systemFontOfSize(10);
        self.addSubview(authorLabel);
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
        
        self.updateFromModel();
        
        //bindEvents();
    }
    
    func updateFromModel(){
        //super.updateFromModel();
        icon.beenRead = (self.model.post as KFNote).beenRead;
        icon.update();
        titleLabel.text = (self.model.post as KFNote).title;
        //titleLabel.backgroundColor = UIColor.blueColor();
        titleLabel.sizeToFit();
        authorLabel.text = (self.model.post as KFNote).primaryAuthor?.getFullName();
        //authorLabel.backgroundColor = UIColor.yellowColor();
        authorLabel.sizeToFit();
        
        //self.sizeToFit(); //does not work
        let titleLeft = 40+titleLabel.frame.size.width+5;
        let authorLeft = 50+authorLabel.frame.size.width+5;
        let newWidth = titleLeft > authorLeft ? titleLeft : authorLeft;
        let r = self.frame;
        self.frame = CGRectMake(0, 0,  newWidth, r.size.height);
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