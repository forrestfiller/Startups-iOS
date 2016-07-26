//
//  DetailStartupViewController.swift
//  Startups-iOS
//
//  Created by Forrest Filler on 7/25/16.
//  Copyright © 2016 forrestfiller. All rights reserved.
//

import UIKit
import Alamofire

class DetailStartupViewController: UIViewController, UITextFieldDelegate {
    
    var startup: Startup!
    var startupsList = Array<Startup>()
    var startupImage: UIImageView!
    var imageTextField: UITextField!
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .lightGrayColor()
        
        self.startupImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.startupImage.image = self.startup.imageData
        self.startupImage.center = CGPoint(x: 0.5*frame.size.width, y: 160)
        view.addSubview(self.startupImage)
        
        var y = self.startupImage.frame.origin.y+self.startupImage.frame.size.height+20
        self.imageTextField = UITextField(frame: CGRect(x: 20, y: y, width: frame.size.width-40, height: 32))
        self.imageTextField.delegate = self
        self.imageTextField.placeholder = "image name"
        self.imageTextField.borderStyle = .RoundedRect
        self.imageTextField.autocapitalizationType = .None
        self.imageTextField.autocorrectionType = .No
        view.addSubview(self.imageTextField)
        y += self.imageTextField.frame.size.height+20
        
        let btnSubmit = UIButton(type: .Custom)
        btnSubmit.backgroundColor = .blueColor()
        btnSubmit.frame = CGRect(x: 20, y: y, width: frame.size.width-40, height: 44)
        btnSubmit.setTitle("Update Image", forState: .Normal)
        btnSubmit.setTitleColor(.whiteColor(), forState: .Normal)
        btnSubmit.addTarget(self, action: #selector(DetailStartupViewController.updateStartup), forControlEvents: .TouchUpInside)
        view.addSubview(btnSubmit)

        
        self.view = view
    }
    
    func updateStartup() {
        // preparinga  package of info to send ot the server, and will make a correcsponsing update
        var startupInfo = Dictionary<String, AnyObject>()
        startupInfo["_id"] = self.startup._id!
        startupInfo["image"] = self.imageTextField.text!
        
        print(" \(startupInfo.description)")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.startup.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        imageTextField.resignFirstResponder()
        let searchText = self.imageTextField.text!
        print("textFieldShouldReturn: \(searchText)")
//        let startup = Startup()
//        startup.fetchImage()
//        self.startupsList.removeAll()
        return true
    }
    


}
