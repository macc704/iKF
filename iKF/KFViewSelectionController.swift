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
    
    var models:[KFModel] = [];
    var selectedHandler:((KFModel)->())?;
    
    var barTitle = "Views";
    
    required init(coder aDecoder: NSCoder) {
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
        navigationBar.topItem!.title = barTitle;
    }
    
    func setBarTitle(title:String){
        self.barTitle = title;
    }
    
    // #pragma mark - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count;
    }
    
    // mark - Table view delegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row:Int = indexPath.row;
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil);
        cell.textLabel.text = self.models[row].toString();
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if(selectedHandler != nil){
            let row:Int! = indexPath.row;
            selectedHandler!((self.models[row]));
            self.dismissViewControllerAnimated(false, completion: nil);
        }
    }

}
