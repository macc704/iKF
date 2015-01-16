//
//  KFScaffoldingTableViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-10.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFScaffoldingTableViewController: UITableViewController {
    
    var scaffolds:[KFScaffold] = [];
    var selectedHandler:((KFSupport)->())?;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = self.view.frame.size;
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return scaffolds.count;
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return scaffolds[section].supports.count;
    }
    
    // mark - Table view delegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section:Int = indexPath.section;
        let row:Int = indexPath.row;
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil);
        cell.textLabel!.text = self.scaffolds[section].supports[row].title;
        return cell;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return self.scaffolds[section].title;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if(selectedHandler != nil){
            let support = scaffolds[indexPath.section].supports[indexPath.row];
            selectedHandler!(support);
            self.dismissViewControllerAnimated(false, completion: nil);
        }
    }

}
