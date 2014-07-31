//
//  KFConnectionViewModel.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-31.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFConnectionViewModel: NSObject {
    
    let from:KFPostRefView;
    let to:KFPostRefView;

    init(from:KFPostRefView, to:KFPostRefView){
        self.from = from;
        self.to = to;
    }
    
}
