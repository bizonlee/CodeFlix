//
//  ProfileVC.swift
//  CodeFlix
//
//  Created by Gryaznoy Alexander on 13.08.2025.
//

import SwiftUI
import UIKit

final class ProfileVC: BaseViewController {

    private lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        button.tintColor = .secondaryLabel
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        let swiftUIView = ProfileView()
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        navigationItem.rightBarButtonItem = settingsButton
    }

    private func setupConstraints() {
        guard let hostingView = children.first?.view else { return }

        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: view.topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func openSettings() {
        let settingsView = SettingsView()
        let hostingController = UIHostingController(rootView: settingsView)
        present(hostingController, animated: true)
    }
}
