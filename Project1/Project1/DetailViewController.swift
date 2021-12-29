//
//  DetailViewController.swift
//  Project1
//
//  Created by Noah Glaser on 11/27/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    var selectedImage: StormPicture?
    
    var totalImages: Int?
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let pictureNumber = selectedImage?.picNumber else {
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
