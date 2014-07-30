//
//  KFImageSizeSelectionViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-30.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFImageSizeSelectionViewController: UIViewController {
    
    private let mainController:iKFMainViewController;
    
    //    private var image:UIImage?{
    //    get{
    //        return self.image;
    //    }
    //    set{
    //        self.image = newValue;
    //        imageView.image = self.image;
    //    }
    //    }
    
    var image:UIImage?{
    didSet{
        if(imageView){
            imageView.image = self.image;
        }
    }
    }
    
    var point = CGPoint(x:50, y:50);
    
    @IBOutlet weak var labelSize: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    //@IBOutlet weak var sizelabel: UILabel!
    
    //private var handler: ((CGFloat) -> ())?
    
    init(mainController:iKFMainViewController){
        self.mainController = mainController;
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //layout has not finished
    }
    
    override func viewWillAppear(animated: Bool) {
        //layout has not finished
    }
    
    override func viewDidAppear(animated: Bool) {
        //layout has finished
        if(imageView){
            let width = self.image!.size.width;
            let height = self.image!.size.height;
            labelSize.text = "\(width) x \(height)";
            let center = imageView.center;
            let viewHeight = imageView.frame.size.height;
            let viewWidth = viewHeight * (width/height);
            imageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight);
            imageView.center = center;
            imageView.image = self.image;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func setButtonPressHandler(handler: (CGFloat) -> () ){
    //        self.handler = handler;
    //    }
    
    @IBAction func button1Pressed(sender: AnyObject) {
        upload(1.0);
    }
    
    @IBAction func button2Pressed(sender: AnyObject) {
        upload(0.5);
    }
    
    @IBAction func button3Pressed(sender: AnyObject) {
        upload(0.25);
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    private func upload(scale:CGFloat){
        //self.handler?(1.0);
        
        func execute(){
            let width = self.image!.size.width;
            let height = self.image!.size.height;
            let scaledImage = scaleImage(self.image!, newSize: CGSize(width: width * scale, height: height * scale));
            KFService.getInstance().createPicture(scaledImage, viewId: self.mainController.getCurrentView().guid, location: self.point);
        }
        
        func onFinish(){
            self.mainController.update();
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
