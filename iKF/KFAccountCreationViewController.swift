//
//  KFAccountCreationViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFAccountCreationViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var host:String!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(host != nil){
            let url = NSURL(string: "http://\(host)/kforum/register");
            let req = NSURLRequest(URL: url!);
            self.webView.loadRequest(req);
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated);
        self.navigationItem.title = "Create Account for \(host)";
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
