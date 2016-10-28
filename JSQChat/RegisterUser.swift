//
//  RegisterUser.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 27-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import Foundation

func registerUserDeviceID() {
    
    if backendShrdInstance.messagingService.getRegistration().deviceId != nil {
        
        let deviceID = backendShrdInstance.messagingService.getRegistration().deviceId
        let propertiesDict = ["deviceID":deviceID]
        backendShrdInstance.userService.currentUser!.updateProperties(propertiesDict)
        backendShrdInstance.userService.update(backendShrdInstance.userService.currentUser)
    }
    
}


func updateBackendlessUser(userDeviceID: String, avatarURL: String)  {
    
    var properties: [String : String]!
    
    if backendShrdInstance.messagingService.getRegistration().deviceId != nil {
        
        let deviceID = backendShrdInstance.messagingService.getRegistration().deviceId

        properties = ["Avatar": avatarURL, "deviceId": deviceID]
    }else{
        properties = ["Avatar":avatarURL]
    }
    
    backendShrdInstance.userService.currentUser.updateProperties(properties)
    backendShrdInstance.userService.update(backendShrdInstance.userService.currentUser, response: { (updatedUser: BackendlessUser!) in
        print("updated---updateBackendlessUser\(updatedUser)")
    }) { (fault: Fault!) in
            print("error in updateBackendlessUser \(fault)")
    }
    
   }

//MARK:
func removeUserDeviceID() {
    let  properties = ["deviceId": ""]
    backendShrdInstance.userService.currentUser!.updateProperties(properties)
    backendShrdInstance.userService.update(backendShrdInstance.userService.currentUser)
    
}






















