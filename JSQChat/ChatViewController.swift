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

class ChatViewController: JSQMessagesViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

//    /after getting location
    let appDelgateObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let ref = firRefObj.child("Message")
    
    
    
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
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: nil, message: nil , preferredStyle: .ActionSheet)
            
            let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) {
                (action: UIAlertAction) -> Void in
                
                print("Take Photo")
                
                Camera.PresentPhotoCamera(self, canEdit: true)
                
                
//                self.dismissViewControllerAnimated(true, completion: nil)
            }
            let sharePhoto = UIAlertAction(title: "Photo Library", style: .Default) {
                (action: UIAlertAction) -> Void in
                
                print("Photo Library")
                Camera.PresentPhotoLibrary(self, canEdit: true)
//                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            let shareLocation = UIAlertAction(title: "Share Location", style: .Default) {
                (action: UIAlertAction) -> Void in
                
                print("Share Location")
                
                self.sendMessageFunc(nil, datePrm: NSDate(), picturePrm: nil, locationPrm: "location")
                
//                self.dismissViewControllerAnimated(true, completion: nil)
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel) {
                (action: UIAlertAction) -> Void in
                
                print("Cancel")
                
//                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(takePhoto)
            alert.addAction(sharePhoto)
            alert.addAction(shareLocation)
            alert.addAction(cancelButton)
            alert.view.setNeedsLayout()
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
        
    }
    
  //MARK: UIACtion Sheet for Sharing and Choosing message
func displayAlert(titleMsg: String, MessageTxt: String) {
    
    
  }
    
    
    //MARK: sendMessage callBackFunc
    
    func sendMessageFunc(textPrm: String?, datePrm:NSDate, picturePrm: UIImage?, locationPrm: String? )  {
        
        var outgoingMsgoptionalObj = OutgoingMessage?()
        
        
        
        if let text = textPrm {
                     //send message
            
            outgoingMsgoptionalObj = OutgoingMessage(messagePrm: text, datePrm: datePrm, senderIDPrm: currenntUserObj.objectId!, senderNamePrm: currenntUserObj.name!, statusPrm: "Delivered", typePrm: "text")
        }
        if let pic = picturePrm {
            
            let imageDataObj = UIImageJPEGRepresentation(pic, 1.0)
            
            outgoingMsgoptionalObj = OutgoingMessage(messagePrm: "Picture", picturePrm: imageDataObj!, datePrm: datePrm, senderIDPrm: currenntUserObj.objectId!, senderNamePrm: currenntUserObj.name!, statusPrm: "Delivered", typePrm: "picture")
            
            
        }
        if let _ = locationPrm {
            
            let latObj: NSNumber = NSNumber(double: (appDelgateObj.coordVar?.latitude)!)
            let longiObj: NSNumber = NSNumber(double: (appDelgateObj.coordVar?.longitude)!)
            
            outgoingMsgoptionalObj = OutgoingMessage(messagePrm: "Location", latPrm: latObj, longiPrm: longiObj, datePrm: datePrm, senderIDPrm: currenntUserObj.objectId!, senderNamePrm: currenntUserObj.name!, statusPrm: "Delivered", typePrm: "location")
            
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

    
    
    //MARK: UIIMagePicker delegate funcs
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let pictureInfo = info[UIImagePickerControllerEditedImage] as! UIImage

        // callBack sendMessage
        
        self.sendMessageFunc(nil, datePrm: NSDate(), picturePrm: pictureInfo, locationPrm: nil)
        picker.dismissViewControllerAnimated(true, completion: nil)
        
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
