//
//  Recent.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 20-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase


//MARK: Constants
public let kAVATARSTATE = "avatarState"
public let kFIRSTRUN = "firstrun"






var firRefObj = FIRDatabase.database().reference()


let backendShrdInstance = Backendless.sharedInstance()
//let currenntUserObj = backendRecentObj.userService.currentUser
//user1 is the Current User


//MARK: create ChatRoom

func startChat(user1: BackendlessUser, user2: BackendlessUser) -> String {
    
    let userID1: String = user1.objectId
    let userID2: String = user2.objectId
    
    var chatRoomIdStr: String = ""
    let valueCompareUsers = userID1.compare(userID2).rawValue
    
    if valueCompareUsers < 0 {
        
        chatRoomIdStr = userID1.stringByAppendingString(userID2)
        
    }else{
        chatRoomIdStr = userID2.stringByAppendingString(userID1)
    }
    
        let membersLocArr = [userID1, userID2]
    
    //create Recents
    createRecent(userID1, chatRoomIDPrm: chatRoomIdStr, membersPrm: membersLocArr, withUserUserNamePrm: user2.name!, withUserUserIDPrm: userID2)
    
    createRecent(userID2, chatRoomIDPrm: chatRoomIdStr, membersPrm: membersLocArr, withUserUserNamePrm: user1.name!, withUserUserIDPrm: userID1)
    

    return chatRoomIdStr
}


func createRecent(userIDPrm: String , chatRoomIDPrm : String, membersPrm: [String], withUserUserNamePrm : String, withUserUserIDPrm : String) {
    
    
    firRefObj.child("Recent").queryOrderedByChild("chatRoomId").queryEqualToValue(chatRoomIDPrm).observeSingleEventOfType(.Value, withBlock: {snapshot in
    
        //bool
        
        var createRecentBool = true
        
        if snapshot.exists() {
            for recentLoop in (snapshot.value?.allValues)! {
                //if we already have the Recent along with userId, then we dont want to create Recent
                if recentLoop["userId"] as! String == userIDPrm  {
                    createRecentBool = false

                }
                //for recentLoop
            }
            //if snapshot stmt ends
        }
        
        if createRecentBool{
            
            createRecentNewItem(userIDPrm, chatRoomIDPrm1: chatRoomIDPrm, membersPrm1: membersPrm, withUserUserNamePrm1: withUserUserNamePrm, withUserUserIDPrm1: withUserUserIDPrm)
        }
    })
    
    
}

//MARK: CreateRecentItem
func createRecentNewItem(userIDPrm1: String , chatRoomIDPrm1: String, membersPrm1: [String], withUserUserNamePrm1 : String, withUserUserIDPrm1 : String) {
    
    
    let ref = firRefObj.child("Recent").childByAutoId()
    let recentId = ref.key
    
    let dateId = dateFormateFunc().stringFromDate(NSDate())
    
    
    let recentItemObj = ["recentId" : recentId, "lastMessage" :" ", "counter" : 0 , "date" : dateId,  "userId" : userIDPrm1, "chatRoomId" :chatRoomIDPrm1, "members": membersPrm1, "withUserUserName" : withUserUserNamePrm1, "withUserUserID" : withUserUserIDPrm1 ]
    
    //save to Firebase
    ref.setValue(recentItemObj){ (error, ref) -> Void in
        if error != nil {
            
            print("Error in Saving recentItem in FB---\(error)")
            
        }else{
            
        }
        
    }
    
}


// Mark: Hekper func only

private let dateFormateObj = "yyMMddHHmmss"

func dateFormateFunc() -> NSDateFormatter {
    
    let dateFromatterObj = NSDateFormatter()
    dateFromatterObj.dateFormat = dateFormateObj
    
    return dateFromatterObj
    
}

//MARK: deleteRecentItem

func deleteRecentItemFunc(recentDeleteItemDict : NSDictionary ){
    firRefObj.child("Recent").child((recentDeleteItemDict["recentId"] as? String)!).removeValueWithCompletionBlock { (error, refBlockObj) in
        
        if error != nil{
            print("Error is in delete Recent\(error)")
        }
    }
    
}

//MARK:Restart RecentChat

func restartRecentChatFunc(recentDicRestartFunc : NSDictionary) {
    
    for userIdObj in recentDicRestartFunc["memebers"] as! [String] {
        
        if userIdObj != backendShrdInstance.userService.currentUser.objectId {
            
            createRecent(userIdObj, chatRoomIDPrm: (recentDicRestartFunc["chatRoomId"] as? String)!, membersPrm: recentDicRestartFunc["memebers"] as! [String], withUserUserNamePrm: backendShrdInstance.userService.currentUser.name, withUserUserIDPrm: backendShrdInstance.userService.currentUser.objectId)
        }
        
    }
    
}

//MARK: updateRecent

func updateRecentFunc(chatRoomIDPrm: String, lastMessagePrm: String) {
    
    firRefObj.child("Recent").queryOrderedByChild("chatRoomId").queryEqualToValue(chatRoomIDPrm).observeSingleEventOfType(.Value, withBlock: {
        snapshot in
        
        if snapshot.exists() {
            
            for recentLoop in snapshot.value!.allValues{
                //update Recent
                
                updateRecentItemFunc(recentLoop as! NSDictionary, lastMessageStrPrm: lastMessagePrm)
            }
            
        }
        
        })
    
    }


func updateRecentItemFunc(recentDictPrm: NSDictionary, lastMessageStrPrm: String){
    
    let dateObj = dateFormateFunc().stringFromDate(NSDate())
    var countObj = recentDictPrm["counter"] as! Int
    
    if recentDictPrm["userId"] as? String != backendShrdInstance.userService.currentUser.objectId {
        countObj += 1
    }
    
    let valuesDict = ["lastMessage": lastMessageStrPrm, "counter": countObj,"date":dateObj]
    
    firRefObj.child("Recent").child((recentDictPrm["recentId"] as? String)!).updateChildValues(valuesDict as [NSObject : AnyObject]) { (errorObj, refObj) in
        
        if errorObj != nil{
            print("Error in updateRecentItemFunc ... \(errorObj)")
        }
    }
    
    
}


//MARK: clearRecentCounterItem timer

func ClearRecentCount(chatRoomId: String) {
    
    
    firRefObj.child("Recent").queryOrderedByChild("chatRoomId").queryEqualToValue(chatRoomId).observeSingleEventOfType(.Value, withBlock: {
        
        snapshot in
        if snapshot.exists(){
            for recentLoop in snapshot.value!.allValues {
                if recentLoop.objectForKey("userId") as? String == backendShrdInstance.userService.currentUser.objectId{
                    //clear recentCounter
                    
                clearRecentCounterItem(recentLoop as! NSDictionary)
                }
            
            
            
            }
        }
    })
 }

func clearRecentCounterItem(recentClearItem:NSDictionary) {
//    firRefObj.child("Recent").child(recentClearItem["recentId"] as? String).updateChildValues(["counter": 0]) { (error, ref) in
//        if error != nil {
//            print("error in clearRecentCounterItem\(error)")
//        }
//        
//    }
    
    firRefObj.child("Recent").child((recentClearItem["recentId"] as? String)!).updateChildValues(["counter" : 0]) { (error, refObj) in
        if error != nil {
            
            print("\(error)")
        }
    }
    
   }













