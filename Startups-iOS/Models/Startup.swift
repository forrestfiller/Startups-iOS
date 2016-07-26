//
//  Startup.swift
//  Startups-iOS
//
//  Created by Forrest Filler on 7/25/16.
//  Copyright © 2016 forrestfiller. All rights reserved.
//

import UIKit
import Alamofire

class Startup: NSObject {
    var _id: String?
    var name: String?
    var city: String?
    var founder: String?
    var image: String?
    var shares: Int?
    var imageData: UIImage?
    var isFetching = false
    
    
    
    func populate(startupInfo: Dictionary<String, AnyObject>){
        //can use this only with your dbackend matches up perfectly with these variables
        // only do this is your backend is yours, as if your backend keys change you will have a fail.
        let props = [ "_id", "name", "city", "founder"] // image was taken out of the array
        for prop in props {
            let value = startupInfo[prop]
            self.setValue(value, forKey: prop)
        }
        
        if let _image = startupInfo["image"] as? String {
            if (_image.characters.count == 0){
                self.image = "placeholder.jpg"
            }
            else {
                self.image = _image
            }
        }
    }
    
    func fetchImage(){
        if (self.isFetching == true){
            return
        }
        self.isFetching = true
        
        let url = "https://ff-startups.herokuapp.com/images/"+self.image!
        Alamofire.request(.GET, url, parameters: nil).response { (req, res, data, error) in
            self.isFetching = false
            
            if (error != nil){ // error, don't do anything
                return
            }
            
            if let img = UIImage(data: data!) { // success!
                self.imageData = img
                
                // do my NSnotificaiton here
                let notificationCtr = NSNotificationCenter.defaultCenter()
                let notification = NSNotification(name: "ImageDownloaded", object: nil)
                notificationCtr.postNotification(notification)
            }
        }
    }
}





