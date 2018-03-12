//
//  RepositoryViewController.swift
//  GitHub Feedly
//
//  Created by Haydar Sahin on 12.03.2018.
//  Copyright © 2018 Haydar Sahin. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommitsTableViewController: UITableViewController {

    var user: String!
    var repo: Repository!

    var commits = [Commit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = repo.name
        self.tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell", for: indexPath) as! CommitTableViewCell
        let commit = commits[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        cell.messageLabel.text = commit.message!
        cell.infoLabel.text = commit.authorName! + " authored " + commit.committerName! + " committed at " + dateFormatter.string(from: commit.commitDate) + "."
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}

class CommitTableViewCell:UITableViewCell{
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
}
