//
//  RegisterViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 18-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var userNameTxtFld: UITextField!
    
    
    var backendShrdInstance = Backendless.sharedInstance()
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
            
            registerToBckendless(self.emailObj!, userNamePrm: self.userNameObj!, passwdPrm: self.passwordObj!, avatarImagePrm:self.avatarImgObj)
        }else{
            
            //Alert to user
            dispatch_async(dispatch_get_main_queue(), {
                
                self.displayAlert("Missing Field(s)", MessageTxt: "Username, Email and Password requiered")
                
            })

        }
//    end of btnRegister
     }
    
    
    //MARK: Backendless registration func
    
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
    
    //MARK: Login func
    func loginUser (emailLoginPrm: String, usernameLoginPrm: String, passwdLoginPrm:String  ) {
        
        backendShrdInstance.userService.login(emailObj, password: passwordObj
            , response: { (users: BackendlessUser!) in
                
                //segure to Recent VC
                
                
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
    
    
    
    
    
    
    
//MARK: end of RegisterViewController
}
