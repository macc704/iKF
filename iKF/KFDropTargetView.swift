//
//  KFDropTargetView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-26.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFDropTargetView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    
    private var orgBorderColor:CGColor?;
    private var orgBorderWidth:CGFloat?;
    private let dBorderColor:CGColor = UIColor.redColor().CGColor;
    private let dBorderWidth:CGFloat = 5;
    
    func candrop(view:UIView) -> Bool{
        return false;
    }
    
    func dropped(view:UIView){
    }
    
    func enterDroppable(view:UIView) {
        self.orgBorderColor = self.layer.borderColor;
        self.orgBorderWidth = self.layer.borderWidth;
        self.layer.borderColor = self.dBorderColor;
        self.layer.borderWidth = self.dBorderWidth;
    }
    
    func leaveDroppable(view:UIView) {
        self.layer.borderColor = self.orgBorderColor;
        self.layer.borderWidth = self.orgBorderWidth!;
    }

}
