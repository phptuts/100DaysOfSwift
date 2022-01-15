//
//  ViewController.swift
//  Project18
//
//  Created by Noah Glaser on 1/13/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(1,2,3,4,5)
        // Do any additional setup after loading the view.
        print("I'm inside the viewDidLoad method.")
        print(1,2,3,4,5, separator: "-")
        print("Some message", terminator: "")
        print("AGAIN")
        
        
        assert(1 == 1, "Math Failure")
//        assert(1 == 2, "Math Failure")
        
        for i in 1...100 {
            print("Got number \(i).")
        }
        
    }


}

