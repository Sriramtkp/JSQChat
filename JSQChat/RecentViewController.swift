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
        loadRecentRVCclass()
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recentsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("chatsCell", forIndexPath: indexPath) as! RecentTableViewCell
        
        let recentCellObj = recentsArray[indexPath.row]
        
        cell.bindDataFromCell(recentCellObj)
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableViewOutlet.deselectRowAtIndexPath(indexPath, animated: true)
        
        //create user2 when all users in recent was deleted, by RestartRecentChat 
        let recentArraySingleObj = recentsArray[indexPath.row]
                
        restartRecentChatFunc(recentArraySingleObj)
        
        
        
        self.performSegueWithIdentifier("chatsToChatScreen", sender: self)
        
    }
    
    //MARK: tableView Editing
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //get singleObj of the Array
        let recentArraySingleObj = recentsArray[indexPath.row]
        //remove recent from array
        recentsArray.removeAtIndex(indexPath.row)
        //delete recent from firebase
        deleteRecentItemFunc(recentArraySingleObj)
        
        
        
    tableViewOutlet.reloadData()
    
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
            chatVCObj.hidesBottomBarWhenPushed = true
            
            
            let recentObjLocal = recentsArray[indPatObj.row]
            
            chatVCObj.recentDict = recentObjLocal
            chatVCObj.chatRoomId = recentObjLocal["chatRoomId"] as? String
            
        }
        
        
    }

    
    
    //MARK: customProtocol
    
    func createChatRoom(withUser: BackendlessUser) {
        
        let chatVCobj = ChatViewController()
        chatVCobj.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(chatVCobj, animated: true)
        chatVCobj.withUserVar = withUser
        chatVCobj.chatRoomId =  startChat(backendObj.userService.currentUser, user2: withUser)
        
    }

    //MARK: loadRecnts
    
    func loadRecentRVCclass() {
        
        firRefObj.child("Recent").queryOrderedByChild("userId").queryEqualToValue(currenntUserObj.objectId).observeEventType(.Value, withBlock: {
        snapshot in
            self.recentsArray.removeAll()
            
            if snapshot.exists(){
                
                let sortedArray = ((snapshot.value?.allValues)! as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: false)])
                
                for recentLoop in sortedArray {
                    self.recentsArray.append(recentLoop as! NSDictionary )
                    
                    //add func to offline
            /* firRefObj.child("Recent").queryOrderedByChild("chatRoomId").queryEqualToValue(recentLoop["chatRoomId"]).observeEventType(.Value, withBlock: {
                        snapshot in
                
                
                
                    })
*/
                    
                }
                
                
            }
            
            self.tableViewOutlet.reloadData()
        })
        
        
        
    }
    
    
    
// end of RecentViewController
}
