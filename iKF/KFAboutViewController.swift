//
//  KFAboutViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-30.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFAboutViewController: UIViewController {
    
    @IBOutlet weak var labelVersion: UILabel!
    @IBOutlet weak var labelBuild: UILabel!
    @IBOutlet weak var labelBuildDate: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let aboutStr = KFResource.loadWebResource("about", ext: "html");
        webView.loadHTMLString(aboutStr, baseURL: nil);
        let version = NSBundle.mainBundle().infoDictionary["CFBundleShortVersionString"]! as String;
        labelVersion.text = version;
        let build = NSBundle.mainBundle().infoDictionary["CFBundleVersion"]! as String;
        labelBuild.text = build;
        let date = iKFUtil.getBuildDate() + " " + iKFUtil.getBuildTime();
        labelBuildDate.text = date;
    }
    
    override func viewWillAppear(animated: Bool) {        self.navigationController!.setNavigationBarHidden(false, animated: animated);
        self.navigationItem.title = "About iKF";
    }
    
    override func viewWillDisappear(animated: Bool) {        self.navigationController!.setNavigationBarHidden(true, animated: animated);
    }
    
    
}
