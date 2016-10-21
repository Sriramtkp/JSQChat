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

var firRefObj = FIRDatabase.database().reference()


let backendObj = Backendless.sharedInstance()
let currenntUserObj = backendObj.userService.currentUser


//MARK: create ChatRoom

func startChat(user1: BackendlessUser, user2: BackendlessUser) -> String {
    
    //user1 is the Current User
    let userID1 : String = user1.objectId
    let userID2 : String = user2.objectId
    
    var chatRoomIdStr: String = ""
    let valueCompareUsers = userID1.compare(userID2).rawValue
    
    if valueCompareUsers < 0 {
        
        chatRoomIdStr = userID1.stringByAppendingString(userID2)
        
    }else{
        chatRoomIdStr = userID2.stringByAppendingString(userID1)
    }
    
        let membersLocArr = [user1, user2]
    
    //create Recents
    createRecent(userID1, chatRoomIDPrm: chatRoomIdStr, membersPrm: membersLocArr, withUserUserNamePrm: user2.name!, withUserUserIDPrm: userID2)
    
    createRecent(userID2, chatRoomIDPrm: chatRoomIdStr, membersPrm: membersLocArr, withUserUserNamePrm: user1.name!, withUserUserIDPrm: userID1)
    

    return chatRoomIdStr
}


func createRecent(userIDPrm: String , chatRoomIDPrm : String, membersPrm : [String], withUserUserNamePrm : String, withUserUserIDPrm : String) {
    
    
    firRefObj.child("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(chatRoomIDPrm).observeSingleEventOfType(.Value, withBlock: {snapshot in
    
        //bool
        
        var createRecentBool = true
        
        if snapshot.exists() {
            for recentLoop in snapshot.value?.allValues {
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

//MARK : CreateRecentItem
func createRecentNewItem(userIDPrm1: String , chatRoomIDPrm1 : String, membersPrm1: [String], withUserUserNamePrm1 : String, withUserUserIDPrm1 : String) {
    
    
    let ref = firRefObj.child("Recent").childByAutoId()
    let recentId = ref.key
    
    let dateId = dateFormateFunc().stringFromDate(NSDate())
    
    
    let recentItemObj = ["recentId" : recentId, "lastMessage" :" ", "counter" : 0 , "date" : dateId,  "userId" : userIDPrm1, "chatRoomID" :chatRoomIDPrm1, "members": membersPrm1, "withUserUserName" : withUserUserNamePrm1, "withUserUserID" : withUserUserIDPrm1 ]
    
    //save to Firebase
    ref.setValue(recentItemObj){ (error, ref) -> Void in
        if error != nil {
            
            print("Error in Saving recentItem in FB---\(error)")
            
        }else{
            
        }
        
    }
    
    
    
}


// Mark : Hekper func only

private let dateFormateObj = "yyMMddHHmmss"

func dateFormateFunc() -> NSDateFormatter {
    
    let dateFromatterObj = NSDateFormatter()
    dateFromatterObj.dateFormat = dateFormateObj
    
    return dateFromatterObj
    
}