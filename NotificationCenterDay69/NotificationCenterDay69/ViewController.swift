//
//  ViewController.swift
//  NotificationCenterDay69
//
//  Created by Noah Glaser on 1/18/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var FibonacciLabel: UILabel!
    @IBOutlet var oddLabel: UILabel!
    @IBOutlet var evenLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    
    var notifier: NotificationCenter!
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notifier = NotificationCenter.default
        notifier.addObserver(self, selector: #selector(odd), name: Notification.Name("UpdateNumber"), object: nil)
        notifier.addObserver(self, selector: #selector(even), name: Notification.Name("UpdateNumber"), object: nil)

        notifier.addObserver(self, selector: #selector(fib), name: Notification.Name("UpdateNumber"), object: nil)
        
        notifier.addObserver(self, selector: #selector(num), name: Notification.Name("UpdateNumber"), object: nil )

        notifier.post(name: Notification.Name("UpdateNumber"), object: nil, userInfo: ["index": index])


    }

    @IBAction func updateNumber(_ sender: Any) {
        index += 1
        notifier.post(name: Notification.Name("UpdateNumber"), object: nil, userInfo: ["index": index])
    }
    
    @objc func fib(_ notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else { return }
        if index == 0 {
            FibonacciLabel.text = "Fibonacci: 0"
            return
        }
        
        if index == 1 {
            FibonacciLabel.text = "Fibonacci: 1"
            return
        }
        
        var fibs = [0,1]
        
        for _ in 0...(index-2) {
            fibs.append(fibs[fibs.count - 2] + fibs[fibs.count - 1])
        }
        
        FibonacciLabel.text = "Fibonacci: \(fibs.last ?? 0)"
    }
    
    @objc func num(_ notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else { return }
        print(index, "NUMBER")
        numberLabel.text = "Number: \(index)"
    }
    
    @objc func even(_ notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else { return }
        evenLabel.text = "Even: \(index * 2)"
    }
    
    @objc func odd(_ notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else { return }
        oddLabel.text = "Odd: \(index * 2 + 1)"
    }
}

