//
//  LoginViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 18-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    let backEndShrdInstacnce = Backendless.sharedInstance()
    
    var emailLVCobj: String?
    var passwdLVCobj: String?
    
    
    
    @IBOutlet weak var loginTxtFld: UITextField!
    
    @IBOutlet weak var passwordTtFld: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func btnLogin(sender: UIBarButtonItem) {
        if loginTxtFld.text != "" && passwordTtFld.text != ""
        {
            
            self.emailLVCobj = loginTxtFld.text
            self.passwdLVCobj = passwordTtFld.text
            
            loginUserToBackendless(emailLVCobj!, passwdPrm: passwdLVCobj!)
            
            
        }else{
            //alert
            //Alert to user inside any action or verification part
            dispatch_async(dispatch_get_main_queue(), {
                
                self.displayAlert("Missing Field(s)", MessageTxt: "Email and Password requiered")
                
            })

            
        }
        
    }
    
    //MARK: LoginUsr to the Backendless
    func loginUserToBackendless(emailPrm: String, passwdPrm : String) {
        
        backEndShrdInstacnce.userService.login(emailPrm, password: passwdPrm, response: { (user: BackendlessUser!) in
            
            self.loginTxtFld.text = ""
            self.passwordTtFld.text = ""
            
            print("Logged in")
            //segue to Recent Vc
            
            let storyboardID = UIStoryboard(name: "Main", bundle: nil)
            let chatVC = storyboardID.instantiateViewControllerWithIdentifier("ChatTabBar") as! UITabBarController
            
            self.presentViewController(chatVC, animated: true, completion: nil)
            
        }) { (fault: Fault!) in
            
            print("Login to Backendless error\(fault)")
        }
        
        
        
        
    }
    
    
    //MARK:  Alert
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
    
    
    

    
    
    
}
