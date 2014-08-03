//
//  KFTestViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-31.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFTestViewController: UIViewController {
    
    @IBAction func aPressed(sender: AnyObject) {
        a();
    }
    
    func a(){
        println("button pressed");
        let webbrowser = KFWebBrowserView();
        let rect2:CGRect = CGRect(x: 300, y: 300, width: 200, height: 200);
        webbrowser.frame = rect2;
        webbrowser.setURL("http://www.google.com");
        self.view.addSubview(webbrowser);
        webbrowser.doubleTapHandler = {
            self.showHalo(webbrowser);
        }
    }
    
    var halo:KFHalo?;
    
    //var web = KFWebView();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: "hideHalo:");
        self.view.addGestureRecognizer(tap);
        
        //a();
    }
    
    @IBAction func backClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    func doNothing(gesture:UITapGestureRecognizer){
    }
    
    func showHalo(target:UIView){
        if(halo){
            hideHalo(nil);
        }
        halo = KFHalo(controller: nil, target: target);
//        self.view.addSubview(halo);
        halo!.showWithAnimation(self.view);
    }
    
    func hideHalo(gesture:UITapGestureRecognizer?){
        if(halo){
            halo?.removeFromSuperview();
            self.halo = nil;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
