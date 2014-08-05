//
//  KFLoginViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-05.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFLoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate {
    
    var servers = ["132.203.154.41:8080", "rooibos.cs.inf.shizuoka.ac.jp", "128.100.72.137:8080", "localhost:8080", "192.168.43.97:8080", "138.51.181.244:8080", "no server"];
    
    @IBOutlet var passwordField : UITextField!
    @IBOutlet var usernameField : UITextField!
    @IBOutlet var serverPicker : UIPickerView!
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        serverPicker.dataSource = self;
        serverPicker.delegate = self;
        
        self.usernameField.text = "ikit";
        self.passwordField.text = "pass";
        self.passwordField.secureTextEntry = true;
    }
    
    override func viewDidAppear(animated: Bool) {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50));
        button.backgroundColor = UIColor.clearColor();
        let r = UITapGestureRecognizer(target: self, action: "testPressed:");
        button.addGestureRecognizer(r);
        self.view.addSubview(button);
    }
    
    func testPressed(r:UITapGestureRecognizer){
        let c = KFTestViewController(nibName: "KFTestViewController", bundle: nil);
        self.presentViewController(c, animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonPressed(sender : AnyObject) {
        //        let queue = dispatch_queue_create("sub_queue", 0);
        var res:(result: Bool, errorMsg: String?)?;
        
        func execute(){
            res = self.login();
        }
        
        func onFinish(){
            if(res!.result == true){
                let registrationViewController = KFRegistrationViewController(nibName: "KFRegistrationViewController", bundle: nil);
                self.presentViewController(registrationViewController, animated: true, completion: nil);
            }else{
                KFAppUtils.showAlert("ConnectionError", msg: res!.errorMsg!);
            }
        }
        
        KFAppUtils.asyncExecWithLoadingView(self.view, execute: execute, onFinish: onFinish);
    }
    
    func login() -> (result: Bool, errorMsg: String?) {        
        var service = KFService.getInstance();
        service.initialize(servers[serverPicker.selectedRowInComponent(0)]);
        
        let hostTest = service.testConnectionToTheHost();
        if(hostTest == false){
            let googleTest = service.testConnectionToGoogle();
            if(googleTest == false){
                return (false, "Internet Connection Failed");
            }else{
                return (false, "Connection Failed to the Selected Host");
            }
        }
        let loginResult = service.login(self.usernameField.text, password:self.passwordField.text);
        if(loginResult == false){
            return (false, "Login Failed");
        }
        let userResult = service.refreshCurrentUser();
        if(userResult == false){
            return (false, "getUser() Failed");
        }
        return (true, nil);
    }
    
    //    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
    //    }
    
    /* data source */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return servers.count;
    }
    
    /* delegate */
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!{
        return servers[row];
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
    }
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}


