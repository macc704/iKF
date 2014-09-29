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
    @IBOutlet weak var accessToggle: UISegmentedControl!
    
    var viewIdToLink:String?;
    var loc:CGPoint?;
    
    required init(coder aDecoder: NSCoder) {
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
    
    @IBAction func okPressed(sender: AnyObject) {
        let text = nameTextfield.text;
        let isPrivate = accessToggle.selectedSegmentIndex == 1;
        //0 means public
        KFService.getInstance().createView(text, viewIdToLink: viewIdToLink, location: loc, isPrivate: isPrivate);
        KFPopoverManager.getInstance().closeCurrentPopover();
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        KFPopoverManager.getInstance().closeCurrentPopover();
    }
    
    @IBAction func nameTFChanged(sender: AnyObject) {
        let text = nameTextfield.text;
        okButton.enabled = !text.isEmpty;
    }

}
