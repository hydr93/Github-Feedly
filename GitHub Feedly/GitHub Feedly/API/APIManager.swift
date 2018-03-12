//
//  APIManager.swift
//  GitHub Feedly
//
//  Created by Haydar Sahin on 12.03.2018.
//  Copyright © 2018 Haydar Sahin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class APIManager {
    
    // Returns Repositories of a user
    static func getRepositories(user: String, completion: @escaping ([Repository]?,Bool)->Void){
        // users/{user}/repos
        let url = githubApiUrlBase + "users/" + user + "/repos"
        let headers = ["Accept":"application/vnd.github.v3+json"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            do {
                let json = try JSON(data: response.data!).array
                var repositories = [Repository]()
                for element in json! {
                    repositories.append(Repository.build(json: element)!)
                }
                repositories = repositories.sorted(by: {$0.stargazers_count > $1.stargazers_count})
                completion(repositories,false)
            }catch{
                completion(nil,true)
            }
            
        }
    }
    
    static func getCommits(user: String, repo: String, completion: @escaping ([Commit]?,Bool)->Void){
        // repos/{user}/{repo}/commits
        let url = githubApiUrlBase + "repos/" + user + "/" + repo + "/commits"
        let headers = ["Accept":"application/vnd.github.v3+json"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            do {
                let json = try JSON(data: response.data!).array
                var commits = [Commit]()
                for element in json! {
                    commits.append(Commit.build(json: element)!)
                }
                commits = commits.sorted(by: {$0.commitDate > $1.commitDate})
                completion([Commit](commits.prefix(10)),false)
            }catch{
                completion(nil,true)
            }
            
        }
    }
    
}

