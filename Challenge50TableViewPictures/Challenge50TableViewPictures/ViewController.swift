//
//  ViewController.swift
//  Challenge50TableViewPictures
//
//  Created by Noah Glaser on 12/30/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "photos") as? Data {
            let decoder = JSONDecoder()
            do {
                photos = try decoder.decode([Photo].self, from: data)
            } catch {
                print("Could not decode")
            }
        }
    }
    
    @objc func addPhoto() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        // This must be allowed for selecting images
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "picture") as? PictureCell else {
            fatalError("Error Dequeuing Cell")
        }
        cell.pictureImage.image = UIImage(contentsOfFile: photos[indexPath.row].filePath)
        cell.pictureName.text = photos[indexPath.row].name
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            vc.photo = photos[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let name = UUID().uuidString
        let path = getDocumentDirectory().appendingPathComponent(name)
        
        // Dismiss the image picker
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Name Picture", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            guard let text = ac?.textFields?.first?.text else { return }
            if let jpegData = image.jpegData(compressionQuality: 0.75) {
                try? jpegData.write(to: path)
            }
            let photo = Photo(name: text, filePath: path.path)
            self?.photos.insert(photo, at: 0)
            self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self?.savePhotos()
        })
        present(ac, animated: true)
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func savePhotos() {
        let encoder = JSONEncoder()
        if let encodedPics = try? encoder.encode(self.photos) {
            let defaults = UserDefaults.standard
            defaults.set(encodedPics, forKey: "photos")
        }
    }
}

