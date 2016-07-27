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
        
        self.startupImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.startupImage.image = self.startup.imageData
        self.startupImage.center = CGPoint(x: 0.5*frame.size.width, y: 160)
        view.addSubview(self.startupImage)
        
        var y = self.startupImage.frame.origin.y+self.startupImage.frame.size.height+20
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
        
        self.imageTextField = UITextField(frame: CGRect(x: 20, y: y, width: frame.size.width-40, height: 32))
        self.imageTextField.delegate = self
        self.imageTextField.placeholder = "image name"
        self.imageTextField.borderStyle = .RoundedRect
        self.imageTextField.autocapitalizationType = .None
        self.imageTextField.autocorrectionType = .No
        view.addSubview(self.imageTextField)
        y += self.imageTextField.frame.size.height+5
        
        self.sharesTextField = UITextField(frame: CGRect(x: 20, y: y, width: frame.size.width-40, height: 32))
        self.sharesTextField.delegate = self
        self.sharesTextField.placeholder = "shares in millions"
        self.sharesTextField.borderStyle = .RoundedRect
        self.sharesTextField.autocapitalizationType = .None
        self.sharesTextField.autocorrectionType = .No
        view.addSubview(self.sharesTextField)
        y += self.sharesTextField.frame.size.height+20
        
        self.btnSubmit = UIButton(type: .Custom)
        self.btnSubmit.backgroundColor = .blueColor()
        self.btnSubmit.frame = CGRect(x: 20, y: y, width: frame.size.width-40, height: 44)
        self.btnSubmit.setTitle("Update Startup Info", forState: .Normal)
        self.btnSubmit.setTitleColor(.whiteColor(), forState: .Normal)
        self.btnSubmit.addTarget(self, action: #selector(DetailStartupViewController.updateStartup), forControlEvents: .TouchUpInside)
        self.btnSubmit.addTarget(self, action: #selector(DetailStartupViewController.popBack), forControlEvents: .TouchUpInside)
        view.addSubview(self.btnSubmit)
        self.view = view
    }
    
    func updateStartup() {
        // prepare the package to send to backend, where JSON will update.
        
        var startupInfo = Dictionary<String, AnyObject>()
        startupInfo["_id"] = self.startup._id!
        startupInfo["name"] = self.nameTextField.text!
        startupInfo["city"] = self.cityTextField.text!
        startupInfo["founder"] = self.founderTextField.text!
        startupInfo["image"] = self.imageTextField.text!
//        startupInfo["shares"] = self.sharesTextField.text!

        print("updateStartup: \(startupInfo.description)")
        let url = "https://ff-startups.herokuapp.com/api/startup/"+self.startup._id!
        Alamofire.request(.PUT, url, parameters: startupInfo).responseJSON { response in
            // startupInfo is the package.
            if let json = response.result.value as? Dictionary<String, AnyObject>{
                print("\(json)")
            }
        }
    }
    
    func popBack() {
//  This func to push back to the Vc
        let initialVc = ViewController()
        self.navigationController?.pushViewController(self.initialVc, animated: true)
        
//        self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as UIViewController, animated: true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.startup.name

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
//        imageTextField.resignFirstResponder()
//        let searchText = self.imageTextField.text!
//        print("textFieldShouldReturn: \(searchText)")
//        let startup = Startup()
//        startup.fetchImage()
//        self.startupsList.removeAll()
        return true
    }
    


}
