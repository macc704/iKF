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
        self.navigationItem.title = "Welcome to " + host;
        self.usernameLabel.text = KFService.getInstance().currentUser.getFullName();
        self.refreshRegistrations();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated);
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: animated);
    }
    
    /* data source */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return registrations.count;
    }
    
    /* delegate */
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        let registration:KFRegistration = self.registrations[row];
        return registration.community.name + " ( as " + registration.roleName + " )";
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
    }
    
   
    @IBAction func enterButtonPressed(sender : AnyObject) {
        if(self.registrations.count <= 0){
            KFAppUtils.showAlert("Error", msg: "No registration selected.");
            return;
        }
        
        let canvasViewController = KFCanvasViewController();
        let row = self.registrationsPicker.selectedRowInComponent(0);
        canvasViewController.setKFRegistration(self.registrations[row]);
        self.presentViewController(canvasViewController, animated: true, completion: nil);
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

    
}
