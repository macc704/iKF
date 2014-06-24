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
        
        var connector = iKFConnector.getInstance();
        connector.host = servers[serverPicker.selectedRowInComponent(0)];
        let googleTest = connector.testConnectionToGoogle();
        if(googleTest == false){
            KFAppUtils.showAlert("Connection Error", msg: "Internet Connection Failed");
            return;
        }
        
        let hostTest = connector.testConnectionToTheHost();
        if(hostTest == false){
            KFAppUtils.showAlert("Connection Error", msg: "Connection Failed to the Selected Host");
            return;
        }
        
        let loginResult = connector.loginWithName(self.usernameField.text, password:self.passwordField.text);
        if(loginResult == false){
            KFAppUtils.showAlert("Login Error", msg: "Login Failed");
            return;
        }
        let registrationViewController = KFRegistrationViewController(nibName: nil, bundle: nil);
        self.presentViewController(registrationViewController, animated: true, completion: nil);
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


