//
//  KFImageView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-01.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFImageView: UIImageView {
    
    var mainController: KFCanvasViewController?;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(image: UIImage?){
        super.init(image: image);
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        mainController?.suppressScroll();
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        mainController?.unlockSuppressScroll();
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        mainController?.unlockSuppressScroll();
    }
}
