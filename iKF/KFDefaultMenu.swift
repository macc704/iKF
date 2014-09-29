//
//  KFDefaultMenu.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFDefaultMenu: NSObject, KFMenu {
    
    var name:String = "default";
    var checked:Bool = false;
    var exec:(()->()) = {};
    
    func getName() -> String {
        return name;
    }
    
    func getAccessoryType() -> UITableViewCellAccessoryType {
        if(checked){
            return UITableViewCellAccessoryType.Checkmark;
        }else{
            return UITableViewCellAccessoryType.None;
        }
    }
    
    func execute() {
        exec();
    }
}
