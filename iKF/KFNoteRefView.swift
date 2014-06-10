//
//  KFNoteRefView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFNoteRefView: KFPostRefView {

    var icon: KFPostRefIconView?;
    var titleLabel: UILabel;
    var authorLabel: UILabel;
    
    init(controller: iKFMainViewController, ref: KFReference) {
        titleLabel = UILabel(frame: CGRectMake(30, 5, 200, 20));
        authorLabel = UILabel(frame: CGRectMake(50, 25, 120, 10));
        
        super.init(controller: controller, ref: ref);
        
        self.backgroundColor = UIColor.whiteColor();
        self.frame = CGRectMake(ref.location.x, ref.location.y, 230, 40);
        
        icon = KFPostRefIconView(frame: CGRectMake(5, 5, 20, 20));
        self.addSubview(icon);
        
        titleLabel.font = UIFont.systemFontOfSize(12);
        self.addSubview(titleLabel);
        
        authorLabel.font = UIFont.systemFontOfSize(10);
        self.addSubview(authorLabel);
        
        model.attach(self, selector: "noteChanged");
        self.update();
        
        bindEvents();
    }

    func noteChanged(){
        self.update();
    }
    
    func update(){
        titleLabel.text = (self.model.post as KFNote).title;
        authorLabel.text = (self.model.post as KFNote).primaryAuthor?.getFullName();
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