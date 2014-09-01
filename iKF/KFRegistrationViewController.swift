//
//  KFRegistrationViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFRegistrationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var host:String!;
    var registrations:Array<KFRegistration> = [];
    
    @IBOutlet var registrationCodeField : UITextField!
    @IBOutlet var registrationsPicker : UIPickerView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registrationsPicker.dataSource = self;
        self.registrationsPicker.delegate = self;
        //        self.navBar.topItem.title = "Hello, " + KFService.getInstance().getCurrentUser().getFullName();
        self.navigationItem.title = "Welcome to " + host;
        self.usernameLabel.text = KFService.getInstance().currentUser.getFullName();
        self.refreshRegistrations();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController.setNavigationBarHidden(false, animated: animated);
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController.setNavigationBarHidden(true, animated: animated);
    }
    
    /* data source */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return registrations.count;
    }
    
    /* delegate */
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!{
        let registration:KFRegistration = self.registrations[row];
        return registration.community.name + " ( as " + registration.roleName + " )";
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
    }
    
    //    @IBAction func backButtonPressed(sender : AnyObject) {
    ////        self.dismissViewControllerAnimated(false, completion: nil);
    //        self.navigationController.popViewControllerAnimated(true);
    //
    //    }
    
    @IBAction func enterButtonPressed(sender : AnyObject) {
        if(self.registrations.count <= 0){
            KFAppUtils.showAlert("Error", msg: "No registration selected.");
            return;
        }
        
        let canvasViewController = KFCanvasViewController();
        self.presentViewController(canvasViewController, animated: true, completion: nil);
        
        let row = self.registrationsPicker.selectedRowInComponent(0);
        canvasViewController.go(self.registrations[row]);
    }
    
    @IBAction func regsiterButtonPressed(sender : AnyObject) {
        let service = KFService.getInstance();
        let res = service.registerCommunity(registrationCodeField.text);
        if(res == false){
            KFAppUtils.showAlert("Error", msg: "Registration failed.");
        }
        self.refreshRegistrations();
    }
    
    private func refreshRegistrations(){
        let service = KFService.getInstance();
        self.registrations = service.getRegistrations();
        self.registrationsPicker.reloadAllComponents();
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
