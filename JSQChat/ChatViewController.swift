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
import IDMPhotoBrowser
//import ProgressHUD

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
    
    var avatarImageMutDict: NSMutableDictionary?
    var avatarMutDict: NSMutableDictionary?
    var showAvatarBool: Bool = false
    var appFirstLoadedBool: Bool?
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    
    let incomingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleRedColor())
    
    
    let userDefaultsObj = NSUserDefaults.standardUserDefaults()
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()


self.senderId = backendShrdInstance.userService.currentUser.objectId
        self.senderDisplayName = backendShrdInstance.userService.currentUser.name
    
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        self.inputToolbar.contentView.textView.placeHolder = "Type New Message"
        self.inputToolbar.contentView.textView.placeHolderTextColor = UIColor.redColor()
        
        
        if withUserVar?.objectId == nil {
            
            getWithUserFromRecent(recentDict!, result: { (withUser) in
                
                self.withUserVar = withUser
                self.title = withUser.name
                self.getAvatar()
                
            })
        }else{
            self.title = withUserVar?.name
            self.getAvatar()
        }
        
        
        
        //load firebase messages
    loadMessagesFuncChatVC()
        
    //end of viewDidLoad
    }

     func  viewWillDisppear(animated: Bool){
        clearRecentCounterFunc(chatRoomId)
        ref.removeAllObservers()
        
    }
    
    //MARK: viewWillAppear
    override func viewWillAppear(animated: Bool) {
        
        loadUserDefaults()
        
    }
    //MARK: viewWillAppear

    
    
    
    
    //MARK: loadUserDefaults
    
    func loadUserDefaults() {
        
        appFirstLoadedBool = userDefaultsObj.boolForKey(kFIRSTRUN)
        if !appFirstLoadedBool! {
            userDefaultsObj.setBool(true, forKey: kFIRSTRUN)
            userDefaultsObj.setBool(showAvatarBool, forKey: kAVATARSTATE)
        }
        
        showAvatarBool = userDefaultsObj.boolForKey(kAVATARSTATE)
        
      
        
    }
    
    
    //MARK: Clear recent Counter func
    func clearRecentCounterFunc(chatRoomId : String) {
        
        
        firRefObj.child("Recent").queryOrderedByChild("chatRoomId").queryEqualToValue(chatRoomId).observeSingleEventOfType(.Value, withBlock: {
            
            snapshot in
            if snapshot.exists(){
                for recentLoop in snapshot.value!.allValues {
                    
                    if recentLoop.objectForKey("userId") as? String == backendShrdInstance.userService.currentUser.objectId {
                        //clear count
                        
                        
                    }
                    
                    }
            }
            
        })
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: avatarImageData
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let mesgObj = messagesArray[indexPath.row]
        let avatarObj = avatarImageMutDict!.objectForKey(mesgObj.senderId) as! JSQMessageAvatarImageDataSource
        
        return avatarObj
        
        
    }
    
    
