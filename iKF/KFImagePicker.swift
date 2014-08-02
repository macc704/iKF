//
//  KFImagePicker.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-29.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFImagePicker: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private let mainController:KFCanvasViewController;
    private var popController:UIPopoverController?;
    private var viewId:String?
    
    init(mainController:KFCanvasViewController){
        self.mainController = mainController;
    }
    
    func openImagePicker(fromButton:UIBarButtonItem, viewId:String){
        self.viewId = viewId;
        let imagePicker = UIImagePickerController();
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imagePicker.delegate = self;
        popController = UIPopoverController(contentViewController: imagePicker);
        popController?.presentPopoverFromBarButtonItem(fromButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true);
    }
    
    
    /* UIImagePickerControllerDelegate */
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!){
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage;
        
        let sizeSelectionController = KFImageSizeSelectionViewController(mainController: mainController);
        sizeSelectionController.image = image;
        sizeSelectionController.modalPresentationStyle = UIModalPresentationStyle.FullScreen;
        sizeSelectionController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        //        func callback(scale:CGFloat){
        //            KFService.getInstance().createPicture(image, viewId: self.viewId!, location: CGPoint(x:50, y:50));
        //            self.mainController.update();
        //        }
        //        sizeSelectionController.setButtonPressHandler(callback);        
        popController?.dismissPopoverAnimated(true);
        mainController.presentViewController(sizeSelectionController, animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!){
        popController?.dismissPopoverAnimated(true);
    }
    

    
}