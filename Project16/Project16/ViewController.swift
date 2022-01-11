//
//  ViewController.swift
//  Project16
//
//  Created by Noah Glaser on 1/9/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home of the 2012 Olypics",urlString: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a housand years ago.",urlString: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Parse", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light",urlString: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.",urlString: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "There are underground tunnels beneath the capitol.", urlString:"https://en.wikipedia.org/wiki/Washington,_D.C.")
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMap))
        
    }
    
    @objc func changeMap() {
        let ac = UIAlertController(title: "Change Map", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Satelite", style: .default, handler: changeMapStyle))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: changeMapStyle))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: changeMapStyle))
        
        present(ac, animated:  true)
    }
    
    
    func changeMapStyle(action: UIAlertAction) {
        if action.title == "Satelite" {
            mapView.mapType = .satelliteFlyover
        } else if action.title == "Hybrid" {
            mapView.mapType = .hybrid
        }  else {
            mapView.mapType = .standard
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            annotationView.annotation = annotation
            annotationView.pinTintColor = UIColor.purple
            return annotationView

        } else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            annotationView.pinTintColor = .systemOrange
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
      
        if let vc =  self.storyboard?.instantiateViewController(withIdentifier: "webview") as? WebViewController {
            vc.urlString = capital.urlString
            navigationController?.pushViewController(vc, animated: true)
        }
//        let ac = UIAlertController(title: placeName, message: info, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    }

}

