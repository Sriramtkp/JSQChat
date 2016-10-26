//
//  Camera.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 25-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import Foundation
import MobileCoreServices

class Camera  {
    
    class func PresentPhotoLibrary(target : ChatViewController, canEdit: Bool)  {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            
            return
        }
        
         let type = kUTTypeImage as String
        let imagePickerObj = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            imagePickerObj.sourceType = .PhotoLibrary
            
            if let availabelType = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary){
                
                if (availabelType as NSArray).containsObject(type) {
                    
                    imagePickerObj.allowsEditing = canEdit
                    imagePickerObj.mediaTypes = [type]
                    
                }
                
            }
            
            
        }else if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum){
            
            imagePickerObj.sourceType = .SavedPhotosAlbum
            if let availableType = UIImagePickerController.availableMediaTypesForSourceType(.SavedPhotosAlbum){
                
                if (availableType as NSArray).containsObject(type) {
                    imagePickerObj.mediaTypes = [type]
//                    imagePickerObj.allowsEditing = canEdit
                }
            }
            
            
        }else{
            return
        }
        
        
        imagePickerObj.allowsEditing = canEdit
        imagePickerObj.delegate = target
        target.presentViewController(imagePickerObj, animated: true, completion: nil)
            }
    
    
    class func PresentPhotoCamera(target: ChatViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            return
        }
        
        let typeCamera = kUTTypeImage as String
        let imagePickerCameraObj = UIImagePickerController()
       
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            if let availableCemaraType = UIImagePickerController.availableMediaTypesForSourceType(.Camera){
                if (availableCemaraType as NSArray).containsObject(typeCamera) {
                    
                    imagePickerCameraObj.mediaTypes = [typeCamera]
                    imagePickerCameraObj.sourceType = UIImagePickerControllerSourceType.Camera
                }
            }
        
            if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
                imagePickerCameraObj.cameraDevice = UIImagePickerControllerCameraDevice.Rear
                
            }else if UIImagePickerController.isCameraDeviceAvailable(.Front){
                
                imagePickerCameraObj.cameraDevice = UIImagePickerControllerCameraDevice.Front
            }
        
        }
        else {
            //show alert to cemara
            return
        }
        
        imagePickerCameraObj.allowsEditing = canEdit
        imagePickerCameraObj.delegate = target
        target.presentViewController(imagePickerCameraObj, animated: true, completion: nil)
        
        
    }
    
    
//end of Camera
}