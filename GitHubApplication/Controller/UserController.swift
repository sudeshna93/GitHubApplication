//
//  UserController.swift
//  GitHubApplication
//
//  Created by Consultant on 1/10/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import Foundation

protocol UserControllerProtocol {
    var githubs: [GitHub] {get}
    var userinfo : [UserInfo] { get }
    func download (searchtext: String, _ completion: @escaping ([GitHub])->Void)
    func getPicture(_ url: URL, _ completion: @escaping (Data?)-> Void)
    func cancelTask(_ oldURL: URL)
}

class UserController: UserControllerProtocol {
   
    //MARK:- Properties
    
    var page = 1
    var per_page = 10
    var githubs : [GitHub] = []
    var userinfo : [UserInfo] = []
    let networker = DecodableNetwork()
    
    lazy var pictureService: PictureService = {
        return PictureService(networker)
    }()
    
    var isSearching: Bool = false
    
    //MARK: Methods
    //Function for downloading github user details by using search text
    func download(searchtext: String, _ completion: @escaping ([GitHub]) -> Void) {
        let url = URL(string: "https://api.github.com/search/users?q=" + "\(searchtext)")!
        
        networker.get(type: GitHub.self, url: url){
            (result) in
            print("finished download")
           
            self.githubs = [result!]
            completion(self.githubs)
            
        }
    }
    
    func getPicture(_ url: URL, _ completion: @escaping (Data?) -> Void) {
        pictureService.get(url, completion)
    }
    
    func cancelTask(_ oldURL: URL) {
        networker.cancelTask(oldURL)
    }
    
}








