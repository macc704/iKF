//
//  KFView.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

class KFView: KFPost {

    var title = "";
    var published = false;
    
    func description() -> String{
        return title;
    }
    
    override func toString() -> String {
        var text = self.title;
        if(self.published == false){
            text += " (private)";
        }
        return text;
    }
}