//MARK: JSQMessageCollections func
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let dataMesge = messagesArray[indexPath.row]
        
        if dataMesge.senderId == backendShrdInstance.userService.currentUser.objectId {
            
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
        if data.senderId == backendShrdInstance.userService.currentUser.objectId {
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
        
//        dispatch_async(dispatch_get_main_queue(), {
        
        let cameraObj = Camera(delegateProtocol_: self)
        
        
            let alert = UIAlertController(title: nil, message: nil , preferredStyle: .ActionSheet)
            
            let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) {
                (action: UIAlertAction) -> Void in
                
                print("Take Photo")
                
                cameraObj.PresentPhotoCamera(self, canEdit: true)
                
                
//                self.dismissViewControllerAnimated(true, completion: nil)
            }
            let sharePhoto = UIAlertAction(title: "Photo Library", style: .Default) {
                (action: UIAlertAction) -> Void in
                
                print("Photo Library")
                cameraObj.PresentPhotoLibrary(self, canEdit: true)
//                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            let shareLocation = UIAlertAction(title: "Share Location", style: .Default) {
                (action: UIAlertAction) -> Void in
                
                print("Share Location")
                if self.haveAccessToLocation() {
                    self.sendMessageFunc(nil, datePrm: NSDate(), picturePrm: nil, locationPrm: "location")

                }
                
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
            
//         })
        
    }
    
  //MARK: UIACtion Sheet for Sharing and Choosing message
func displayAlert(titleMsg: String, MessageTxt: String) {
    
    
  }
    
    
    //MARK: sendMessage callBackFunc
    
    func sendMessageFunc(textPrm: String?, datePrm:NSDate, picturePrm: UIImage?, locationPrm: String? )  {
        
        var outgoingMsgoptionalObj = OutgoingMessage?()
        
        
        
        if let text = textPrm {
                     //send message
            
            outgoingMsgoptionalObj = OutgoingMessage(messagePrm: text, datePrm: datePrm, senderIDPrm: backendShrdInstance.userService.currentUser.objectId!, senderNamePrm: backendShrdInstance.userService.currentUser.name!, statusPrm: "Delivered", typePrm: "text")
        }
        if let pic = picturePrm {
            
            let imageDataObj = UIImageJPEGRepresentation(pic, 1.0)
            
            outgoingMsgoptionalObj = OutgoingMessage(messagePrm: "Picture", picturePrm: imageDataObj!, datePrm: datePrm, senderIDPrm: backendShrdInstance.userService.currentUser.objectId!, senderNamePrm: backendShrdInstance.userService.currentUser.name!, statusPrm: "Delivered", typePrm: "picture")
            
            
        }
        if let _ = locationPrm {
            
            let latObj: NSNumber = NSNumber(double: (appDelgateObj.coordVar?.latitude)!)
            let longiObj: NSNumber = NSNumber(double: (appDelgateObj.coordVar?.longitude)!)
            
            outgoingMsgoptionalObj = OutgoingMessage(messagePrm: "Location", latPrm: latObj, longiPrm: longiObj, datePrm: datePrm, senderIDPrm: backendShrdInstance.userService.currentUser.objectId!, senderNamePrm: backendShrdInstance.userService.currentUser.name!, statusPrm: "Delivered", typePrm: "location")
            
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
        
        if backendShrdInstance.userService.currentUser.objectId == item["senderId"] as! String {
            return false
        }
        
        else {
            return true

        }
    }

    func outgoingMessageFunc(item: NSDictionary) -> Bool {
        if backendShrdInstance.userService.currentUser.objectId == item["senderId"] as! String {
            return true
        }else{
            return false
        }
    }

    //MARK: Location Helper func
    
    func haveAccessToLocation() -> Bool {
        
        if let _ = appDelgateObj.coordVar?.latitude {
            return true
        }else{
            
            print("no access for location")
            return false
        }
        
    }
    
    //MARK: getAvatar func
    
    func getAvatar(){
        
        if showAvatarBool {
            collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(30, 30)
            collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(30, 30)

        }
        
        
        //download avatars
        avatarImageFromBackendlessUser(backendShrdInstance.userService.currentUser)
        avatarImageFromBackendlessUser(withUserVar!)
        
        //create avatars
        createAvatarFunc(avatarImageMutDict)
    }
    
    func getWithUserFromRecent(recentPrm:NSDictionary, result:(withUser:BackendlessUser) ->  Void)  {
        
        let withUserId = recentPrm["withUserUserId"] as? String
        
        let whereClause = "objectId = '\(withUserId!)'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let dataStoreObj = backendShrdInstance.persistenceService.of(BackendlessUser.ofClass())
        dataStoreObj.find(dataQuery, response: { (users: BackendlessCollection!) in
            let withUserFirst = users.data.first as! BackendlessUser
            result(withUser: withUserFirst)
            
            
        }) { (fault: Fault!) in
                print("error in getWithUserFromRecent func \(fault)")
        }
           }
    
    
    func createAvatarFunc(avatarPrm: NSMutableDictionary?) {
        
        var currentUserAvatarObj = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "avatarPlaceholder"), diameter: 70)
        let withUserAvatarObj = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "avatarPlaceholder"), diameter: 70)
        
        if let ava = avatarPrm{
            
            if let currentAvatarImage = ava.objectForKey(backendShrdInstance.userService.currentUser.objectId) {
                
                currentUserAvatarObj = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: currentAvatarImage as! NSData), diameter: 70)
                self.collectionView?.reloadData()
            }
            }
        
        avatarMutDict = [backendShrdInstance.userService.currentUser.objectId : currentUserAvatarObj, withUserVar!.objectId!:withUserAvatarObj]
        
    }
    
    func avatarImageFromBackendlessUser(userPrm: BackendlessUser){
        
        if let imageLink = userPrm.getProperty("Avatar") {
            
            getImageFromURL(imageLink as! String, result: { (imagePrm) in
                
                let imageDataObj = UIImageJPEGRepresentation(imagePrm!, 1.0)
                
                
                if self.avatarImageMutDict != nil{
                    
                    self.avatarImageMutDict!.removeObjectForKey(userPrm.objectId)
                    self.avatarImageMutDict!.setObject(imageDataObj!, forKey: userPrm.objectId)
                    
                }else{
                    self.avatarImageMutDict = [userPrm.objectId! : imageDataObj!]
                }
                self.createAvatarFunc(self.avatarImageMutDict)
                
            })
            
            
        }
        
        
    }
    
    
    
    
    
    //MARK: UIIMagePicker delegate funcs
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let pictureInfo = info[UIImagePickerControllerEditedImage] as! UIImage

        // callBack sendMessage
        
        self.sendMessageFunc(nil, datePrm: NSDate(), picturePrm: pictureInfo, locationPrm: nil)
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: JSQ Delegates
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        
        let object = objectsArray[indexPath.row]
        
        if object["type"] as! String == "picture" {
            
            let msgObj = messagesArray[indexPath.row]
            let mediaItemobj = msgObj.media as! JSQPhotoMediaItem
            let photos = IDMPhoto.photosWithImages([mediaItemobj.image!])
            let browserObj = IDMPhotoBrowser(photos:photos)
            
        self.presentViewController(browserObj, animated: true, completion: nil)
            
        }
            
        
        if object["type"] as! String == "location" {
            self.performSegueWithIdentifier("chatToMap", sender: indexPath)
        }
        
        
        
    }
    
    //MARK: JSQCollectionView Delegates
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        if indexPath.item % 3 == 0 {
            let mesgObj = messagesArray[indexPath.row]
            
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(mesgObj.date)
        }
        
        return nil
        
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if indexPath.item % 3 == 0 {
            
            return kJSQMessagesCollectionViewCellLabelHeightDefault
            
        }
        return 0.0
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let msgObj = objectsArray[indexPath.row]
        
        let statusObj = msgObj["status"] as! String
        
        
        if indexPath.row == (messagesArray.count - 1){
            
            return NSAttributedString(string: statusObj)
        }else{
            return NSAttributedString(string: "")
        }

    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        
        
        if outgoingMessageFunc(objectsArray[indexPath.row])  {
            //            return kJSQMessageCollectionViewCellLabelHeightDefault
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }else{
            return 0.0
        }
        
    }
    
    
    
    
    
   
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "chatToMap" {
            let indexPath = sender as! NSIndexPath
            let messageobj = messagesArray[indexPath.row]
        let mediaItem = messageobj.media as! JSQLocationMediaItem
            
            let mapViewObj = segue.destinationViewController as! MapViewController
            mapViewObj.locationMapObj = mediaItem.location
            
        }
        
        
        
        
        
        
    }
   

    
    
    
    
    
}
