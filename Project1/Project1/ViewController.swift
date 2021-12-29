//
//  ViewController.swift
//  Project1
//
//  Created by Noah Glaser on 11/26/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [StormPicture]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Storm Viewer"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadListOfPictures), with: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        

    }
    
    @objc func loadListOfPictures() {
        
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "pictures") as? Data {
            let decoder = JSONDecoder()
            
            do {
                pictures = try decoder.decode([StormPicture].self, from: data)
            } catch {
                pictures = loadPicturesFromFileSystem()
                save()
                print("Failed load items from user defaults")
            }
        } else {
            pictures = loadPicturesFromFileSystem()
            save()
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        // Ask JASON 1
        // Why does this code not work
//        self.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture",for: indexPath)
        
        cell.textLabel?.text = "\(pictures[indexPath.row].fileName) - \(pictures[indexPath.row].shown) times"
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // This function is called when the user selects the a row in table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // This get detailed view controller from the storyboard using the
        // Detial identifier.  It actually creates one
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // This sets selectedImage from the list of pictures on the view controller
            vc.selectedImage = pictures[indexPath.row]
            vc.totalImages = pictures.count
            pictures[indexPath.row].shown += 1
            save()
            // This handles the navigation
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func share() {
        let vc = UIActivityViewController(activityItems: ["Checkout my amazing app!"], applicationActivities: [])
        
        vc.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
    
    func loadPicturesFromFileSystem() -> [StormPicture] {
        let fm = FileManager.default
        // We can get away with force unwrapping because all iOS apps will have a resource path
        let path = Bundle.main.resourcePath!
        // Because of that we can get away with this force try because the directory will always exist
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // Created a tuple so that I could store the file number to display and the filename
        // I filtered out all the non jpgs
        // I then map the filenames to the tuple and start 1
        // I then sort everything by the number
        let pictures: [StormPicture] = items
            .filter({item in item.hasPrefix("nssl")})
            .map({ name in
                let numName = name
                    .replacingOccurrences(of: "nssl00", with: "")
                    .replacingOccurrences(of: ".jpg", with: "")
                // This should always work
                if let fileNumber = Int(numName) {
                    return StormPicture(fileName: name, picNumber: fileNumber)
                } else {
                    return StormPicture(fileName: name, picNumber: 1)
                }
        }).sorted(by: { a, b in
            return a.picNumber < b.picNumber
        })
            
        return pictures.enumerated().map({ (index, pic) in
            return StormPicture(fileName: pic.fileName, picNumber: 1)
        })
        
    }

    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        }
    }
}

