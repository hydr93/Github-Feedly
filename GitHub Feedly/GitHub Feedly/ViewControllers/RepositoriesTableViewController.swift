//
//  RepositoryTableViewController.swift
//  GitHub Feedly
//
//  Created by Haydar Sahin on 13.03.2018.
//  Copyright © 2018 Haydar Sahin. All rights reserved.
//

import UIKit
import SVProgressHUD

// In order to update the tableviewcontroller, when the account is changed
protocol RepositoryDelegate: class{
    func accountChanged(accountName: String)
}

class RepositoriesTableViewController : UITableViewController, RepositoryDelegate{
    
    var repositories = [Repository]()
    var accountName:String!
    var topViewController: AccountsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.refreshRepositories(_:)), for: UIControlEvents.valueChanged)
    }
    
    func accountChanged(accountName: String) {
        self.accountName = accountName
        self.refreshRepositories(nil)
    }
    
    @objc func refreshRepositories(_ sender : AnyObject?){
        if (sender == nil){
            SVProgressHUD.show()
        }
        if self.accountName != nil {
            APIManager.getRepositories(user: self.accountName) { (repos, failed) in
                if failed == false {
                    self.repositories = repos!
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryTableViewCell
        let repository = repositories[indexPath.row]
        cell.repoNameLabel.text = repository.name
        cell.repoStarLabel.text = String(describing:repository.stargazers_count!)
        cell.repoForkLabel.text = String(describing:repository.forks_count!)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository :Repository = repositories[indexPath.row]
        SVProgressHUD.show()
        APIManager.getCommits(user: accountName, repo: repository.name) { (commits, failed) in
            if failed == false {
                let dict = ["user":self.accountName,
                            "repo":repository,
                            "commits":commits!] as [String : Any]
                self.topViewController.performSegue(withIdentifier: "showSegueToCommitsTableView", sender: dict)
            }
        }
    }
}

class RepositoryTableViewCell:UITableViewCell{
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoStarLabel: UILabel!
    @IBOutlet weak var repoForkLabel: UILabel!
}
