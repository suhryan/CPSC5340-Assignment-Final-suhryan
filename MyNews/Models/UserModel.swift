//
//  UserModel.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//
// structure for user preferences

import Foundation

struct UserModel: Codable {
    var topics: [String]
    var bookmarks: [String]
}
