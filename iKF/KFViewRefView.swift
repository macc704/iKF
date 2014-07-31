//
//  KFViewRefView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFViewRefView: KFPostRefView {
    
    init(controller: KFCanvasViewController, ref: KFReference) {
        super.init(controller: controller, ref: ref);

        self.frame = CGRectMake(ref.location.x, ref.location.y, 230, 40);
        //self.backgroundColor = UIColor.blueColor();
        self.backgroundColor = UIColor.clearColor();
        
        //icon
        let icon = UIImageView(image: UIImage(named: "viewlink.png"));
        icon.frame = CGRectMake(5, 5, 20, 20);
        self.addSubview(icon);
        
        //label
        let titleLabel = UILabel(frame: CGRectMake(35, 5, 200, 20));
        titleLabel.font = UIFont.systemFontOfSize(12);
        let view = ref.post as KFView;
        titleLabel.text = view.title;
        self.addSubview(titleLabel);
        
        bindEvents();
    }
    
    override func handleSingleTap(recognizer: UIGestureRecognizer){
        self.mainController.setCurrentView(self.model.post as KFView);
    }
    
    override func handleDoubleTap(recognizer: UIGestureRecognizer){
        mainController.showHalo(self);
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
