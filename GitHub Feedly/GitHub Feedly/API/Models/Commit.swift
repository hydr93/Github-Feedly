//
//  Commit.swift
//  GitHub Feedly
//
//  Created by Haydar Sahin on 13.03.2018.
//  Copyright © 2018 Haydar Sahin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Commit{
    var authorName :String!
    var authorEmail :String!
    var committerName :String!
    var committerEmail :String!
    var commitDate :Date!
    var message :String?
    
    init(authorName: String, authorEmail: String,committerName: String, committerEmail: String, commitDate: Date, message: String){
        self.authorName = committerName
        self.authorEmail = authorEmail
        self.committerName = committerName
        self.committerEmail = committerEmail
        self.commitDate = commitDate
        self.message = message
    }
    
    class func build(json:JSON) -> Commit?{
        if  let authorName = json["commit"]["author"]["name"].string,
            let authorEmail = json["commit"]["author"]["email"].string,
            let committerName = json["commit"]["committer"]["name"].string,
            let committerEmail = json["commit"]["committer"]["email"].string,
            let commitDate = json["commit"]["author"]["date"].string,
            let message = json["commit"]["message"].string{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return Commit(authorName: authorName, authorEmail: authorEmail, committerName: committerName, committerEmail: committerEmail, commitDate:dateFormatter.date(from: commitDate)!, message: message)
        }else{
            return nil
        }
    }
}
