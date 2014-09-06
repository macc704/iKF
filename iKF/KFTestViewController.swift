//
//  KFTestViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-31.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFTestViewController: UIViewController {
    
    var halo:KFHalo?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: "hideHalo");
        self.view.addGestureRecognizer(tap);
    }
    
    @IBAction func backClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        comet?.stop();
        comet = nil;
    }
    
    @IBAction func aPressed(sender: AnyObject) {
        a();
    }
    
    var comet:KFMobileCometManager?;
    
    func a(){
        println("button pressed");
        let webbrowser = KFWebBrowserView();
        let rect2:CGRect = CGRect(x: 300, y: 300, width: 200, height: 200);
        webbrowser.frame = rect2;
        webbrowser.setURL("http://www.google.com");
//        let req = KFHttpRequest(urlString: "http://localhost:8080/kforum/rest/account/userLogin", method: "POST");
//        req.addParam("userName", value: "ikit");
//        req.addParam("password", value: "pass");
//        req.updateParams();
//        webbrowser.setRequest(req.nsRequest);
        if(comet == nil){
            comet = KFMobileCometManager(host: "localhost:8080", username: "ikit", password: "pass");
            comet!.busInitialized = {
                self.comet!.subscribeViewEvent("31b8bac8-0eda-4695-87f3-51de32c931de");
            }
            comet!.messageReceived = {(type:String?, method:String?, target:String?) in
                println("messageReceived: \(type), \(method), \(target)");
            };
            comet!.start();
        }
        self.view.addSubview(webbrowser);
        webbrowser.doubleTapHandler = {
            self.showHalo(webbrowser);
        }
    }
    
  
    func doNothing(gesture:UITapGestureRecognizer){
    }
    
    func showHalo(target:UIView){
        if(halo != nil){
            hideHalo();
        }
        halo = KFHalo(controller: nil, target: target);
        halo!.showWithAnimation(self.view);
    }
    
    func hideHalo(){
        if(halo != nil){
            halo!.removeFromSuperview();
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
