//
//  KFCommunity.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-31.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFCommunity: KFModel {
   
    
    var name = "";
    
    var views = KFModelArray<KFView>();
    var members = KFModelArray<KFUser>();

    func getView(guid:String) -> KFView?{
        return views.dic[guid];
    }
    
    func getMember(guid:String) -> KFUser?{
        return members.dic[guid];
    }
    
}
