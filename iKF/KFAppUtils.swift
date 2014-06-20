//
//  KFAppUtils.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-20.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFAppUtils: NSObject {
    class func showAlert(title:String, msg:String){
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("OK");
        alertView.title = title;
        alertView.message = msg;
        alertView.show();
    }
}
