//
//  Repository.swift
//  GitHubApplication
//
//  Created by Consultant on 1/11/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import Foundation


struct Repository: Decodable {
    let repoName : String?
    let numberofForks: Int?
    let numberofStar : Int?
    let gitUrl : String?
    
    
    enum CodingKeys: String, CodingKey {
        case repoName = "name"
        case numberofForks = "forks"
        case numberofStar = "stargazers_count"
        case gitUrl = "html_url"
    }
}
