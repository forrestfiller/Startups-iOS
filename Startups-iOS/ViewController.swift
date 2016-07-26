//
//  ViewController.swift
//  Startups-iOS
//
//  Created by Forrest Filler on 7/25/16.
//  Copyright © 2016 forrestfiller. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var startupsTable: UITableView!
    var startupsList = Array<Startup>()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up a listener:
        let notificationCtr = NSNotificationCenter.defaultCenter()
        notificationCtr.addObserver(
            self,
            selector:#selector(ViewController.imageDownloadNotification),
            name: "ImageDownloaded",
            object: nil
        )
        
        
        //self.navigationController?.navigationBar.barTintColor = .lightGrayColor()
        
        let url = "https://ff-startups.herokuapp.com/api/startup"
        Alamofire.request(.GET, url, parameters:  nil).responseJSON { response in
            if let json = response.result.value as? Dictionary<String, AnyObject>{
                
                if let results = json["results"] as? Array<Dictionary<String, AnyObject>>{

                    for startupInfo in results {
                        let startup = Startup()
                        startup.populate(startupInfo)
                        self.startupsList.append(startup)
                        
                    }
                    self.startupsTable.reloadData()
                }
            
            }
            
        }

    }
    
    func imageDownloadNotification(){
        self.startupsTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.startupsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let startup = self.startupsList[indexPath.row]
        let cellId = "cellId"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId){
            cell.textLabel?.text = startup.name
            cell.detailTextLabel?.text = startup.city
            if (startup.imageData != nil){
                cell.imageView?.image = startup.imageData
                return cell
            }
            startup.fetchImage()
            return cell
        }
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = startup.name
        cell.detailTextLabel?.text = startup.city
        if (startup.imageData != nil){
            cell.imageView?.image = startup.imageData
            return cell
        }
        startup.fetchImage()
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        
        let startup = self.startupsList[indexPath.row]
        let detailVc = DetailStartupViewController()
        detailVc.startup = startup
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    

    
    
    
    

    
    // Fin.
}




