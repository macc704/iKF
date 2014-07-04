//
//  KFLoginViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-05.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFLoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate {
    
    var servers = ["132.203.154.41:8080", "128.100.72.137:8080", "localhost:8080", "192.168.43.97:8080", "138.51.179.228:8080", "no server"];
    
    @IBOutlet var passwordField : UITextField
    @IBOutlet var usernameField : UITextField
    @IBOutlet var serverPicker : UIPickerView
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonPressed(sender : AnyObject) {
//        let queue = dispatch_queue_create("sub_queue", 0);
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        let loading = iKFLoadingView();

        dispatch_async(queue){
            dispatch_async(dispatch_get_main_queue()){
                loading.show(self);
            }
            let res = self.login();
            dispatch_async(dispatch_get_main_queue()){
                loading.hide();
                if(res.result == true){
                    let registrationViewController = KFRegistrationViewController(nibName: nil, bundle: nil);
                    self.presentViewController(registrationViewController, animated: true, completion: nil);
                }else{
                    KFAppUtils.showAlert("ConnectionError", msg: res.errorMsg!);
                }
            }
        }
    }
    
    func login() -> (result: Bool, errorMsg: String?) {
        var connector = iKFConnector.getInstance();
        connector.host = servers[serverPicker.selectedRowInComponent(0)];
        let googleTest = connector.testConnectionToGoogle();
        if(googleTest == false){
            return (false, "Internet Connection Failed");
        }
        let hostTest = connector.testConnectionToTheHost();
        if(hostTest == false){
            return (false, "Connection Failed to the Selected Host");
        }
        let loginResult = connector.loginWithName(self.usernameField.text, password:self.passwordField.text);
        if(loginResult == false){
            return (false, "Login Failed");
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


