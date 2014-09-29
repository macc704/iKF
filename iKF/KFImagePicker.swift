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
    var loc:CGPoint?;
    
    init(mainController:KFCanvasViewController){
        self.mainController = mainController;
    }
    
    func createImagePicker() -> UIImagePickerController{
        let imagePicker = UIImagePickerController();
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imagePicker.delegate = self;
        return imagePicker;
    }
    
    /* UIImagePickerControllerDelegate */
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!){
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage;
        
        let sizeSelectionController = KFImageSizeSelectionViewController(mainController: mainController);
        sizeSelectionController.image = image;
        sizeSelectionController.modalPresentationStyle = UIModalPresentationStyle.FullScreen;
        sizeSelectionController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        if(loc != nil){
            sizeSelectionController.point = loc!;
        }
        KFPopoverManager.getInstance().closeCurrentPopover();
        mainController.presentViewController(sizeSelectionController, animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!){
        KFPopoverManager.getInstance().closeCurrentPopover();
    }
    

    
}
