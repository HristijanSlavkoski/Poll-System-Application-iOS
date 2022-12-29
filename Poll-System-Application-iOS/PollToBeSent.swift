//
//  PollToBeSent.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/29/22.
//

import UIKit
import Foundation

class PollToBeSent: Codable {
    var poll: Poll
    var pollId: String

    init(poll: Poll, pollId: String) {
        self.poll = poll
        self.pollId = pollId
    }
}
