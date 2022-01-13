//
//  Capital.swift
//  Project16
//
//  Created by Noah Glaser on 1/9/22.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var urlString: String
    var hasBeenSeen: Bool = false
    var isVisible = false {
        didSet {
            if oldValue == true && isVisible == false {
                hasBeenSeen = true
                print("changing has been seen \(title) \(hasBeenSeen)")
            }
        }
    }
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, urlString: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.urlString = urlString
    }
}
