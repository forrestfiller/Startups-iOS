//
//  CreateStartupViewController.swift
//  Startups-iOS
//
//  Created by Forrest Filler on 7/27/16.
//  Copyright © 2016 forrestfiller. All rights reserved.
//

import UIKit
import Alamofire

class CreateStartupViewController: UIViewController, UITextFieldDelegate {
    
    var startup = Startup()
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
        self.createStartup()
        return true
    }
    
    func createStartup() { // prepare package to send to backend
        var startupInfo = Dictionary<String, AnyObject>()
        startupInfo["name"] = self.nameTextField.text!
        startupInfo["city"] = self.cityTextField.text!
        startupInfo["founder"] = self.founderTextField.text!
        startupInfo["shares"] = self.sharesTextField.text!
        //startupInfo["image"] = self.imageTextField.text!
        
        let url = "https://ff-startups.herokuapp.com/api/startup/"
        Alamofire.request(.POST, url, parameters: startupInfo).responseJSON { response in

            if let json = response.result.value as? Dictionary<String, AnyObject>{

                if let result = json["result"] as? Dictionary<String, AnyObject>{

                    self.startup.populate(result)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Startup"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: #selector(CreateStartupViewController.cancelAndDismissThisVC)
        )
    }

    func cancelAndDismissThisVC() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
