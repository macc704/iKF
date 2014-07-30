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
    
    class func asyncExecWithLoadingView(onView:UIView, execute:()->(), onFinish:(()->())?){
        //        let queue = dispatch_queue_create("sub_queue", 0);
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        let loading = iKFLoadingView();
        
        dispatch_async(queue){
            dispatch_async(dispatch_get_main_queue()){
                loading.showOnView(onView);
            }
            execute();
            dispatch_async(dispatch_get_main_queue()){
                loading.hide();
                if(onFinish){
                    onFinish!();
                }
            }
        }
    }
}
