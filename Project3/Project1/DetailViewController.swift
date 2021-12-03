//
//  DetailViewController.swift
//  Project1
//
//  Created by Noah Glaser on 11/27/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    var selectedImage: (fileName: String, number: Int)?
    
    var totalImages: Int?
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let pictureNumber = selectedImage?.number else {
            return
        }
        
        guard let fileName = selectedImage?.fileName else {
            return
        }
        
        guard let totalPics = totalImages else {
            return
        }
        
        imageView.image = UIImage(named: fileName)
        
        // Title is title on the nav bar
        // title is optional string which is why we don't have to unwrap
        self.title = "Picture \(pictureNumber) of \(totalPics)"
        
        // just for this screen because of the .never enum
        self.navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharedTapped))
    }
    
    @objc func sharedTapped() {
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        guard let name = selectedImage?.fileName else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, name], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.hidesBarsOnTap = false
    }

}
