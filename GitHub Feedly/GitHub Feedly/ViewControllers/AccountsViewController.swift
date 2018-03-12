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
            destination.topViewController = self
        }else if (segue.identifier == "showSegueToCommitsTableView"){
            let destination = segue.destination as! CommitsTableViewController
            let dict = sender as! [String:Any]
            destination.commits = dict["commits"] as! [Commit]
            destination.repo = dict["repo"] as! Repository
            destination.user = dict["user"] as! String
        }
    }
}
