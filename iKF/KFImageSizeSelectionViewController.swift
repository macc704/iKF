//
//  KFImageSizeSelectionViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-30.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFImageSizeSelectionViewController: UIViewController {
    
    private let mainController:KFCanvasViewController!;
    
    var image:UIImage?{
    didSet{
        updateImageInfo();
    }
    }
    
    var point = CGPoint(x:50, y:50);
    
    @IBOutlet weak var labelSize: UILabel!
    @IBOutlet weak var imageContainer: UIView!
    private let imageView = UIImageView();
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button33: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(mainController:KFCanvasViewController){
        self.mainController = mainController;
        super.init(nibName: "KFImageSizeSelectionViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageContainer.addSubview(imageView);
        updateImageInfo();
    }
    
    private func updateImageInfo(){
        if(imageContainer != nil){
            let imgWidth = self.image!.size.width;
            let imgHeight = self.image!.size.height;
            labelSize.text = "\(imgWidth) x \(imgHeight)";
            if(imgWidth < imgHeight * 1.5){//portrait
                let viewHeight:CGFloat = imageContainer.frame.size.height;
                let viewWidth:CGFloat = viewHeight * (imgWidth/imgHeight);
                let y:CGFloat = 0.0;
                let x:CGFloat = (imageContainer.frame.size.width - viewWidth) / 2.0;
                imageView.frame = CGRect(x: x, y: y, width: viewWidth, height: viewHeight);
            }else{//landscape
                let viewWidth:CGFloat = imageContainer.frame.size.width;
                let viewHeight:CGFloat = viewWidth * (imgHeight/imgWidth);
                let x:CGFloat = 0.0;
                let y:CGFloat = (imageContainer.frame.size.height - viewHeight) / 2.0;
                imageView.frame = CGRect(x: x, y: y, width: viewWidth, height: viewHeight);
            }
            imageView.image = self.image;
            imageContainer.addSubview(imageView);
        }
    }
    
    @IBAction func button1Pressed(sender: AnyObject) {
        upload(1.0);
    }
    
    @IBAction func button2Pressed(sender: AnyObject) {
        upload(0.5);
    }
    
    @IBAction func button3Pressed(sender: AnyObject) {
        upload(0.25);
    }
    
    @IBAction func button33Pressed(sender: AnyObject) {
        upload(0.33);
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    private func upload(scale:CGFloat){       
        func execute(){
            let width = self.image!.size.width;
            let height = self.image!.size.height;
            let scaledImage = scaleImage(self.image!, newSize: CGSize(width: width * scale, height: height * scale));
            KFService.getInstance().createPicture(scaledImage, viewId: self.mainController.getCurrentView().guid, location: self.point);
        }
        
        func onFinish(){
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        
        KFAppUtils.asyncExecWithLoadingView(self.view, execute: execute, onFinish: onFinish);
    }
    
    private func scaleImage(original:UIImage, newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContext(newSize);
        original.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }

    
}
