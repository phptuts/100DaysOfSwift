//
//  DetailViewController.swift
//  Challenge50TableViewPictures
//
//  Created by Noah Glaser on 12/30/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var photo: Photo?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedPhoto = photo else { return }
        print(selectedPhoto, "TEST")
        title = selectedPhoto.name
        imageView.image = UIImage(contentsOfFile: selectedPhoto.filePath)
        // Do any additional setup after loading the view.
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
