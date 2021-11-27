//
//  ViewController.swift
//  Project1
//
//  Created by Noah Glaser on 11/26/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        // We can get away with force unwrapping because all iOS apps will have a resource path
        let path = Bundle.main.resourcePath!
        // Because of that we can get away with this force try because the directory will always exist
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture",for: indexPath)
        
        cell.textLabel?.text = pictures[indexPath.row]
        
        return cell
    }


}

