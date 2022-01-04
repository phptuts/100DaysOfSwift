//
//  FilterState.swift
//  Project13
//
//  Created by Noah Glaser on 1/3/22.
//

import Foundation
import CoreImage

struct FilterState {
    var beginImage: CIImage?
    var filters: [CIFilter]
    var intensity: Float = 0
    var scale: Float = 0
    var radius: Float = 0
}
