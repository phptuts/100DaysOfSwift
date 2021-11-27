//
//  DetailViewController.swift
//  Project1
//
//  Created by Noah Glaser on 11/27/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    var selectedImage: String?
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
        // Title is title on the nav bar
        // title is optional string which is why we don't have to unwrap
        self.title = selectedImage
        // just for this screen because of the .never enum
        self.navigationItem.largeTitleDisplayMode = .never

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
