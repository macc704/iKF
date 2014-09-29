//
//  KFLoginViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-05.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFLoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate {
    
    var servers = ["kf.utoronto.ca:8080", "rooibos.cs.inf.shizuoka.ac.jp", "132.203.154.41:8080", "kforum.glm.edu.co:8080", "localhost:8080", "(input textfield)"];
    
    @IBOutlet var passwordField : UITextField!
    @IBOutlet var usernameField : UITextField!
    @IBOutlet var serverPicker : UIPickerView!
    @IBOutlet weak var serverNameField: UITextField!
    
    @IBOutlet weak var labelVersion: UILabel!
    @IBOutlet weak var labelBuild: UILabel!
    @IBOutlet weak var labelBuildDate: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let version = NSBundle.mainBundle().infoDictionary["CFBundleShortVersionString"]! as String;
        labelVersion.text = version;
        let build = NSBundle.mainBundle().infoDictionary["CFBundleVersion"]! as String;
        labelBuild.text = build;
        let date = iKFUtil.getBuildDate() + " " + iKFUtil.getBuildTime();
        labelBuildDate.text = date;
        
        serverPicker.dataSource = self;
        serverPicker.delegate = self;
        
        let userDefaults = NSUserDefaults.standardUserDefaults();
        let username = userDefaults.stringForKey("username");
        let password = userDefaults.stringForKey("password");
        self.usernameField.text = username;
        self.passwordField.text = password;
        self.passwordField.secureTextEntry = true;
        
        self.serverNameField.enabled = false;
    }
    
    override func viewDidAppear(animated: Bool) {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50));
        button.backgroundColor = UIColor.clearColor();
        let r = UITapGestureRecognizer(target: self, action: "testPressed:");
        button.addGestureRecognizer(r);
        self.view.addSubview(button);
        
        let userDefaults = NSUserDefaults.standardUserDefaults();
        let host = userDefaults.stringForKey("hostname");
        if(host != nil){
            setHost(host!);
        }
    }
    
    func testPressed(r:UITapGestureRecognizer){
        let c = KFTestViewController(nibName: "KFTestViewController", bundle: nil);
        self.presentViewController(c, animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func newAccountButtonPressed(sender: AnyObject) {
        let c = KFAccountCreationViewController(nibName: "KFAccountCreationViewController", bundle: nil);
        c.host = getHost();
        self.navigationController!.pushViewController(c, animated: true);
    }
    
    @IBAction func loginButtonPressed(sender : AnyObject) {
        var res:(result: Bool, errorMsg: String?)?;
        
        KFAppUtils.asyncExecWithLoadingView(self.view, execute: {
            res = self.login();
            }, onFinish: {
                if(res!.result == true){
                    let c = KFRegistrationViewController(nibName: "KFRegistrationViewController", bundle: nil);
                    c.host = self.getHost();
                    self.navigationController!.pushViewController(c, animated: true);
                }else{
                    KFAppUtils.showAlert("ConnectionError", msg: res!.errorMsg!);
                }
        });
    }
    
    private func getHost() -> String{
        let host = servers[serverPicker.selectedRowInComponent(0)];
        if(host == "(input textfield)"){
            return serverNameField.text;
        }
        return servers[serverPicker.selectedRowInComponent(0)];
    }
    
    private func setHost(host:String){
        let len = servers.count;
        for(var i=0;i<len;i++){
            if(servers[i] == host){
                serverPicker.selectRow(i, inComponent: 0, animated: false);
                return;
            }
        }
        serverPicker.selectRow(len-1, inComponent: 0, animated: false);
        serverNameField.text = host;
    }
    
    func login() -> (result: Bool, errorMsg: String?) {
        var service = KFService.getInstance();
        let host = getHost();
        service.initialize(host);
        
        let hostTest = service.testConnectionToTheHost();
        if(hostTest == false){
            let googleTest = service.testConnectionToGoogle();
            if(googleTest == false){
                return (false, "Internet Connection Failed");
            }else{
                return (false, "Connection Failed to the Selected Host");
            }
        }
        let username = self.usernameField.text;
        let password = self.passwordField.text;
        let loginResult = service.login(username, password:password);
        if(loginResult == false){
            return (false, "Login Failed");
        }
        let userResult = service.refreshCurrentUser();
        if(userResult == false){
            return (false, "getUser() Failed");
        }
        let userDefaults = NSUserDefaults.standardUserDefaults();
        userDefaults.setValue(username, forKey: "username");
        userDefaults.setValue(password, forKey: "password");
        userDefaults.setValue(host, forKey: "hostname");
        userDefaults.synchronize();
        return (true, nil);
    }
    
    /* data source */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return servers.count;
    }
    
    /* delegate */
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return servers[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let host = servers[serverPicker.selectedRowInComponent(0)];
        if(host == "(input textfield)"){
            serverNameField.enabled = true;
        }else{
            serverNameField.enabled = false;
        }
    }
    
    
}


