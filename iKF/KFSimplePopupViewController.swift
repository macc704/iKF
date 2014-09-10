//
//  KFSimplePopupViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-10.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFSimplePopupViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    var message:String = "";
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init(nibName: "KFSimplePopupViewController", bundle: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageLabel.text = message;
        messageLabel.sizeToFit();
        self.preferredContentSize = self.view.frame.size;
    }
    
    override func viewWillAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
