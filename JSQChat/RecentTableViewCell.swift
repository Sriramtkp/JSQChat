//
//  RecentTableViewCell.swift
//  JSQChat
//
//  Created by Sriram Rajendran on 19-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
    let backendShardInstance = Backendless.sharedInstance()
    
    
    
    @IBOutlet weak var avatarImageCell: UIImageView!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var counterLabel: UILabel!
    
       override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

      func bindDataFromCell(recentFromCell: NSDictionary) {
        
        self.avatarImageCell.layer.cornerRadius = self.avatarImageCell.frame.size.width/2
        self.avatarImageCell.layer.masksToBounds = true
        
        self.avatarImageCell.image = UIImage(named: "avatarPlaceholder")
        
        //run a query to avatar details from Backendless
        
        let withUserID = (recentFromCell.objectForKey("withUserUserID") as? String)!
        
        // get the user's avatar
        let whereClauseObj = "objectID = '\(withUserID)"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClauseObj
        let dataStoreObj = backendShardInstance.persistenceService.of(BackendlessUser.ofClass())
        dataStoreObj.find(dataQuery, response: { (users: BackendlessCollection!) in
            
            let withUserObj = users.data.first as! BackendlessUser
            //here withUserObj is to get get Avatar of the users 
            
            
        }) { (fault: Fault!) in
            
            print(".....Faults;;;;\(fault)")
        }
        
        nameLabel.text = recentFromCell["withUserUsername"] as? String
        lastMessageLabel.text = recentFromCell["lastMessage"] as? String
        
        counterLabel.text = ""
        
        if (recentFromCell["counter"] as? Int)! != 0 {
            counterLabel.text = "\(recentFromCell["counter"])!"
        }
        
        //date
        
        let dateObj = dateFormateFunc().dateFromString((recentFromCell["date"] as? String)!)
        let secondsObj = NSDate().timeIntervalSinceDate(dateObj!)
        
        
        timerLabel.text = timeElapsed(secondsObj)
        
    }
    
    //MARK: date,time,seconds
    func timeElapsed(seconds: NSTimeInterval) -> String {
        var elapsedStr : String?
        
        if (seconds < 60) {
            elapsedStr = "Just now"
        }
        else if (seconds < 60 * 60){
            let minutes = Int(seconds / 60)
            var minText = "min"
            
            if minutes > 1 {
                minText = "mins"
            }
            elapsedStr = "\(minutes) \(minText)"
        }
        else if (seconds < 24 * 60 * 60){
            let hours = Int(seconds / 60 * 60)
            var hoursText = "hour"
            
            if hours > 1 {
                hoursText = "hours"
            }
            elapsedStr = "\(hours) \(hoursText)"
        }
        else {
            let day = Int(seconds / 24 * 60 * 60)
            var dayText = "hour"
            
            if day > 1 {
                dayText = "hours"
            }
            elapsedStr = "\(day) \(dayText)"
        }

    return elapsedStr!
    }
    
    
}
