//
//  KFViewSelectionController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-30.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFViewSelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var views:[KFView] = [];
    var selectedHandler:((KFView)->())?;
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(){
        super.init(nibName: "KFViewSelectionController", bundle: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.preferredContentSize = self.view.frame.size;
//        let a = NSIndexPath(index: 0);
//        tableView.selectRowAtIndexPath(a, animated: false, scrollPosition: UITableViewScrollPosition.Middle);
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
        return views.count;
    }
    
    // mark - Table view delegate
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let row:Int! = indexPath?.row;
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil);
        cell.textLabel.text = self.views[row].title;
        return cell;
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        if(selectedHandler != nil){
            let row:Int! = indexPath?.row;
            selectedHandler!(self.views[row]);
            self.dismissViewControllerAnimated(false, completion: nil);
        }
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
