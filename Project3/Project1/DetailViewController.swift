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
        guard let originalImage = UIImage(named: fileName) else { fatalError("Original Image does not exist")}

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: originalImage.size.width, height: originalImage.size.height))
        let image = renderer.image { ctx in
            originalImage.draw(at: CGPoint(x: 0, y: 0))

           
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30),
            ]
            let string = "From Storm Viewer"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 300, y: 50, width: originalImage.size.width - 30, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
        }
        imageView.image = image
        
        
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
