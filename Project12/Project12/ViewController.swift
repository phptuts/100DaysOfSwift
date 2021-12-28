//
//  ViewController.swift
//  Project12
//
//  Created by Noah Glaser on 12/28/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        defaults.set(25, forKey: "age")
        defaults.set(true, forKey: "UseFaceId")
        
        defaults.set("Paul", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        
        let array = ["Hello"]
        defaults.set(array, forKey: "array")
        let saveInteger = defaults.integer(forKey: "age")
        let saveBool = defaults.bool(forKey: "UseFaceId")
        
        let list = defaults.object(forKey: "array") as? [String] ?? [String]()
        print(list)
    }


}

