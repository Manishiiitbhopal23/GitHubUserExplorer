//
//  UserVM.swift
//  GithubProject
//
//  Created by Manish Kumar on 16/07/24.
//

import Foundation
struct User: Codable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
    let url: String
    let followers_url: String
}

struct SearchResult: Codable {
    let total_count: Int
    let items: [User]
}
