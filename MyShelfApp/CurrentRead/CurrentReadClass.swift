//
//  CurrentReadClass.swift
//  MyShelfApp
//
//  Created by Rizki Faris on 29/04/22.
//

import Foundation
import UIKit

struct CurrentReadClass : Identifiable, Codable {
    
    var id = UUID()
    var title: String!
    var category: String = ""
    var spentTime: Date
    var coverColor: String = ""
    var highlightedSentence: [String] = [""]
    var lastPlace: String = ""
    var status: String = ""
    var isReadNow: Bool = false
    var createdAt: Date = Date()
    var lastPage: Int = 0
    var lastVisitDate: Date
    var topics: [String] = []
    var updateAt: Date
    
    public init(id: UUID, title: String, category: String, spentTime: Date, coverColor: String, highlightedSentence: [String], lastPlace: String, status: String, isReadNow: Bool, createdAt: Date, lastPage: Int, lastVisitDate: Date, topics: [String], updateAt: Date) {
        self.id = id
        self.title = title
        self.category = category
        self.spentTime = spentTime
        self.coverColor = coverColor
        self.highlightedSentence = highlightedSentence
        self.lastPlace = lastPlace
        self.status = status
        self.isReadNow = isReadNow
        self.createdAt = createdAt
        self.lastPage = lastPage
        self.lastVisitDate = lastVisitDate
        self.topics = topics
        self.updateAt = updateAt
    }
}
