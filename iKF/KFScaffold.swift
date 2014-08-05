//
//  KFScaffold.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-10.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFScaffold: KFModel {

    var title = "";
    var supports = Array<KFSupport>();
    
    override init(){
    }
    
    func addSupport(support:KFSupport){
        supports.append(support);
    }
    
}
