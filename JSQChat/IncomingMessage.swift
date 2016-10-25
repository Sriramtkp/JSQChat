//
//  IncomingMessage.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 25-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import Foundation
import JSQMessagesCollectionView


class IncomingMessage {
    
    var collectionViewIncomingMessageClass: JSQMessagesCollectionView
    
    init(collectionViewIncomingMessageClass_: JSQMessagesCollectionView){
        collectionViewIncomingMessageClass = collectionViewIncomingMessageClass_
   
     }
    
    func createMsgFuncIncomingMsgCls(dictPrm: NSDictionary) -> JSQMessage? {
        
        var messageVar: JSQMessage?
        let typeVar = dictPrm["type"] as? String
        
        if typeVar == "text" {
//            create text message
            
            messageVar = createTextMessageFunc(dictPrm)
            
            
        }
        if typeVar == "location" {
            //create location message
        }
        
        if typeVar == "picture" {
            //create picture message
        }
        if let mes = messageVar {
        return mes
            
        }
        
            
        return nil
    }
    
    //MARK: createTextMessage
    
    func createTextMessageFunc(itemTextPrm: NSDictionary) ->  JSQMessage{
        
        let name = itemTextPrm["senderName"] as? String
        let userId = itemTextPrm["senderId"] as? String
        let date = dateFormateFunc().dateFromString((itemTextPrm["date"] as? String)!)
        let text = itemTextPrm["message"] as? String
        
        
        return JSQMessage(senderId: userId, senderDisplayName: name, date: date, text: text)
        
        
        
        
    }
    
    
   
    //end of incoming message
    
}