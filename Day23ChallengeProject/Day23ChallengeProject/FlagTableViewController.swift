//
//  FlagTableViewController.swift
//  Day23ChallengeProject
//
//  Created by Noah Glaser on 12/3/21.
//

import UIKit

class FlagTableViewController: UITableViewController {

    
    let flags = [
        "estonia", "france", "germany",
        "ireland", "italy", "monaco",
        "nigeria","poland","russia",
        "spain", "uk", "us"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "flagDetailView")
        
        if let flagDetailView = vc as? FlagViewController {
            flagDetailView.countryName = self.flags[indexPath.row]
            navigationController?.pushViewController(flagDetailView, animated: true)
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flags.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flag", for: indexPath)
        
        if let flagCell = cell as? FlagTableViewCell {
            flagCell.countryLabel.text = self.flags[indexPath.row].countryCase
            flagCell.flagImage.image = UIImage(named: self.flags[indexPath.row])
            flagCell.flagImage.layer.borderWidth = CGFloat(2)
            flagCell.flagImage.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
            flagCell.textLabel?.text = ""
            
            return flagCell
        }

        return cell
    }
    
}

extension String {
    var countryCase: String {
        if self.count == 2 {
            return self.uppercased()
        }
        
        let firstChar = self.first?.uppercased() ?? ""
        var tempString = self
        tempString.removeFirst()
        
        return "\(firstChar)\(tempString.lowercased())"
    }
}
