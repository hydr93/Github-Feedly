//
//  ViewController.swift
//  GitHub Feedly
//
//  Created by Haydar Sahin on 12.03.2018.
//  Copyright © 2018 Haydar Sahin. All rights reserved.
//

import UIKit
import SVProgressHUD

class AccountsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

//    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var repositoriesContainerView: UIView!
    weak var repositoryDelegate :RepositoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // First GitHub Account is always the predefined one.
        changeTitleAndLoadRepositories(title: githubAccounts[0])
    }
    
    // Open/Close PickerView
    @IBAction func listAccountsAction(_ sender: Any) {
        
        self.pickerContainerView.layoutIfNeeded()
        if self.pickerContainerView.frame.size.height >= 160 {
            self.pickerHeightConstraint.constant = 0
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.pickerView.isHidden = true
                self.changeTitleAndLoadRepositories(title: githubAccounts[self.pickerView.selectedRow(inComponent: 0)])
                
            }
        }else{
            self.pickerHeightConstraint.constant = 160
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.pickerView.isHidden = false
            }
        }
    }
    
    func changeTitleAndLoadRepositories(title: String){
        if self.title != title {
            self.title = title
            self.repositoryDelegate?.accountChanged(accountName: title)
        }
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return githubAccounts.count
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = githubAccounts[row]
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set repositoryDelegate to the emmbedded view's controller
        if (segue.identifier == "RepositoriesTableViewContrainerSegue"){
            let destination = segue.destination as! RepositoriesTableViewController
            self.repositoryDelegate = destination
        }
    }
}

// In order to update the tableviewcontroller, when the account is changed
protocol RepositoryDelegate: class{
    func accountChanged(accountName: String)
}

class RepositoriesTableViewController : UITableViewController, RepositoryDelegate{
    
    var repositories = [Repository]()
    var accountName:String!
    
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class RepositoryTableViewCell:UITableViewCell{
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoStarLabel: UILabel!
    @IBOutlet weak var repoForkLabel: UILabel!
}
