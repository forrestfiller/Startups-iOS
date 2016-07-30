//
//  ViewController.swift
//  Startups-iOS
//
//  Created by Forrest Filler on 7/25/16.
//  Copyright © 2016 forrestfiller. All rights reserved.
//

import UIKit
import Alamofire

//let screenWidth = UIScreen.mainScreen().bounds.width
//let screenHeight = UIScreen.mainScreen().bounds.height



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var startupsTable:UITableView!
    var startupsList = Array<Startup>()
    var viewStartupLabel = "Startup List"
    var startupVc = Startup()

    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func loadView() {
        
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        self.view = view
        
        startupsTable = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        startupsTable.delegate = self
        startupsTable.dataSource = self
        self.view.addSubview(startupsTable)

       

    }
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
        

//        notificationCtr.addObserver(
//            self,
//            selector:#selector(ViewController.imageDownloadNotification),
//            name: "StartupLoaded",
//            object: nil
//        )

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
        let nc = UINavigationController(rootViewController: createStartupVc)
        self.presentViewController(nc, animated: true, completion: nil)
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
            cell.detailTextLabel?.text = "Founder: "+startup.founder!

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
    
    func handlePackageFromCreateVc(startupInfo: Dictionary<String, AnyObject>){
        print("handlePackageFromCreateVc: \(startupInfo)")
        
        if let newCreateName = startupInfo["name"] as? String{
            let startup = Startup()
            startup.name = newCreateName
            self.startupsList.append(startup)
            self.startupsTable.reloadData()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
//        print("didFinishPickingMediaWithInfo: \(info)")
//        
//        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            let image = ISImage()
//            image.image = selectedImage
//            image.caption = "Default Caption"
//            self.imagesArray.append(image)
//            self.imagesTable.reloadData()
//            picker.dismissViewControllerAnimated(true, completion: nil)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        
        let startup = self.startupsList[indexPath.row]
        let detailVC = DetailStartupViewController()
        detailVC.startup = startup
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
