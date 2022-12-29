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
    var time: CustomDate
    var location: CustomLocation

    init(answers: [String], time: CustomDate, location: CustomLocation) {
        self.answers = answers
        self.time = time
        self.location = location
    }
}
