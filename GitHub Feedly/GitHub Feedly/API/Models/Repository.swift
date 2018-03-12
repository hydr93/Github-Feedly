//
//  Repository.swift
//  GitHub Feedly
//
//  Created by Haydar Sahin on 12.03.2018.
//  Copyright © 2018 Haydar Sahin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Repository{
    var id : Int?
    var name : String?
    var description: String?
    var forks_count: Int?
    var stargazers_count: Int?
    
    init(id: Int, name: String, forks_count: Int, stargazers_count: Int){
        self.id = id
        self.name = name
        self.forks_count = forks_count
        self.stargazers_count = stargazers_count
    }
    
    class func build(json:JSON) -> Repository?{
        if let id = json["id"].int,
            let name = json["name"].string,
            let forks_count = json["forks_count"].int,
            let stargazers_count = json["stargazers_count"].int{
            return Repository(id: id,name: name,forks_count: forks_count,stargazers_count: stargazers_count)
        }else{
            return nil
        }
    }
    
}
