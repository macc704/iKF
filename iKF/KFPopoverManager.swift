//
//  KFPopoverManager.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

private var popoverInstance = KFPopoverManager();

class KFPopoverManager: NSObject {
    
    class func getInstance() -> KFPopoverManager{
        return popoverInstance;
    }
    
    private var popoverController:UIPopoverController?;
    
    private override init(){
    }
    
    func openInPopover(locView:UIView, controller:UIViewController) -> UIPopoverController{
        //self.popoverController?.dismissPopoverAnimated(false); //this causes problem not necessary
        self.popoverController = UIPopoverController(contentViewController: controller);
        //        self.popoverController!.popoverContentSize = controller.view.frame.size;
        //deprecated use preferredsize instead
        self.popoverController!.presentPopoverFromRect(locView.frame, inView: locView.superview!, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true);
        return self.popoverController!;
    }
    
    func closeCurrentPopover(animated:Bool = true){
        if(self.popoverController != nil){
            self.popoverController!.dismissPopoverAnimated(animated)
            self.popoverController = nil;
        }
    }
    
}
