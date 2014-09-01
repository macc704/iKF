//
//  KFMenuViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

protocol KFMenu{
    func getAccessoryType()->UITableViewCellAccessoryType;
    //{return UITableViewCellAccessoryCheckmark;}
    func getName()->String;
    func execute();
}

class KFMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var menues:[KFMenu] = [];
    var closeHandler:(()->())?;
    var selectedHandler:((KFMenu)->())?;
    
    private var barTitle:String!;
    private var fitsize = false;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(menues:[KFMenu]){
        super.init(nibName: "KFMenuViewController", bundle: nil);
        self.menues = menues;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        if(barTitle != nil){
            titleBar.topItem.title = barTitle;
        }
        
        if(fitsize){
            let original:CGFloat = 568;//iphone 4inch
            let calc:CGFloat = CGFloat(44*menues.count)+titleBar.frame.size.height;
            let height = min(original, calc);
            println(height);
            self.preferredContentSize = CGSizeMake(self.view.frame.width,height);
        }else{
            self.preferredContentSize = self.view.frame.size;
        }
        //        self.preferredContentSize = self.view.frame.size;
        
        //        let a = NSIndexPath(index: 0);
        //        tableView.selectRowAtIndexPath(a, animated: false, scrollPosition: UITableViewScrollPosition.Middle);
    }
    
    func setBarTitle(title:String){
        self.barTitle = title;
    }
    
    func fit(){
        self.fitsize = true;
    }
    
    override func viewWillDisappear(animated: Bool) {
        if(closeHandler != nil){
            closeHandler!();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return menues.count;
    }
    
    // mark - Table view delegate
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let row:Int! = indexPath?.row;
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil);
        cell.accessoryType = self.menues[row].getAccessoryType();
        cell.textLabel.text = self.menues[row].getName();
        return cell;
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        let row:Int! = indexPath?.row;
        self.menues[row].execute();
        if(selectedHandler != nil){
            selectedHandler!(self.menues[row]);
        }
        tableView.reloadData();
        //self.dismissViewControllerAnimated(false, completion: nil);
    }
    
}
