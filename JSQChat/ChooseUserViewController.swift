//
//  ChooseUserViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 20-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit


protocol chooseUserToChatVCDelegate {
    //required func
    func createChatRoom(users : BackendlessUser)
    
}


class ChooseUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var userArray : [BackendlessUser] = []
    var delegateVar : chooseUserToChatVCDelegate!
    
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadUsers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: TableView func
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userArray.count
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("newMessageCell", forIndexPath: indexPath)
        
        let recentCellObj = userArray[indexPath.row] 
        
        cell.textLabel?.text = recentCellObj.name
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let userObj = userArray[indexPath.row]
        delegateVar.createChatRoom(userObj)
        
        
        self.tableViewOutlet.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    @IBAction func cancelBtnPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // backend func
    
    func loadUsers() {
    
        
        let whereClauseObj = "objectId != '\(currenntUserObj.objectId)'"
        
      let dataQueryObj = BackendlessDataQuery()
        dataQueryObj.whereClause = whereClauseObj
        
        
        
        let dataStoreObj = backendObj.persistenceService.of(BackendlessUser.ofClass())
        dataStoreObj.find(dataQueryObj, response: { (users : BackendlessCollection!) in
            
            self.userArray = users.data as! [BackendlessUser]
            
            //reload Data
            
            self.tableViewOutlet.reloadData()
            
            for user in users.data {
                
                let u = user as! BackendlessUser
                print(u.name)
                
                
            }
            
            
            
        }) { (fault : Fault!) in
            print("fault in loadusers\(fault)")
        }
        
         }
    
    
    
    
    
    
    
// end of ChooseUserViewController
}
