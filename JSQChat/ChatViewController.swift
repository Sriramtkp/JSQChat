//
//  ChatViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 20-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit
import JSQMessagesViewController
//import JSQMessagesViewController.JSQMessage

class ChatViewController: JSQMessagesViewController {

    
    var messagesArray: [JSQMessage] = []
    var objectsArray : [NSDictionary] = []
    var loadedArray : [NSDictionary] = []

    var withUserVar: BackendlessUser?
    var recentDict: NSDictionary?
    var chatRoomId: String!
    var initialLocationBool:Bool = false
    
    
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    
    let incomingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleRedColor())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


self.senderId = currenntUserObj.objectId
        self.senderDisplayName = currenntUserObj.name
    
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        self.inputToolbar.contentView.textView.placeHolder = "Type New Message"
        self.inputToolbar.contentView.textView.placeHolderTextColor = UIColor.redColor()
    loadMessagesFuncChatVC()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: JSQMessageCollections func
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let dataMesge = messagesArray[indexPath.row]
        
        if dataMesge.senderId == currenntUserObj.objectId {
            
            cell.textView.textColor = UIColor.whiteColor()
            
        }else{
            cell.textView.textColor = UIColor.blueColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messagesArray.count
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        let data = messagesArray[indexPath.row]
        
        return data
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = messagesArray[indexPath.row]
        if data.senderId == currenntUserObj.objectId {
            return outgoingBubble
        }else{
            return incomingBubble
        }
        
        
    }
    
    //MARK: Send Buttons
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        if text != nil {
            print("send btn pressed")
//            send our message
            sendMessageFunc(text, datePrm: date, picturePrm: nil, locationPrm: nil)
//            print("\(text)")
        }
        
        
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("Accessory btn pressed")
    }
    
    
    
    //MARK: sendMessage callBackFunc
    
    func sendMessageFunc(textPrm: String?, datePrm:NSDate, picturePrm: UIImage?, locationPrm: String? )  {
        
        var outgoingMsgoptionalObj = OutgoingMessage?()
        
        
        
        if let text = textPrm {
                     //send message
            
            outgoingMsgoptionalObj = OutgoingMessage(messagePrm: text, datePrm: datePrm, senderIDPrm: currenntUserObj.objectId!, senderNamePrm: currenntUserObj.name!, statusPrm: "Delivered", typePrm: "text")
        }
        if let pic = picturePrm {
            
        }
        if let loc = locationPrm {
            
        }
        
        //playSound after sending anyType of data
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
        
        outgoingMsgoptionalObj?.sendMesgOutgoingFunc(chatRoomId, itemPrm: (outgoingMsgoptionalObj!.messageDict))
        
    }
    
    //MARK: loadMessages
    
    func loadMessagesFuncChatVC() {
        
        
        firRefObj.child(chatRoomId).observeEventType(.ChildAdded, withBlock: {
            
            snapshot in
            
            
            if snapshot.exists() {
                
                let item = (snapshot.value as? NSDictionary)!
                
                if self.initialLocationBool{
                    //get insertMesgObj
                    
                    let insertIncomingMsgObj = self.insertMessageItem(item)
                    if insertIncomingMsgObj {
//                        JSQSystemSoundPlayer.jsq_playMessageReceivedSound
                        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                        
                    }
                    self.finishReceivingMessageAnimated(true)
                    
                }else{
                    //add each dictionary load array
                    self.loadedArray.append(item)
                }
                
            }
            
            
            
            self.finishReceivingMessageAnimated(true)
            
            
            })
        
        firRefObj.child(chatRoomId).observeEventType(.ChildChanged, withBlock: {
            
            snapshot in
            
            //update message
            
        })
        firRefObj.child(chatRoomId).observeEventType(.ChildRemoved, withBlock: {
            
            snapshot in
            
            //delete message
            
        })
        firRefObj.child(chatRoomId).observeEventType(.Value, withBlock: {
            
            snapshot in
            
            //get dictionaries
            
            
            //create JSQMessage
            
            self.insertMessagesFunc()
           self.finishReceivingMessageAnimated(true)
            self.initialLocationBool = true

            
        })
    }
    
    
    
    func insertMessagesFunc()  {
        for itemLoop in loadedArray {
            //create Messages

            insertMessageItem(itemLoop)
   }
                
    }
    
    func insertMessageItem(itemInsertMe: NSDictionary) -> Bool {
        //call back Incoming messge func from incoming message class
        
//        let incomingMsgObj = IncomingMessage(collectionViewIncomingMessageClass_: self.collectionViewIncomingMessageClass!)
        let incomingMsgObj = IncomingMessage(collectionViewIncomingMessageClass_: self.collectionView!)
        
        
        
        
        //get obj of incomingMsgClass
        let messageObj = incomingMsgObj.createMsgFuncIncomingMsgCls(itemInsertMe)
        //append the item to the array
        objectsArray.append(itemInsertMe)
        
        messagesArray.append(messageObj!)
        
return incomingMesssageFunc(itemInsertMe)
        //        return true
    }
    
    func incomingMesssageFunc(item: NSDictionary) -> Bool {
        
        if self.senderId == item["senderId"] as! String {
            return false
        }
        
        else {
            return true

        }
    }

    func outgoingMessageFunc(item: NSDictionary) -> Bool {
        if self.senderId == item["senderId"] as! String {
            return true
        }else{
            return false
        }
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
