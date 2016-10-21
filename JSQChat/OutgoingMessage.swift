//
//  OutgoingMessage.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 21-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import Foundation

class OutgoingMessage {
    
    private let ref = firRefObj.child("Message")
    
    let messageDict: NSMutableDictionary
   //this initializer is for Message
    init(messagePrm: String, datePrm: NSDate, senderIDPrm: String, senderNamePrm: String, statusPrm: String, typePrm: String){
        
    messageDict = NSMutableDictionary(object: [messagePrm, datePrm,senderIDPrm,senderNamePrm,statusPrm,typePrm], forKey: ["message","date", "senderId", "senderName","status", "type"])
        }
    
    //this initializer is for Location
    
    init(messagePrm: String, latPrm: NSNumber, longiPrm:NSNumber, datePrm: NSDate, senderIDPrm: String, senderNamePrm: String, statusPrm: String, typePrm: String){
        
        messageDict = NSMutableDictionary(object: [messagePrm,latPrm,longiPrm,  datePrm,senderIDPrm,senderNamePrm,statusPrm,typePrm], forKey: ["message","latitude","longitude", "date", "senderId", "senderName","status", "type"])
        
    }

    //this initializer is for Picture

    init(messagePrm: String, picturePrm: NSData, datePrm: NSDate, senderIDPrm: String, senderNamePrm: String, statusPrm: String, typePrm: String){
        
        
        let picObj = picturePrm.base64EncodedDataWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                
         messageDict = NSMutableDictionary(object: [messagePrm, picObj,datePrm,senderIDPrm,senderNamePrm,statusPrm,typePrm], forKey: ["message","picture","date", "senderId", "senderName","status", "type"])
    }
    
    
    func sendMesgOutgoingFunc(chatRoomIDPrm: String, itemPrm: NSMutableDictionary) {
     
        let ref = firRefObj.child(chatRoomIDPrm).childByAutoId()
        itemPrm["messageId"] = ref.key
        
        ref.setValue(itemPrm){(error, ref) -> Void in
            if error != nil {
                print("error in sendMessages-\(error)")
            }
            
        }
        
        updateRecentFunc(chatRoomIDPrm, lastMessagePrm: (itemPrm["messageId"] as? String)!)
    }
    
    
    
    
    
    
    
    
    
    
    

 //end of OutgoingMessage
}















