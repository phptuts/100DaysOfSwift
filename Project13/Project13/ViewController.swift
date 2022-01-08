//
//  ViewController.swift
//  Project13
//
//  Created by Noah Glaser on 1/1/22.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
        
    var filterState: FilterState! {
        didSet {
            applyProcessing()
        }
    }
    
    var context: CIContext!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "InstaFilter"
        filterState = FilterState(filters: [], intensity: 0, scale: 0, radius: 0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
    }

    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "No Image Selected", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func radiusChanged(_ sender: UISlider) {
        filterState.radius = sender.value
    }
    
    @IBAction func scaleChanged(_ sender: UISlider) {
        filterState.scale = sender.value
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        filterState.intensity = sender.value
    }
    
    @IBAction func toggleBumpDistortion(_ sender: UISwitch) {
        addRemoveFilter(filterName: "CIBumpDistortion", add: sender.isOn)
    }
    
    @IBAction func toggleSepiaTone(_ sender: UISwitch) {
        addRemoveFilter(filterName: "CISepiaTone", add: sender.isOn)

    }
    @IBAction func toggleTwirlDistortion(_ sender: UISwitch) {
        addRemoveFilter(filterName: "CITwirlDistortion", add: sender.isOn)

    }
    func addRemoveFilter(filterName: String, add: Bool) {
        if add {
            if let filter = CIFilter(name: filterName) {
                filterState.filters.append(filter)
            }
        } else {
            filterState.filters = filterState.filters.filter {
                return $0.name != filterName
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        self.imageView.image = image
        self.imageView.alpha = 0
        UIView.animate(withDuration: 3, delay: 0, options: [], animations: { [weak self] in
            self?.imageView.alpha = 1
        })
        
        
        filterState.beginImage = CIImage(image: image)
    }
    
    
    func applyFilter(filter: CIFilter, image: CIImage) -> CIImage {
        
        filter.setValue(image, forKey: kCIInputImageKey)
        
        let inputKeys = filter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            filter.setValue(filterState.intensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            filter.setValue(filterState.radius * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            filter.setValue(filterState.scale * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            filter.setValue(CIVector(x: image.extent.size.width / 2, y: image.extent.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let image = filter.outputImage else {
            fatalError("No image for filter")
        }
        
        return image
    }
    
    func applyProcessing() {
        
        guard let startImage = filterState.beginImage else {
            return
        }

        if filterState.filters.isEmpty {
            setImageViewWithCIImage(ciImage: startImage)
            return
        }
        
        var filteredImage: CIImage? = nil
        
        for index in 0..<filterState.filters.count {
            let filter = filterState.filters[index]
            if let image = filteredImage {
                filteredImage =  applyFilter(filter: filter, image: image)
            } else {
                filteredImage = applyFilter(filter: filter, image: startImage)
            }
        }
        
        guard let finalImage = filteredImage else { return }
        setImageViewWithCIImage(ciImage: finalImage)
        
    }
    
    func setImageViewWithCIImage(ciImage: CIImage) {
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let processImage = UIImage(cgImage: cgImage)
            imageView.image = processImage
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)

        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

