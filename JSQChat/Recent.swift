//
//  Recent.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 20-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import Foundation

//var firRefObj: FIRDatabaseReference!

//let firebaseUrl = Firebase(url : "https://jsqchat-96901.firebaseio.com/")
//firRefObj = FIRDatabase.database().reference()

let backendObj = Backendless.sharedInstance()
let currenntUserObj = backendObj.userService.currentUser


// Mark : Hekper func only

private let dateFormateObj = "yyMMddHHmmss"

func dateFormateFunc() -> NSDateFormatter {
    
    let dateFromatterObj = NSDateFormatter()
    dateFromatterObj.dateFormat = dateFormateObj
    
    return dateFromatterObj
    
}