//
//  Poll.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/25/22.
//
import UIKit
import Foundation

class Poll: Codable {
    var title: String
    var creator: String
    var questions: [Question]
    var start: CustomDate
    var end: CustomDate

    init(title: String, creator: String, questions: [Question], start: CustomDate, end: CustomDate) {
        self.title = title
        self.creator = creator
        self.questions = questions
        self.start = start
        self.end = end
    }
}
