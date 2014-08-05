//
//  KFScaffoldingTableViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-10.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFScaffoldingTableViewController: UITableViewController {
    
    var noteEditView:iKFAbstractNoteEditView?;
    var scaffolds = Array<KFScaffold>();
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return scaffolds.count;
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return scaffolds[section].supports.count;
    }
    
    // mark - Table view delegate
    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let section:Int! = indexPath?.section;
        let row:Int! = indexPath?.row;
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil);
        cell.textLabel.text = self.scaffolds[section].supports[row].title;
        return cell;
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return self.scaffolds[section].title;
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        if(self.noteEditView? != nil){
            let title = scaffolds[indexPath.section].supports[indexPath.row].title;
            let supportId = scaffolds[indexPath.section].supports[indexPath.row].guid;
            let uniqueId = String(Int(NSDate.date().timeIntervalSince1970));
            let template = KFService.getInstance().getURL("https://dl.dropboxusercontent.com/u/11409191/ikf/scaffoldtag.txt");
            var insertString = template!;
            insertString = insertString.stringByReplacingOccurrencesOfString("%SUPPORTID%", withString: supportId, options: nil, range: nil);
            insertString = insertString.stringByReplacingOccurrencesOfString("%UNIQUEID%", withString: uniqueId, options: nil, range: nil);
            insertString = insertString.stringByReplacingOccurrencesOfString("%TITLE%", withString: title, options: nil, range: nil);
            //insertString = insertString.stringByReplacingOccurrencesOfString("\r", withString: "", options: nil, range: nil);
            //insertString = insertString.stringByReplacingOccurrencesOfString("\n", withString: "", options: nil, range: nil);
            self.noteEditView?.insertText(insertString);
        }
        self.dismissViewControllerAnimated(false, completion: nil);
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
