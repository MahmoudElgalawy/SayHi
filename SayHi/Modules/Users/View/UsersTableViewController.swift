//
//  UsersTableViewController.swift
//  SayHi
//
//  Created by Mahmoud on 01/01/2025.
//

import UIKit

class UsersTableViewController: UITableViewController {

//    var dummyUsers:DummyUsers!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        dummyUsers = DummyUsers(cloudinaryService: CloudinaryService.shared, UserListener: UserListener.shared)
//        dummyUsers.createDummyUsers()
       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as! UsersTableViewCell
        return cell
    }
}
