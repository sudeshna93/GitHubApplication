//
//  PictureService.swift
//  GitHubApplication
//
//  Created by Consultant on 1/10/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import Foundation

class PictureService {
    
    //MARK: Properties
    let cache : NSCache<NSURL, NSData>
    let decodableNetwork: DecodableNetwork
    
    //MARK: Initializer
    init(_ networker: DecodableNetwork) {
        cache = NSCache()
        self.decodableNetwork = networker
    }
    
    
    //MARK: Picture Access Method
    
    func get (_ url:URL, _ completion: @escaping(Data?)->Void){
        //1. if I have it in the cache return this value
        
        if let nsURL = NSURL(string: url.absoluteString),
            let val = cache.object(forKey: nsURL){
            let data = Data(referencing: val)
            completion(data)
            return
        }
        
        //2. I must fetch it from netwok
        
        decodableNetwork.getData(url) { (data) in
            if let data = data,
                let nsURL = NSURL(string: url.absoluteString) {
                let nsData = NSData(data: data)
                self.cache.setObject(nsData, forKey: nsURL)
            }
            completion(data)
        }
    }
    
}
