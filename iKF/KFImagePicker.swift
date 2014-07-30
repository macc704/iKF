//
//  KFImagePicker.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-29.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFImagePicker: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let mainController:iKFMainViewController;
    var popController:UIPopoverController?;
    var viewId:String?
    
    init(mainController:iKFMainViewController){
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
        KFService.getInstance().createPicture(image, viewId: self.viewId!, location: CGPoint(x:50, y:50));
        popController?.dismissPopoverAnimated(true);
        self.mainController.update();
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!){
        popController?.dismissPopoverAnimated(true);
    }
    
    func scaleImage(original:UIImage, newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContext(newSize);
        original.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
}
