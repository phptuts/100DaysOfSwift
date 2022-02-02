//
//  ViewController.swift
//  Day82Challenge
//
//  Created by Noah Glaser on 2/1/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var circleView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        circleView.layer.cornerRadius = 120
        circleView.layer.borderWidth = 2
        circleView.layer.borderColor = UIColor.blue.cgColor
        
        3.times{ print("PRINT THIS") }
        var items = [3,2,4,5,4,3]
        items.remove(item: 3)
        print(items)
    }

    @IBAction func onAnimate(_ sender: Any) {
        circleView.bounceOut()
    }
    
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if self.filter({ $0 == item }).count >= 2 {
            guard let removeIndex = self.firstIndex(of: item) else { return }
            self.remove(at: removeIndex)
        }
    }
}

extension Int {
    func times(_ doSomething: (() -> Void)) {
        for _ in 1...self {
            doSomething()
        }
    }
}

extension UIView {
    func bounceOut() {
        UIView.animate(withDuration: 2, delay: 0.25, options: [], animations: {
            [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        }, completion: {
            [weak self] _ in
            self?.bouceBack()
        })
    }
    
    func bouceBack() {
        UIView.animate(withDuration: 1, delay: 2, options: [], animations: {
            [weak self] in
            self?.transform = .identity
        })
    }
}

