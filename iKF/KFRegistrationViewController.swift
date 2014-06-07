//
//  KFRegistrationViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFRegistrationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let connector = iKFConnector.getInstance();
    var registrations:Array<KFRegistration> = [];
    
    @IBOutlet var registrationCodeField : UITextField
    @IBOutlet var registrationsPicker : UIPickerView
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registrationsPicker.dataSource = self;
        self.registrationsPicker.delegate = self;
        self.refresh();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return registration.communityName + " ( as " + registration.roleName + " )";
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
    }
    
    @IBAction func backButtonPressed(sender : AnyObject) {
        self.dismissModalViewControllerAnimated(true);
    }

    @IBAction func enterButtonPressed(sender : AnyObject) {
        let row = self.registrationsPicker.selectedRowInComponent(0);
        let registrationId = registrations[row].guid;
        let enterResult = connector.enterCommunity(registrationId);
        if(enterResult == false){
            //alert
            return;
        }
        
        let mainViewController = iKFMainViewController(nibName: nil, bundle: nil);
        mainViewController.user = connector.getCurrentUser();
        self.presentViewController(mainViewController, animated: true, completion: nil);
        let communityId = self.registrations[row].communityId;
        mainViewController.initServer(connector, communityId:communityId);
    }
    
    @IBAction func regsiterButtonPressed(sender : AnyObject) {
        connector.registerCommunity(registrationCodeField.text);
        self.refresh();
    }
    
    func refresh(){
        self.registrations = connector.getRegistrations() as Array<KFRegistration>;
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
