//
//  KFPostRefIconView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFPostRefIconView: UIView {
    
    var beenRead = false;
    let icon:UIImageView!;
    let iconx:UIImageView!;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        icon = UIImageView(image: UIImage(named: "note.png"));
        icon.frame = frame;
        iconx = UIImageView(image: UIImage(named: "notex.png"));
        iconx.frame = frame;
        super.init(frame: frame);
        update();
    }
    
    func update(){
        icon.removeFromSuperview();
        iconx.removeFromSuperview();
        if(beenRead){
            self.addSubview(icon);
        }else{
            self.addSubview(iconx);
        }
    }
}
