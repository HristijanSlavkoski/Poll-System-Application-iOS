//
//  CustomLocation.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/25/22.
//

import UIKit
import Foundation

class CustomLocation: Codable {
    var longitude: Double
    var latitude: Double

    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
}

