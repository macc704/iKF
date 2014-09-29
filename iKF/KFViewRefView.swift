//
//  KFViewRefView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFViewRefView: KFPostRefView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(controller: KFCanvasViewController, ref: KFReference) {
        super.init(controller: controller, ref: ref);

        self.frame = CGRectMake(ref.location.x, ref.location.y, 230, 30);
        self.backgroundColor = UIColor.clearColor();
        
        //icon
        var icon:UIImageView;
        if((ref.post as KFView).published == true){
            icon = UIImageView(image: UIImage(named: "viewlink.png"));
        }else{
            icon = UIImageView(image: UIImage(named: "lockedviewlink.png"));
        }
        icon.frame = CGRectMake(5, 5, 20, 20);
        self.addSubview(icon);
        
        //label
        let titleLabel = UILabel(frame: CGRectMake(35, 5, 200, 20));
        titleLabel.font = UIFont.systemFontOfSize(12);
        let view = ref.post as KFView;
        titleLabel.text = view.title;
        self.addSubview(titleLabel);
        titleLabel.sizeToFit();
        
        let titleRight = 40+titleLabel.frame.size.width;
        self.frame = CGRectMake(ref.location.x, ref.location.y, titleRight, 30);
    }

    
    override func tapA() {
        self.mainController.setCurrentView(self.getModel().post as KFView);
    }


}
