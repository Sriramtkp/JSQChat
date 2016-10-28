//
//  SettingsTableViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 26-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

     //MARK:outlets
    @IBOutlet weak var headerViewForTableView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imageViewUser: UIImageView!
    
    //MARK: cell outlets
    
    
    @IBOutlet weak var privacyCellOutlet: UITableViewCell!
    @IBOutlet weak var termsCellOutlet: UITableViewCell!
    @IBOutlet weak var avatarCellOutlet: UITableViewCell!
    @IBOutlet weak var logoutCellOutlet: UITableViewCell!
    
    @IBOutlet weak var avatarSwitch: UISwitch!
    
    var avatarSwitchStatus = true
    
    let userDefaultsObj = NSUserDefaults.standardUserDefaults()
    var apploadedFirstTime: Bool?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.tableView.tableHeaderView = headerViewForTableView
        self.imageViewUser.layer.cornerRadius = self.imageViewUser.frame.size.width/2
        self.imageViewUser.layer.masksToBounds = true
        
        loadUserDefaults()
        updateUI()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {return 3}
        if section == 1 {return 1}
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        if ((indexPath.section == 0) && (indexPath.row == 0)) {return privacyCellOutlet}
        if ((indexPath.section == 0) && (indexPath.row == 1)) {return termsCellOutlet}
        if ((indexPath.section == 0) && (indexPath.row == 2)) {return avatarCellOutlet}
        if ((indexPath.section == 1) && (indexPath.row == 0)) {return logoutCellOutlet}

        
        
        
        
        return UITableViewCell()
    }
 
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }else{
            return 25.0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    

    
    @IBAction func didClickAvatarImageBtn(sender: UIButton) {
        
        
        changeAvatarPhotoFunc()
    }
    
    //MARK: Change Avatar Photo
    func changeAvatarPhotoFunc() {
        
        let cameraObj = Camera(delegateProtocol_: self)
        
        
        
        let alert = UIAlertController(title: nil, message: nil , preferredStyle: .ActionSheet)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) {
            (action: UIAlertAction) -> Void in
            
            print("Take Photo")
            cameraObj.PresentPhotoCamera(self, canEdit: true)
            
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .Default) {
            (action: UIAlertAction) -> Void in
            
            print("Photo Library")
            cameraObj.PresentPhotoLibrary(self, canEdit: true)
            
        }        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action: UIAlertAction) -> Void in
            
            print("Cancel")
            
        }
        alert.addAction(takePhoto)
        alert.addAction(sharePhoto)
         alert.addAction(cancelButton)
        alert.view.setNeedsLayout()
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func avatarSwitchAction(switchState: UISwitch) {
        
        
        if switchState.on {
            
            avatarSwitchStatus = true
        }else{
            avatarSwitchStatus = false
        }
        //save userDefaults
        saveUserDefaults()
    }
    
    
    //MARK: UserDedaults
    
    func saveUserDefaults() {
        
        userDefaultsObj.setBool(avatarSwitchStatus, forKey: kAVATARSTATE)
        
        
        
    }
    
    func loadUserDefaults()  {
        
        apploadedFirstTime = userDefaultsObj.boolForKey(kFIRSTRUN)
        if !apploadedFirstTime! {
            userDefaultsObj.setBool(true, forKey: kFIRSTRUN)
            userDefaultsObj.setBool(avatarSwitchStatus, forKey: kAVATARSTATE)
        }
        
        avatarSwitchStatus = userDefaultsObj.boolForKey(kAVATARSTATE)
        
    }
    
    
    //MARK: UIImagePickerView Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
         let imageVar = info[UIImagePickerControllerEditedImage] as! UIImage
        uploadAvatar(imageVar) { (imageLink) in
            
            let propertiesVar = ["Avatar" : imageLink!]
            backendShrdInstance.userService.currentUser!.updateProperties(propertiesVar)
            
            backendShrdInstance.userService.update(backendShrdInstance.userService.currentUser, response: { (updateUser) in
                
                print("updateUser is \(updateUser)")
                
                }, error: { (fault: Fault!) in
                    print("error in imagePicker in SettinfTBVC \(fault)")
            })
            
            
        }
picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: updateUI
    
    func updateUI() {
        
        userNameLabel.text = backendShrdInstance.userService.currentUser.name
        avatarSwitch.setOn(avatarSwitchStatus, animated: false)
        
        if let imageLink = backendShrdInstance.userService.currentUser.getProperty("Avatar"){
            
            getImageFromURL(imageLink as! String, result: { (image) in
                
                self.imageViewUser.image = image
                
            })
            
            
        }
        
    }
    
    //MARK: didselectRow
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            showLogoutAlert()
        }
    }
    
    //MARK: Logout Alert and Func
    
    func showLogoutAlert() {
        
        let alert = UIAlertController(title: nil, message: nil , preferredStyle: .ActionSheet)
        
        let saveAction = UIAlertAction(title: "Logout", style: .Destructive) {
            (action: UIAlertAction) -> Void in
            //logoutFunc
            print("Logout btn pressed")
            self.logoutFunc()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){
            (action: UIAlertAction) -> Void in
            print("Cancel btn pressed")
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.view.setNeedsLayout()
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func logoutFunc()  {
        
        backendShrdInstance.userService.logout()
        //show it to the user
        // from ReisterUser
        removeUserDeviceID()

        let loginVC = storyboard!.instantiateViewControllerWithIdentifier("LoginViewNav")
        self.presentViewController(loginVC, animated: true, completion: nil)
        

        
    }
    
    
    


    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
