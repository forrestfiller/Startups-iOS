//
//  ChangeStartupViewController.swift
//  Startups-iOS
//
//  Created by Forrest Filler on 7/26/16.
//  Copyright © 2016 forrestfiller. All rights reserved.
//

import UIKit

class ChangeStartupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .redColor()
        
        self.view = view
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    
    
    
}
