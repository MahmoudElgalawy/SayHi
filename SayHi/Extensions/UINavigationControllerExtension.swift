//
//  UINavigationControllerExtension.swift
//  SayHi
//
//  Created by Mahmoud on 02/01/2025.
//

import Foundation
import UIKit

extension UINavigationController{
    func setNavigationBar(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "ColorTableView")
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(named: "Color1")!,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Color1")!,
            .font: UIFont.systemFont(ofSize: 25, weight: .heavy)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
}
