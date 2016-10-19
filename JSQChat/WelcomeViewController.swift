//
//  WelcomeViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 18-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    let backendShrdInstance = Backendless.sharedInstance()
    var currentUser: BackendlessUser?
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        backendShrdInstance.userService.setStayLoggedIn(true)
        currentUser = backendShrdInstance.userService.currentUser
        
        
        
        if currentUser != nil {
            
            dispatch_async(dispatch_get_main_queue(), {
             let storyboardID = UIStoryboard(name: "Main", bundle: nil)
            let chatVC = storyboardID.instantiateViewControllerWithIdentifier("ChatTabBar") as! UITabBarController
            chatVC.selectedIndex = 0
            self.presentViewController(chatVC, animated: true, completion: nil)
                
            })

        }
        
    }
    
    
    
    
    //Alert to user inside any action or verification part
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
