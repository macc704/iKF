//
//  KFDrawing.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFDrawing: KFPost {
    
    var content = "";
    
    override func toString() -> String {
        var text = "(a drawing)";
        if(self.primaryAuthor != nil){
            text = text + " by " + self.primaryAuthor.firstName;
        }
        if(self.modified != nil){
            text = text + " at " + self.modified;
        }
        return text;
    }
    
}
