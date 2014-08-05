//
//  KFViewEditViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-03.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFViewEditViewController: UIViewController {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    
    var viewIdToLink:String?;
    var loc:CGPoint?;
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init(nibName: "KFViewEditViewController", bundle: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.enabled = false;
        self.preferredContentSize = self.view.frame.size;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okPressed(sender: AnyObject) {
        let text = nameTextfield.text;
        KFService.getInstance().createView(text, viewIdToLink: viewIdToLink, location: loc);
        KFPopoverManager.getInstance().closeCurrentPopover();
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        KFPopoverManager.getInstance().closeCurrentPopover();
    }
    
    @IBAction func nameTFChanged(sender: AnyObject) {
        let text = nameTextfield.text;
        okButton.enabled = !text.isEmpty;
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
