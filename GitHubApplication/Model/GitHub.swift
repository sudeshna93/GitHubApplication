//
//  GitHub.swift
//  GitHubApplication
//
//  Created by Consultant on 1/10/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import Foundation

struct GitHub: Decodable{
    let items : [Items]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}

struct Items: Decodable {
    let imageUrl : String?
    let userName: String?
    let repoUrl: String?
    let url : String?
    
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "avatar_url"
        case userName = "login"
        case repoUrl = "repos_url"
        case url = "url"
    }
}
