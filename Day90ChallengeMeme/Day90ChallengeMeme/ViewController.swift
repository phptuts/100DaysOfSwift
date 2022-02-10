//
//  ViewController.swift
//  Day90ChallengeMeme
//
//  Created by Noah Glaser on 2/9/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isTopFirst = true
    
    var topText = ""
    var bottomText = ""
    
    var memeImage: UIImage?
    

    @IBOutlet var memeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(shareImage))
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    @objc func shareImage() {
        guard let sharedImage = memeImageView.image else { return }
        let vc = UIActivityViewController(activityItems: [sharedImage], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        memeImage = image
        
        dismiss(animated:true)
        
        let ac = UIAlertController(title: "Meme Message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Top Text", style: .default, handler: { [weak self, weak ac] _ in
            self?.firstPartOfText(isTopFirst: true, text: ac?.textFields?.first?.text ?? "")
        }))
        ac.addAction(UIAlertAction(title: "Bottom Text", style: .default, handler: {
            [weak self,  weak ac] _ in
            self?.firstPartOfText(isTopFirst: false, text: ac?.textFields?.first?.text ?? "")
        }))
        present(ac, animated: true)
    }
    
    func firstPartOfText(isTopFirst: Bool, text: String) {
        self.isTopFirst = isTopFirst
        if isTopFirst {
            topText = text
        } else {
            bottomText = text
        }
        let ac = UIAlertController(title: "Meme Message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            [weak self, weak ac] _ in
            if !isTopFirst {
                self?.topText = ac?.textFields?.first?.text ?? ""
            } else {
                self?.bottomText =  ac?.textFields?.first?.text ?? ""
            }
            
            self?.generateMeme()
        }))
        
        present(ac, animated: true)

    }
    
    func generateMeme() {
        
        guard let image = memeImage else { return }

        let renderer = UIGraphicsImageRenderer(size: memeImageView.frame.size)
        
        memeImageView.image = renderer.image {
            ctx in
            
            image.draw(in: CGRect(x: 0, y: 0, width: memeImageView.frame.width, height: memeImageView.frame.height))
            let fontSize = 60.0
            let font = UIFont(name: "Marker Felt", size: fontSize) ?? .systemFont(ofSize: fontSize)
            
            if !topText.isEmpty {
                let topAttributedString = NSAttributedString(string: topText, attributes: [
                    .font: font,
                    .foregroundColor: UIColor.systemRed
                ])
                
                topAttributedString.draw(at: CGPoint(x: 10, y: 20))
            }
            
            if !bottomText.isEmpty {
                let bottomAttributeString = NSAttributedString(string: bottomText, attributes: [
                    .font: font,
                    .foregroundColor: UIColor.systemRed
                ])
                
                bottomAttributeString.draw(at: CGPoint(x: 10, y: memeImageView.frame.size.height - 80))

            }
        }
    }

}

