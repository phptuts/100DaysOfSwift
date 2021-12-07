//
//  SitesTableViewController.swift
//  Project4
//
//  Created by Noah Glaser on 12/6/21.
//

import UIKit

class SitesTableViewController: UITableViewController {

    var sites = ["apple.com","hackingwithswift.com", "google.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sites.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "site", for: indexPath)

        cell.textLabel?.text = sites[indexPath.row]

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let site = sites[indexPath.row]
        
         let vc = storyboard?.instantiateViewController(withIdentifier: "website")
        
        if let siteViewController = vc as? SiteViewController {
            siteViewController.firstUrl = site
            navigationController?.pushViewController(siteViewController, animated: true)
        }
        
    }

}
