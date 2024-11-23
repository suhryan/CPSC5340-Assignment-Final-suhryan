//
//  ArticleModel.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//
// structure for articles.

import Foundation

struct ArticleModel: Identifiable, Codable {
    var id: String
    var title: String
    var content: String
    var topic: String
    var url: String
    var imageURL: String
}
