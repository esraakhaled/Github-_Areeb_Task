//
//  Repository.swift
//  Github Repo
//
//  Created by Esraa Khaled   on 21/10/2023.
//

import Foundation


struct Repository: Codable {
    let name: String
    let owner: Owner
    let url: String
    var creationDate: String?
    enum CodingKeys: String, CodingKey {
        case name, owner, url
        case creationDate = "created_at"
    }
}

struct Owner: Codable {
    let login: String
    let avatarURL: String
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
