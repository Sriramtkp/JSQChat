//
//  Avatar.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 26-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import Foundation

func uploadAvatar( image: UIImage, result:(imageLink: String? ) ->Void ) {
    
    
    let imageData = UIImageJPEGRepresentation(image, 1.0)
    
    let dateStr = dateFormateFunc().stringFromDate(NSDate())
    
    let fileName = "Img" + dateStr + ".jpeg"
    
   backendShrdInstance.fileService.upload(fileName, content: imageData, response: { (file) in
    //success
    
    result(imageLink: file.fileURL)
    
   }) { (fault: Fault!) in
        print("error in uploadAvatar--\(fault)")
    }
    
}

//MARK: getImage

func getImageFromURL(urlPrm: String, result:(imageLink: UIImage? ) ->Void ) {
    
    let urlVar = NSURL(string: urlPrm)
    
    let downloadQueue = dispatch_queue_create("imageDownloadQue", nil)
    
    dispatch_async(downloadQueue) {
        
        let data = NSData(contentsOfURL: urlVar!)
        let imageVarData: UIImage!
        if data != nil{
            imageVarData = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                result(imageLink: imageVarData)
                
            }
        }
        
        
    }
    
}
















