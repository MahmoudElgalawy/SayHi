//
//  UsersTableViewController.swift
//  SayHi
//
//  Created by Mahmoud on 01/01/2025.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    //var dummyUsers:DummyUsers!
    var viewModel: UsersProtocol!
    let searchController = UISearchController()
    var indicator : UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        //        dummyUsers = DummyUsers(cloudinaryService: CloudinaryService.shared, UserListener: UserListener.shared)
        //        dummyUsers.createDummyUsers()
        viewModel = UsersViewModel(userListener: UserListener.shared)
        searchBar()
        setIndicator()
        viewModel.getAllUsers ()
        viewModel.bindUsersToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.indicator?.stopAnimating()
            }
        }
        self.tableView.showsVerticalScrollIndicator = false
        searchController.searchResultsUpdater = self
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBar()
    }
    
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .color1
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
}

// Mark:- Data Source And Delegate

extension UsersTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as! UsersTableViewCell
        cell.configureCell(user: self.viewModel.users![indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userProfileVC = storyboard?.instantiateViewController(identifier: "UserProfileTableViewController") as! UserProfileTableViewController
        userProfileVC.viewModel = UserProfileViewModel(user:viewModel.users![indexPath.row], userListener: UserListener.shared)
    
     
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       if self.refreshControl!.isRefreshing{
           viewModel.getAllUsers()
           viewModel.bindUsersToViewController = { [weak self] in
               DispatchQueue.main.async {
                   self?.tableView.reloadData()
                   self?.searchBar()
               }
           }
           self.refreshControl?.endRefreshing()
        }
    }
}

//   Mark:-   SearchBar

extension UsersTableViewController:UISearchResultsUpdating {
    
    func searchBar(){
        searchController.searchBar.tintColor = UIColor.color1
        let searchBar = searchController.searchBar
        searchBar.searchTextField.backgroundColor = UIColor.systemGray5
        searchBar.searchTextField.textColor = UIColor.white
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.color1
        ]
        let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        searchBar.searchTextField.attributedPlaceholder = attributedPlaceholder
        if let searchIcon = UIImage(systemName: "magnifyingglass") {
            let tintedImage = searchIcon.withTintColor(UIColor.color1, renderingMode: .alwaysOriginal)
            searchBar.setImage(tintedImage, for: UISearchBar.Icon.search, state: .normal)
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{return}
        viewModel?.filterUsers(by: text)
        
    }
}
