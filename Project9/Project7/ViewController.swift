//
//  ViewController.swift
//  Project7
//
//  Created by Noah Glaser on 12/14/21.
//

import UIKit

class ViewController: UITableViewController {

    var originalPetitions = [Petition]()
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "credits", style: .plain, target: self, action: #selector(showCredits))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "filter", style: .plain, target: self, action: #selector(filterAlert))
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    
    }
    
    @objc func fetchJSON() {
        // let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // ok to parse the data
                self.parseJSON(json: data)
                return
            }
        }
          
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "We the people api", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "Could not load feed", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "dismiss", style: .default))
        
        self.present(ac, animated: true)
        
    }
    
    func parseJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            originalPetitions = jsonPetitions.results
            petitions = originalPetitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detialItem = petitions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func filterAlert() {
        let ac = UIAlertController(title: "Filter", message: "Filter Results", preferredStyle: .alert)
        
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "filter", style: .default, handler: {
            [weak self, weak ac] _ in
            
            if let filterText = ac?.textFields?.first?.text {
                self?.filterResults(filterText: filterText)
            }
            
        }))
        
        present(ac, animated: true)

    }
    
    func filterResults(filterText: String) {
        
        if filterText.isEmpty {
            petitions = originalPetitions
            tableView.reloadData()
            return
        }
        
        petitions = originalPetitions.filter({
            return $0.title.lowercased().contains(filterText.lowercased()) || $0.body.lowercased().contains(filterText.lowercased())
        })
        tableView.reloadData()
    }
}

