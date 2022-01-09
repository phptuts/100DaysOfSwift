//
//  ViewController.swift
//  Day59Challenge
//
//  Created by Noah Glaser on 1/8/22.
//

import UIKit

class ViewController: UITableViewController {

    var countries =  [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // spin off an action on the main thread
        // doing this for practice with performSelector
        performSelector(onMainThread: #selector(getListOfItems), with: nil, waitUntilDone: false)
        
        // Do any additional setup after loading the view.
    }

    @objc func getListOfItems() {
        let url = URL(string: "https://restcountries.com/v3.1/all")!
        
        // trailing closure syntax
        // the closure is where the ui work is done
        getData(url: url, type: [Country].self) {
            
            countries = $0
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    // This function is re usable for all requests in the app
    func getData<T: Codable>(url: URL, type: T.Type, after: (T) -> Void) {
        do {
            let data = try  Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            let json = try jsonDecoder.decode(type, from: data)
            // This is for the callback
            after(json)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "country") {
            let country = countries[indexPath.row]
            
            cell.textLabel?.text = country.name.common
            
            return cell
        }
        
        fatalError("Did not find cell country")
    }
    
    // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    // The of sections in our table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Handles when the user clicks on the tableview and navigates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        
        guard let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "detail_view") as? DetailViewController else { return }
        
        vc.country = country
        
        self.navigationController?.pushViewController(vc, animated: true)

    }

}

