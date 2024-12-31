//
//  StatusTableViewController.swift
//  SayHi
//
//  Created by Mahmoud on 29/12/2024.
//

import UIKit

class StatusTableViewController: UITableViewController {
    
    var viewModel:StatusProtocol!
    var selectedIndexPath: IndexPath?
    var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = StatusViewModel(userListener: UserListener.shared,saveFetchUser: SaveAndFetchUserLocally.shared)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "ColorTableView") // لون الخلفية
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Color1")!, // لون النص
            .font: UIFont.systemFont(ofSize: 25, weight: .bold) // حجم وخط النص
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}



// Mark:- Data Source And Delegate

extension StatusTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        default:
            return viewModel.statusArr.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Current Status"
        case 1:
            return "Choose New Status"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
            viewModel.getUserData { user in
                DispatchQueue.main.async{
                    cell.textLabel?.text = user.status
                }
            }
            
            observer = NotificationCenter.default.addObserver(
                forName: NSNotification.Name("StatusWrited"),
                object: nil,
                queue: .main
            ) { notification in
                if let userInfo = notification.userInfo,
                   let status = userInfo["status"] as? String {
                    DispatchQueue.main.async {
                        cell.textLabel?.text = status
                    }
                }
            }
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
            cell.textLabel?.text = viewModel.statusArr[indexPath.row]
            
            // Mark:- Check Mark At Cell
            
            viewModel.getUserData { [weak self] user in
                DispatchQueue.main.async {
                    cell.accessoryType = user.status == self?.viewModel.statusArr[indexPath.row] ? .checkmark:.none
                }
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            viewModel.getUserData { [weak self] user in
                var updatedUser = user
                guard let cell = tableView.cellForRow(at: indexPath) else{return}
                updatedUser.status = cell.textLabel?.text ?? "Available"
                self?.viewModel.saveUserLocally(user: updatedUser)
                self?.viewModel.saveUserToFirestore(updatedUser)
                self?.selectedIndexPath = indexPath
                NotificationCenter.default.post(name: NSNotification.Name("StatusChanged"), object: nil, userInfo: ["status":  cell.textLabel?.text ?? "Available"])
            }
            tableView.reloadData()
        }else{
            let writeStatusVC = self.storyboard?.instantiateViewController(withIdentifier: "WriteStatusViewController") as! WriteStatusViewController
            self.present(writeStatusVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 54
        default:
            return 54
        }
    }
    
}
