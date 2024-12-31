//
//  EditProfileTableViewController.swift
//  SayHi
//
//  Created by Mahmoud on 26/12/2024.
//

import UIKit
import YPImagePicker
import Kingfisher
import SVProgressHUD

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    
    var viewModel:EditProfileProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EditProfileViewModel(saveFetchUser: SaveAndFetchUserLocally.shared, userListener: UserListener.shared, cloudinary: CloudinaryService())
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatus(_:)), name: NSNotification.Name("StatusChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatus(_:)), name: NSNotification.Name("StatusWrited"), object: nil)
        
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
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width/2
        
        showUserInfo()
        configureTextField()
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        pickingPhoto()
    }
    
    deinit {
        // إزالة المستمع عند إلغاء تخصيص الكائن
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("StatusChanged"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("StatusWrited"), object: nil)
    }
}

// Mark:- UISetUp

extension EditProfileTableViewController{
    private func showUserInfo(){
        viewModel.getUserData { [weak self] user in
            self?.txtUserName.text = user.username
            self?.lblStatus.text = user.status
            self?.lblEmail.text = user.email
            if user.avatarLink != "" {
                let secureURL = user.avatarLink.replacingOccurrences(of: "http://", with: "https://")
                guard let imageURL = URL(string: secureURL) else { return }
                DispatchQueue.main.async {
                    self?.imgAvatar.kf.setImage(with:imageURL) { result in
                        switch result {
                        case .success(let value):
                            // تطبيق القناع الدائري بعد تحميل الصورة
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
    
    @objc func updateStatus(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let status = userInfo["status"] as? String {
            lblStatus.text = status
            print("تم تحديث الصورة في SettingsViewController")
        }
    }
    
    func pickingPhoto(){
        var config = YPImagePickerConfiguration()
        
        config.screens = [.library, .photo]
        config.library.mediaType = .photoAndVideo
        config.showsPhotoFilters = true
        config.startOnScreen = .library
        config.library.defaultMultipleSelection = false
        config.wordings.cameraTitle = "Camera"
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                print("اختيار المستخدم تم إلغاؤه")
            } else {
                for item in items {
                    switch item {
                    case .photo(let photo):
                        print("تم اختيار صورة: \(photo.image)")
                        if let image = photo.image.circleMasked {
                            self.imgAvatar.image = image
                        }
                        
                        let imageData = photo.image.pngData()
                        SVProgressHUD.show(withStatus: "Changing Profile Picture...")
                        self.navigationController?.navigationBar.isUserInteractionEnabled = false
                        self.view.isUserInteractionEnabled = false
                        self.tabBarController?.tabBar.isUserInteractionEnabled = false
                        self.viewModel.uploadImage(image: imageData!) { success in
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                if success {
                                    SVProgressHUD.showSuccess(withStatus: "Your Profile Picture Changed Successfully")
                                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                    self.view.isUserInteractionEnabled = true
                                    self.tabBarController?.tabBar.isUserInteractionEnabled = false
                                } else {
                                    SVProgressHUD.showError(withStatus: "Failed To Change Your Profile Picture. Please Try Again.")
                                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                    self.view.isUserInteractionEnabled = true
                                    self.tabBarController?.tabBar.isUserInteractionEnabled = false
                                }
                            }
                        }
                    case .video(let video):
                        print("تم اختيار فيديو: \(video.url)")
                    }
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}

// Mark:- Data Source And Delegate

extension EditProfileTableViewController{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? 0.0 : 40.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            performSegue(withIdentifier: "goToStatus", sender: self)
        }
    }
    
    private func configureTextField(){
        txtUserName.delegate = self
        txtUserName.clearButtonMode = .whileEditing
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtUserName && textField.text != ""  {
            viewModel.getUserData(completion: { [weak self] user in
                var updatedUser = user
                updatedUser.username = (self?.txtUserName.text)!
                self?.viewModel.saveUserLocally(user: updatedUser)
                self?.viewModel.saveUserToFirestore(updatedUser)
            })
            return false
        }
        return true
    }
}

