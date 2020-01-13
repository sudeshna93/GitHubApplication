//
//  UserInfo.swift
//  GitHubApplication
//
//  Created by Consultant on 1/12/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import Foundation

struct UserInfo: Decodable {
    let followers : Int?
    let following: Int?
    let email: String?
    let location: String?
    let joinDate: String?
    let bio: String?
    let repocount : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case followers = "followers"
        case following = "following"
        case email = "email"
        case location = "location"
        case joinDate = "created_at"
        case bio = "bio"
        case repocount = "public_repos"
    }
}


