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

    
//    var messagesArray: [JSQMessages] = []
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
