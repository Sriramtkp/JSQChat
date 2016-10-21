//
//  ChatViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 20-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import JSQMessagesViewController.JSQMessage

class ChatViewController: JSQMessagesViewController {

    
    var messagesArray: [JSQMessage] = []
    var objectsArray : [NSDictionary] = []
    var loadedArray : [NSDictionary] = []

    var withUserVar: BackendlessUser?
    var recentDict: NSDictionary?
    var chatRoomID: String?
    
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
        }
        
        
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("Accessory btn pressed")
    }
    
    
    
    //MARK: sendMessage callBackFunc
    
    func sendMessageFunc(textPrm: String?, datePrm:NSDate, picturePrm: UIImage?, locationPrm: String? )  {
        
        if let text = textPrm {
         //send message
            
        }
        if let pic = picturePrm {
            
        }
        if let loc = locationPrm {
            
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
