//
//  UserProfileTableViewController.swift
//  SayHi
//
//  Created by Mahmoud on 02/01/2025.
//

import UIKit

class UserProfileTableViewController: UITableViewController {
    
    // Mark:- IBOutlets

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    var viewModel:UserProfileProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetUp()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        navigationController?.setNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = false
       
        if viewModel.user.username == "You"{
            navigationItem.title = "Your Profile"
        }else{
            let usernamearr = viewModel.user.username.split(separator: " ")
            navigationItem.title = "\(usernamearr[0]) Profile"
        }
    }

   
    func uiSetUp(){
        if viewModel.user.username == "You"{
            viewModel.getUserData { [weak self] user in
                DispatchQueue.main.async {
                    self?.lblUserName.text = user.username
                }
            }
        }else{
            lblStatus.text = viewModel.user.status
        }
        lblUserName.text = viewModel.user.username
        if viewModel.user.avatarLink != " " {
            let secureURL = viewModel.user.avatarLink.replacingOccurrences(of: "http://", with: "https://")
            guard let imageURL = URL(string: secureURL) else { return }
                self.imgAvatar.kf.setImage(with:imageURL){ [weak self] result in
                    switch result {
                    case .success(let value):
                        self?.imgAvatar.image = value.image.circleMasked
                    case .failure(let error):
                        print("Error loading image: \(error.localizedDescription)")
                    }
            }
        }else{
            self.imgAvatar.image = UIImage(named: "Avatar1")!.circleMasked
        }
    }
}

// MARK: - Table view data source

extension UserProfileTableViewController{
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}
