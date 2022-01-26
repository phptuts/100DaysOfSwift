//
//  ViewController.swift
//  Project22
//
//  Created by Noah Glaser on 1/24/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var circle: UIView!
    var locationManager: CLLocationManager?
    
    var foundBeacon = false
    
    let beaconDictionary: [String: String] = [ "92AB49BE-4127-42F4-B532-90fAF1E26491": "River Walk",  "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5": "Hallway"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        circle.layer.cornerRadius = 128
        
        view.backgroundColor = .gray
        // Do any additional setup after loading the view.
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager?.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        
        for (beaconUUID, _) in beaconDictionary {
            print("BEACON \(beaconUUID)")
            let uuid = UUID(uuidString: beaconUUID)!
            let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
            
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(in: beaconRegion)

        }
    }
    
    func update(distance: CLProximity) {
        
        if [.far, .immediate, .near].contains(distance) && !foundBeacon {
            let ac = UIAlertController(title: "Found Beacon", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            foundBeacon = true
        }
        
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "NEAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)

            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.circle.transform = .identity

            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.circle.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if let foundItem = beaconDictionary[beacon.uuid.uuidString] {
                itemLabel.text = "Found: \(foundItem)"
            }
           
            update(distance: beacon.proximity)
        } else {
            itemLabel.text = ""
            update(distance: .unknown)
        }
    }
}

