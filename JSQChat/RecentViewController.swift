//
//  RecentViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 19-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, chooseUserToChatVCDelegate {

    
    var recentsArray :[NSDictionary]!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        recentsArray = [NSDictionary]()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableViewOutlet.reloadData()
    }
    
    
    @IBAction func startNewChat(sender: UIBarButtonItem) {
     
        self.performSegueWithIdentifier("chatsToChooseUserVC", sender: self)
        
        
    }
    
    
    //MARK: TableView func
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recentsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("chatsCell", forIndexPath: indexPath) as! RecentTableViewCell
        
        let recentCellObj = recentsArray[indexPath.row]
        
        cell.bindDataFromCell(recentCellObj)
        
        return cell
    }
    

    
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "chatsToChooseUserVC" {
            
            let chooseVC = segue.destinationViewController as! ChooseUserViewController
            chooseVC.delegateVar = self
            
        }
        if segue.identifier == "chatsToChatScreen" {
            let indPatObj = sender as! NSIndexPath
            let chatVCObj = segue.destinationViewController as! ChatViewController
            
            let recentObjLocal = recentsArray[indPatObj.row]
            
            chatVCObj.recentDict = recentObjLocal
            chatVCObj.chatRoomID = recentObjLocal["chatroomID"] as? String
            
        }
        
    
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableViewOutlet.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("chatsToChatScreen", sender: self)
        
    }
    
    //MARK: customProtocol
    
    func createChatRoom(withUser: BackendlessUser) {
        
        let chatVCobj = ChatViewController()
        chatVCobj.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(chatVCobj, animated: true)
        chatVCobj.withUserVar = withUser
        chatVCobj.chatRoomID =  startChat(backendObj.userService.currentUser, user2: withUser)
        
    }

}
