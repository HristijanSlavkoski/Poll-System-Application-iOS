//
//  Question.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/25/22.
//
import UIKit
import Foundation

class Question: Codable {
    var question: String
    var options: [String]

    init(question: String, options: [String]) {
        self.question = question
        self.options = options
    }
}
