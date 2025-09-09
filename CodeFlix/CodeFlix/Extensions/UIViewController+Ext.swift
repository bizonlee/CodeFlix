//
//  UIViewController+Ext.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 10.09.2025.
//

import UIKit

extension UIViewController {
    func showErrorAlertController(title: String = "Ошибка", message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
