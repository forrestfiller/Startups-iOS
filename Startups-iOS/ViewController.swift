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
    var viewStartupLabel = "Startup List"
    var startupVc = Startup()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: #selector(ViewController.createStartup)
        )
        self.title = self.viewStartupLabel
        
        // set up a listener:
        let notificationCtr = NSNotificationCenter.defaultCenter()
        notificationCtr.addObserver(
            self,
            selector:#selector(ViewController.imageDownloadNotification),
            name: "ImageDownloaded",
            object: nil
        )

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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startupsTable.reloadData()
    }
    
    func createStartup() {
        print("createStartup: ")
        
        let createStartupVc = CreateStartupViewController()
        self.presentViewController(createStartupVc, animated: true, completion: nil)
//pop goes back; push is for forward and showing more information
//present is for creating something new; dismiss is when something comes from the top
// HIG human interface guidelines for programmers
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
            cell.textLabel?.text = startup.name!+"   "+startup.city!
            cell.detailTextLabel?.text = "Founder: "+startup.founder!+", "

            if (startup.imageData != nil){
                cell.imageView?.image = startup.imageData
                return cell
            }

            startup.fetchImage()
            return cell
//            
//            if case let (startup.shares) = String(startup.shares){
//                return cell
//            }
//            else {
//                String(startup.shares)
//                return cell
//            }
        }
        
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = startup.name!+"   "+startup.city!
        cell.detailTextLabel?.text = "Founder: "+startup.founder!+", "

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

}
