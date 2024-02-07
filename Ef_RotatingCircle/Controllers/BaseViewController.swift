//
//  BaseViewController.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 07.02.2024.
//

import UIKit

class SM_BaseViewController: UIViewController {
  
    func presentAlert(title: String = "", message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func createRightNavBarItemWithText(title: String, hightFont: CGFloat) {
        let font = UIFont.systemFont(ofSize: hightFont, weight: .medium)
        let style = UINavigationBarAppearance()
        style.buttonAppearance.normal.titleTextAttributes = [.font: font]
        navigationItem.standardAppearance = style
        let rightBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(sm_didTapRightNavButton))
        rightBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func sm_didTapRightNavButton() {}
}
