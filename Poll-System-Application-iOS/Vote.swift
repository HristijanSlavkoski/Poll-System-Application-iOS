//
//  Vote.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/25/22.
//

import UIKit
import Foundation

class Vote: Codable {
    var answers: [String]
    var time: Date
    var location: CustomLocation

    init(answers: [String], time: Date, location: CustomLocation) {
        self.answers = answers
        self.time = time
        self.location = location
    }
}
