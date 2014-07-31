//
//  KFRegistrationViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFRegistrationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var registrations:Array<KFRegistration> = [];
    
    @IBOutlet var registrationCodeField : UITextField!
    @IBOutlet var registrationsPicker : UIPickerView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registrationsPicker.dataSource = self;
        self.registrationsPicker.delegate = self;
        self.navBar.topItem.title = "Hello, " + KFService.getInstance().getCurrentUser().getFullName();
        self.refreshRegistrations();
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
        self.dismissViewControllerAnimated(false, completion: nil);
    }

    @IBAction func enterButtonPressed(sender : AnyObject) {
        let canvasViewController = KFCanvasViewController();
        self.presentViewController(canvasViewController, animated: true, completion: nil);

        let row = self.registrationsPicker.selectedRowInComponent(0);
        canvasViewController.go(self.registrations[row]);
    }
    
    @IBAction func regsiterButtonPressed(sender : AnyObject) {
        let service = KFService.getInstance();
        service.registerCommunity(registrationCodeField.text);
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
