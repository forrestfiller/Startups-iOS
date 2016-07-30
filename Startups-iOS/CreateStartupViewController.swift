//
//  CreateStartupViewController.swift
//  Startups-iOS
//
//  Created by Forrest Filler on 7/27/16.
//  Copyright © 2016 forrestfiller. All rights reserved.
//          To Dos
//      1. add all required fields
//      2. hook it up to backend [make a post request]
//      3. then dismiss the Vc and head back to the intital vc
//      4. load in the new data
import UIKit
import Alamofire

class CreateStartupViewController: UIViewController, UITextFieldDelegate {
    
    var startup: Startup!
    let initialVc = ViewController()
    var startupsList = Array<Startup>()
    var startupImage: UIImageView!
    
    var nameTextField: UITextField!
    var cityTextField: UITextField!
    var founderTextField: UITextField!
    var imageTextField: UITextField!
    var sharesTextField: UITextField!
    var btnSubmit: UIButton!

    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .lightGrayColor()
        
        var y = frame.origin.y+84
        self.nameTextField = UITextField(frame: CGRect(x: 20, y: y, width: frame.size.width-40, height: 32))
        self.nameTextField.delegate = self
        self.nameTextField.placeholder = "startup name"
        self.nameTextField.borderStyle = .RoundedRect
        self.nameTextField.autocapitalizationType = .None
        self.nameTextField.autocorrectionType = .No
        view.addSubview(self.nameTextField)
        y += self.nameTextField.frame.size.height+5
        
        self.cityTextField = UITextField(frame: CGRect(x: 20, y: y, width: frame.size.width-40, height: 32))
        self.cityTextField.delegate = self
        self.cityTextField.placeholder = "city name"
        self.cityTextField.borderStyle = .RoundedRect
        self.cityTextField.autocapitalizationType = .None
        self.cityTextField.autocorrectionType = .No
        view.addSubview(self.cityTextField)
        y += self.cityTextField.frame.size.height+5
        
        self.founderTextField = UITextField(frame: CGRect(x: 20, y: y, width: frame.size.width-40, height: 32))
        self.founderTextField.delegate = self
        self.founderTextField.placeholder = "founder name"
        self.founderTextField.borderStyle = .RoundedRect
        self.founderTextField.autocapitalizationType = .None
        self.founderTextField.autocorrectionType = .No
        view.addSubview(self.founderTextField)
        y += self.founderTextField.frame.size.height+5
        
        self.sharesTextField = UITextField(frame: CGRect(x: 20, y: y, width: frame.size.width-40, height: 32))
        self.sharesTextField.delegate = self
        self.sharesTextField.placeholder = "shares in millions"
        self.sharesTextField.borderStyle = .RoundedRect
        self.sharesTextField.autocapitalizationType = .None
        self.sharesTextField.autocorrectionType = .No
        view.addSubview(self.sharesTextField)
        y += self.sharesTextField.frame.size.height+5


        self.btnSubmit = UIButton(type: .Custom)
        self.btnSubmit.backgroundColor = .blueColor()
        self.btnSubmit.frame = CGRect(x: 20, y: y+40, width: frame.size.width-40, height: 44)
        self.btnSubmit.setTitle("Create Startup", forState: .Normal)
        self.btnSubmit.setTitleColor(.whiteColor(), forState: .Normal)
        self.btnSubmit.addTarget(self, action: #selector(CreateStartupViewController.createStartup), forControlEvents: .TouchUpInside)
        view.addSubview(self.btnSubmit)
        self.view = view
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        //print("textFieldShouldReturn")
        self.createStartup()
        return true
    }
    
    func createStartup() { // prepare the package to send to backend, where JSON will update.
        //print("createStartup: ")
        var startupInfo = Dictionary<String, AnyObject>()
        startupInfo["name"] = self.nameTextField.text!
        startupInfo["city"] = self.cityTextField.text!
        startupInfo["founder"] = self.founderTextField.text!
        startupInfo["shares"] = self.sharesTextField.text!
        //startupInfo["image"] = self.imageTextField.text!
        

       //print("createStartup - package prepped: \(startupInfo.description)")
        
        let url = "https://ff-startups.herokuapp.com/api/startup/"
        Alamofire.request(.POST, url, parameters: startupInfo).responseJSON { response in
            // startupInfo is the package.
            //print("sending the package via Alamofire call 1 of 4")
            if let json = response.result.value as? Dictionary<String, AnyObject>{
                //print("sending the package via Alamofire call 2 of 4")
                if let result = json["result"] as? Dictionary<String, AnyObject>{
                    //print("3 of 4: \(json)")
                    
                    // HERE IS THE ISSUE --> need to handle this. No print call for populate.
                    //self.startup.populate(result)
                    self.startup.populate(result)
                    print("populate??")
                    //self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}
