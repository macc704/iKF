//
//  KFAppUtils.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-20.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

private let DEBUG = false;
private var default_rect:CGRect?;

class KFAppUtils: NSObject {
    
    class func debug(msg:String){
        if(DEBUG){
            println(msg);
        }
    }
    
    class func DEFAULT_RECT() -> CGRect{
        if(default_rect == nil){
            default_rect = CGRectMake(0, 0, 100, 100);
        }
        return default_rect!;
    }
    
    class func showAlert(title:String, msg:String){
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("OK");
        alertView.title = title;
        alertView.message = msg;
        alertView.show();
    }
    
    class func topController() -> UIViewController{
        var controller:UIViewController! = UIApplication.sharedApplication().keyWindow.rootViewController!;
        while ((controller.presentedViewController) != nil){
            controller = controller.presentedViewController!;
        }
        return controller;
    }
    
    class func showDialog(title:String, msg:String, okHandler:((UIAlertAction!)->())?){
        var alert:UIAlertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil));
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: okHandler));
        topController().presentViewController(alert, animated: false, completion: nil);
    }
    
    class func executeInGUIThread(execute:()->()){
        dispatch_async(dispatch_get_main_queue()){
            execute();
        }
    }
    
    class func executeInBackThread(execute:()->()){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue){
            execute();
        }
    }
    
    class func asyncExecWithLoadingView(onView:UIView, execute:()->(), onFinish:(()->())?){
        //        let queue = dispatch_queue_create("sub_queue", 0);
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        let loading = KFLoadingView();
        
        dispatch_async(queue){
            dispatch_async(dispatch_get_main_queue()){
                loading.showOnView(onView);
            }
            execute();
            dispatch_async(dispatch_get_main_queue()){
                loading.hide();
                if(onFinish != nil){
                    onFinish!();
                }
            }
        }
    }
}
