//
//  UsersTableViewCell.swift
//  SayHi
//
//  Created by Mahmoud on 01/01/2025.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    // Mark:- IBOutlets

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(user:User){
        lblUserName.text = user.username
        lblStatus.text = user.status
        if user.avatarLink != "" {
            let secureURL = user.avatarLink.replacingOccurrences(of: "http://", with: "https://")
            guard let imageURL = URL(string: secureURL) else { return }
            DispatchQueue.main.async {
                self.imgAvatar.kf.setImage(with:imageURL) { result in
                    switch result {
                    case .success(let value):
                        if let image = value.image.circleMasked {
                            self.imgAvatar.image = image
                        }
                    case .failure(let error):
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
