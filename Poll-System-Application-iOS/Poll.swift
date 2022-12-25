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
    var start: Date
    var end: Date

    init(title: String, creator: String, questions: [Question], start: Date, end: Date) {
        self.title = title
        self.creator = creator
        self.questions = questions
        self.start = start
        self.end = end
    }
}
