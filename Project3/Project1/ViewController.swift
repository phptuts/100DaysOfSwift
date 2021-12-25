//
//  ViewController.swift
//  Project1
//
//  Created by Noah Glaser on 11/26/21.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [(fileName: String, number: Int)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Storm Viewer"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        // We can get away with force unwrapping because all iOS apps will have a resource path
        let path = Bundle.main.resourcePath!
        // Because of that we can get away with this force try because the directory will always exist
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // Created a tuple so that I could store the file number to display and the filename
        // I filtered out all the non jpgs
        // I then map the filenames to the tuple and start 1
        // I then sort everything by the number
        let sortedPics: [(fileName: String, number: Int)] = items
            .filter({item in item.hasPrefix("nssl")})
            .map({ name in
                let numName = name
                    .replacingOccurrences(of: "nssl00", with: "")
                    .replacingOccurrences(of: ".jpg", with: "")
                // This should always work
                if let fileNumber = Int(numName) {
                    return (fileName: name, number: fileNumber)
                } else {
                    return (fileName: name, number: 1)
                }
        }).sorted(by: { a, b in
            return a.number < b.number
        })
        
        pictures = sortedPics
            .enumerated()
            .map({ (index, item) in
            return (fileName: item.fileName, number: index + 1)
        })
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath)
        
            
        
        if let picCell = cell as? Picture {
            picCell.picture.image = UIImage(named: pictures[indexPath.item].fileName)
            picCell.name.text = "\(pictures[indexPath.item].number) Pic"
            return picCell
        }
        
        
        return cell

    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // This get detailed view controller from the storyboard using the
        // Detial identifier.  It actually creates one
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // This sets selectedImage from the list of pictures on the view controller
            vc.selectedImage = pictures[indexPath.row]
            vc.totalImages = pictures.count
            // This handles the navigation
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

