//
//  KFPost.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFPost: KFModel {

    var authors:[KFUser]=[];
    var primaryAuthor:KFUser?;
    var canEdit = false;
    var beenRead = false;
    
    func canEdit(user:KFUser)->Bool{
        println(authors);
        println(user);
        return contains(authors, user);
    }
    
}
