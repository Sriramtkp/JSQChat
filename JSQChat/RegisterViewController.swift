//
//  RegisterViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 18-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var userNameTxtFld: UITextField!
    
    
//    var backendShrdInstance = Backendless.sharedInstance()
    var newUserObj: BackendlessUser?
    
    
    var emailObj: String?
    var userNameObj: String?
    var passwordObj: String?
    var avatarImgObj: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        newUserObj = BackendlessUser()
   
        
        // end of viewDidLoad
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func btnRegister(sender: UIButton) {
        
        if  emailTxtFld.text != "" && passwordTxtFld.text != "" && userNameTxtFld.text != ""
        {
         emailObj = emailTxtFld.text
        passwordObj = passwordTxtFld.text
            userNameObj = userNameTxtFld.text
            
            // callBack  registerToBckendless
            registerToBackendless(self.emailObj!, username: self.userNameObj!, password: self.passwordObj!, avatarImage:self.avatarImgObj)
        }else{
            
            //Alert to user
            dispatch_async(dispatch_get_main_queue(), {
                
                self.displayAlert("Missing Field(s)", MessageTxt: "Username, Email and Password requiered")
                
            })

        }
//    end of btnRegister
     }
    
    
    //MARK: Backendless registration func
   /*
    func registerToBckendless(emailPrm: String, userNamePrm: String, passwdPrm: String, avatarImagePrm: UIImage?)  {
        
        if avatarImagePrm == nil {
            
            newUserObj?.setProperty("Avatar", object: "")
                 }
        
        newUserObj?.email = emailPrm
        newUserObj?.password = passwdPrm
        newUserObj?.name = userNamePrm
        
        //register the newUser
        backendShrdInstance.userService.registering(newUserObj, response: { (registeredUser : BackendlessUser!) in
            
            //callBack loginUser
            self.loginUser(self.emailObj!, usernameLoginPrm: self.userNameObj!, passwdLoginPrm: self.passwordObj!)
            
            //empty the textFields
             self.userNameTxtFld.text = ""
            self.emailTxtFld.text = ""
            self.passwordTxtFld.text = ""
            
            
            
        }) { (fault: Fault!) in
            
            print("Error in registering newUser\(fault)")
        }
        
    }
    */
    //MARK: Login func
    func loginUser (emailLoginPrm: String, usernameLoginPrm: String, passwdLoginPrm:String  ) {
        
        backendShrdInstance.userService.login(emailObj, password: passwordObj
            , response: { (users: BackendlessUser!) in
               
                
                registerUserDeviceID()
                
                
                //segure to Recent VC
                
        let storyboardID = UIStoryboard(name: "Main", bundle: nil)
    let chatVC = storyboardID.instantiateViewControllerWithIdentifier("ChatTabBar") as! UITabBarController
        
                self.presentViewController(chatVC, animated: true, completion: nil)
                
                
        }) { (fault: Fault!) in
            
            print("Server error in loginUser \(fault)")
            
        }
        
        
    }
    
    
    
    
    
   //MARK: UIAlert
func displayAlert(titleMsg: String, MessageTxt: String) {
    
    let alert = UIAlertController(title: titleMsg , message: MessageTxt , preferredStyle: .Alert)
    
    let saveAction = UIAlertAction(title: "Ok", style: .Default) {
      (action: UIAlertAction) -> Void in
      
    }
let cancelAction = UIAlertAction(title: "Cancel", style: .Default){
      (action: UIAlertAction) -> Void in
    }

    alert.addAction(saveAction)
alert.addAction(cancelAction)
    alert.view.setNeedsLayout()
    
    presentViewController(alert, animated: true, completion: nil)
    
  }
    
    
    //MARK: CameraBtn
    @IBAction func uploadPhotoCameraBtn(sender: UIBarButtonItem) {
        
        
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
    
    //MARK: imagePicker Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.avatarImgObj = (info[UIImagePickerControllerEditedImage] as! UIImage)
    picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Backendless user registration
    
    func registerToBackendless(email: String, username: String, password: String, avatarImage:UIImage?) {
        
        if avatarImage == nil{
            newUserObj!.setProperty("Avatar", object: "")
        }else{
            
            uploadAvatar(avatarImage!, result: { (imageLink) in
                
                let properties = ["Avatar" : imageLink!]
                
                backendShrdInstance.userService.currentUser.updateProperties(properties)
     backendShrdInstance.userService.update(backendShrdInstance.userService.currentUser, response: { (updatedUser) in
                    
                    }, error: { (fault: Fault!) in
                        print("error in uploadAvatar\(fault)")
                })
        })
            
        }
        
        
        newUserObj?.email = email
        newUserObj?.name = username
        newUserObj?.password = password
        
        backendShrdInstance.userService.registering(newUserObj, response: { (registeredUser: BackendlessUser!) in
            
//            ProgressHUD.dismiss()
//            ProgressHUD.dismiss()
            
            
            //login new user
            self.loginUser(email, usernameLoginPrm: username, passwdLoginPrm: password)
            
            self.emailTxtFld.text = ""
            self.userNameTxtFld.text = ""
            self.passwordTxtFld.text = ""
            
            
        }) { (fault:Fault!) in
                print("error in registerToBackendless \(fault)")
        }
        
    }
    
    
//MARK: end of RegisterViewController
}

















