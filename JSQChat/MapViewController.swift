//
//  MapViewController.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 26-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit


class MapViewController: UIViewController {

    @IBOutlet weak var mapOutlet: MKMapView!
    
    var locationMapObj: CLLocation!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var regionObj = MKCoordinateRegion()
        regionObj.center.latitude = locationMapObj.coordinate.latitude
        regionObj.center.longitude = locationMapObj.coordinate.longitude
        regionObj.span.latitudeDelta = 0.01
        regionObj.span.longitudeDelta = 0.01
        mapOutlet.setRegion(regionObj, animated: true)
        
        let annotaionObj = MKPointAnnotation()
        mapOutlet.addAnnotation(annotaionObj)
        annotaionObj.coordinate = locationMapObj.coordinate
    
    
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
     @IBAction func cancelBtnPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
