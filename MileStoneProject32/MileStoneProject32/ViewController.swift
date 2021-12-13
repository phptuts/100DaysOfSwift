//
//  ViewController.swift
//  MileStoneProject32
//
//  Created by Noah Glaser on 12/12/21.
//

import UIKit

class ViewController: UITableViewController {

    var list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemDialog))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))

        navigationController?.navigationBar.prefersLargeTitles = true

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)

        cell.textLabel?.text = list[indexPath.row]

        return cell
    }
    
    @objc func addItemDialog() {
        let ac = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert);
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            
            if let item = ac?.textFields?.first?.text {
                self?.addItem(item)
            }
        })
        
        present(ac, animated: true)
    } 
    
    func addItem(_ item: String) {
        if item.isEmpty {
            return
        }
        list.append(item)
        let indexPath = IndexPath(row: list.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func share() {
        if list.count == 0 {
            return
        }
        
        let shoppingList = list.joined(separator: "\n")
        
        let ac = UIActivityViewController(activityItems: [shoppingList], applicationActivities: [])
        // This is for ipads
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        
        present(ac, animated: true)
    }
}

