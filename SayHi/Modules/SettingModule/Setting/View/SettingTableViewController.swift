//
//  SettingTableViewController.swift
//  SayHi
//
//  Created by Mahmoud on 24/12/2024.
//

import UIKit
import Kingfisher


class SettingTableViewController: UITableViewController {
    
    // Mark:- IBOutlet
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    
    var viewModel:SettingProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingViewModel(userListener: UserListener.shared)
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width/2
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
//        let cloudinaryService = CloudinaryService.shared
//        cloudinaryService.deleteAllResources()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "ColorTableView")
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(named: "Color1")!,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        appearance.titleTextAttributes = [
               .foregroundColor: UIColor(named: "Color1")!,
               .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
           ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        showUserInfo()
    }
    
    @IBAction func tellFriendBtn(_ sender: Any) {
        print("tellFriendBtn")
    }
    
    @IBAction func TermsBtn(_ sender: Any) {
        print("TermsBtn")
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        showAlert()
    }
}

// Mark:- UISetUp

extension SettingTableViewController{
    
    private func showUserInfo(){
        
        viewModel.getUserData { [weak self] user in
            DispatchQueue.main.async {
                self?.lblUserName.text = user.username
                self?.lblStatus.text = user.status
                self?.lblVersion.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            }
            if user.avatarLink != "" {
                let secureURL = user.avatarLink.replacingOccurrences(of: "http://", with: "https://")
                guard let imageURL = URL(string: secureURL) else { return }
                DispatchQueue.main.async {
                    self?.imgAvatar.kf.setImage(with:imageURL) { result in
                        switch result {
                        case .success(let value):
                            if let image = value.image.circleMasked {
                                self?.imgAvatar.image = image
                            }
                        case .failure(let error):
                            print("Error loading image: \(error.localizedDescription)")
                        }
                    }
                }
            }
            
        }
        
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "You Will Logout", message: "Are You Sure?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .cancel) { _ in
            self.viewModel.logOut { error in
                if error == nil {
                    let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    DispatchQueue.main.async {
                        loginView.modalPresentationStyle = .fullScreen
                        self.present(loginView, animated: true)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
}

// Mark:- Data Source And Delegate

extension SettingTableViewController{
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTableView")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10.0 : 20.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "goToEditProfile", sender: self)
        }
    }
}
