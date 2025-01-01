//
//  WriteStatusViewController.swift
//  SayHi
//
//  Created by Mahmoud on 29/12/2024.
//

import UIKit

class WriteStatusViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var TxtStatus: UITextView!
    @IBOutlet weak var viewBack: UIView!
    
    var viewModel:StatusProtocol!
    let maxCharacters = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StatusViewModel(userListener: UserListener.shared,saveFetchUser: SaveAndFetchUserLocally.shared)
        viewModel.getUserData { [weak self] user in
            self?.TxtStatus.text = user.status
        }
        viewBack.layer.cornerRadius = 10
        viewBack.layer.masksToBounds = true
        TxtStatus.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TxtStatus.becomeFirstResponder()
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        viewModel.getUserData { [weak self] user in
            var updatedUser = user
            DispatchQueue.main.async {
                updatedUser.status = self?.TxtStatus.text ?? "Available"
            }
            self?.viewModel.saveUserLocally(user: updatedUser)
            self?.viewModel.saveUserToFirestore(updatedUser)
            NotificationCenter.default.post(name: NSNotification.Name("StatusWrited"), object: nil, userInfo: ["status":  self?.TxtStatus.text ?? "Available"])
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // النص الحالي
        let currentText = textView.text ?? ""
        
        // النص الجديد بعد الإدخال
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        // التحقق إذا كان الطول الجديد أقل أو يساوي الحد المسموح به
        return updatedText.count <= maxCharacters
    }
}
