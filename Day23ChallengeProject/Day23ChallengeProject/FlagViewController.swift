//
//  ViewController.swift
//  Day23ChallengeProject
//
//  Created by Noah Glaser on 12/3/21.
//

import UIKit

class FlagViewController: UIViewController {

    var countryName: String?

    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var flagImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let country = countryName else {
            return;
        }
        

        
        countryLabel.text = country.countryCase
        flagImage.image = UIImage(named: country)
        flagImage.layer.borderWidth = CGFloat(4)
        flagImage.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)

    }

    @IBAction func share(_ sender: Any) {
        guard let country = countryName else {
            return;
        }
        
        guard let countryImage = UIImage(named: country) else {
            return
        }
        let vc = UIActivityViewController(activityItems: [countryImage, country.countryCase], applicationActivities: [])
        vc.popoverPresentationController?.sourceView = self.view
        present(vc, animated: true)
    }
    
}

