//
//  DetailViewController.swift
//  Day59Challenge
//
//  Created by Noah Glaser on 1/8/22.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var country: Country?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        title = "Country: \(country?.name.common ?? "")"
        guard let pngUrl = country?.flags.png else { return }
        
        if let url = URL(string: pngUrl) {
            do {
                let data = try Data(contentsOf: url)
                imageView.image = UIImage(data: data)
                imageView.layer.borderWidth = 2
                imageView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            } catch {
                print("ERROR WITH IMAGE")
            }
            
        }
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "detail")  {
            cell.textLabel?.text = country?.rows[indexPath.row].title
            cell.detailTextLabel?.text = country?.rows[indexPath.row].subtitle
            return cell
        }
        
        fatalError("Missing Cell")

    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
