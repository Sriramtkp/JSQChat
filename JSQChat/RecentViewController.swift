//
//  RecentViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 19-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var recents :[NSDictionary] = []
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    @IBAction func startNewChat(sender: UIBarButtonItem) {
     
        
    }
    
    //MARK: TableView func
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recents.count
    }
    
    
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("chatsCell", forIndexPath: indexPath) as! RecentTableViewCell
        
        let recentCellObj = recents[indexPath.row]
        
        cell.bindDataFromCell(recentCellObj)
        
        return cell
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
