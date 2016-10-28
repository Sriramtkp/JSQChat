//
//  IncomingMessage.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 25-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import Foundation
//import JSQMessagesCollectionView
import JSQMessagesViewController.JSQMessagesCollectionView



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
            messageVar = createLocationMessage(dictPrm)
            
            
        }
        
        if typeVar == "picture" {
            //create picture message
            messageVar = createPictureMessage(dictPrm)
            
            
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
    
    //MARK: createLocationMessage
    func createLocationMessage(itemLocationPrm: NSDictionary) -> JSQMessage {
        
        let name = itemLocationPrm["senderName"] as? String
        let userId = itemLocationPrm["senderId"] as? String
        let date = dateFormateFunc().dateFromString((itemLocationPrm["date"] as? String)!)
        let latObj = itemLocationPrm["latitude"] as? Double
        let longiObj = itemLocationPrm["longitude"] as? Double

        let mediaItemType = JSQLocationMediaItem(location: nil)
        mediaItemType.appliesMediaViewMaskAsOutgoing = returnOutgoingStatusFromUser(userId!)
        
        let locationObj = CLLocation(latitude: latObj!, longitude: longiObj!)
        
        mediaItemType.setLocation(locationObj) { 
            //update the CollectionView
            
            self.collectionViewIncomingMessageClass.reloadData()
            
        }
        
        return JSQMessage(senderId: userId!, senderDisplayName: name!, date: date, media: mediaItemType)
        
    }
   
    
    func returnOutgoingStatusFromUser(senderIdPrm:String) -> Bool {
        
        if senderIdPrm == backendShrdInstance.userService.currentUser.objectId {
            //outgoing Message
            return true
        }else{
            return false
        }
        
    }
    
    
    //MARK: createPictureMessage
    
    func createPictureMessage(itemPicturePrm: NSDictionary) -> JSQMessage  {
        
        let name = itemPicturePrm["senderName"] as? String
        let userId = itemPicturePrm["senderId"] as? String
        let date = dateFormateFunc().dateFromString((itemPicturePrm["date"] as? String)!)
        
        let mediaPictureItem = JSQPhotoMediaItem(image: nil)
        mediaPictureItem.appliesMediaViewMaskAsOutgoing = returnOutgoingStatusFromUser(userId!)
        
        imageFromData(itemPicturePrm) { (imagePrm: UIImage?) in
            
            mediaPictureItem.image = imagePrm
            self.collectionViewIncomingMessageClass.reloadData()
        }
        
        return JSQMessage(senderId: userId, senderDisplayName: name!, date: date, media: mediaPictureItem )
        
    }
    
    
    func imageFromData(itemImagePrm: NSDictionary, result : (image : UIImage?) -> Void) {
        
        var imageVar: UIImage?
        
        let decodeData = NSData(base64EncodedString: (itemImagePrm["picture"] as? String)!, options: NSDataBase64DecodingOptions(rawValue: 0))
        
        imageVar = UIImage(data: decodeData!)
        
//        return(image: imageVar)

        result(image: imageVar)
        
    }
    
    
    
    
    
    
    
    
    //end of incoming message
    
}