//
//  ViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-05.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let controller = KFLoginViewController(nibName: "KFLoginViewController", bundle: nil);
        self.presentViewController(controller, animated: true, completion: nil);
    }
    
    
}

