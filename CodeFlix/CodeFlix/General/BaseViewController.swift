//
//  BaseViewController.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 21.09.2025.
//
// вдохновлялся этим https://github.com/aryamansharda/NetworkMonitoring/blob/main/NetworkConnectivityManager/ViewController.swift

import UIKit

class BaseViewController: UIViewController {

    private lazy var offlineBanner: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 8
        view.alpha = 0
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "No internet connection"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var isBannerSetup = false
    private var isCurrentlyOffline = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkNetworkStatus),
            name: NSNotification.Name.connectivityStatus,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupBanner()
        checkNetworkStatus()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupBanner() {
        guard !isBannerSetup else { return }

        view.addSubview(offlineBanner)
        offlineBanner.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            offlineBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            offlineBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offlineBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offlineBanner.heightAnchor.constraint(equalToConstant: 50),

            errorLabel.centerXAnchor.constraint(equalTo: offlineBanner.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: offlineBanner.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: offlineBanner.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: offlineBanner.trailingAnchor)
        ])

        isBannerSetup = true
    }

    func showOfflineBanner() {
        guard !isCurrentlyOffline else { return }
        isCurrentlyOffline = true

        DispatchQueue.main.async {
            self.offlineBanner.isHidden = false
            self.offlineBanner.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)

            UIView.animate(withDuration: 0.3) {
                self.offlineBanner.alpha = 1
            }
        }
    }

    func hideOfflineBanner() {
        guard isCurrentlyOffline else { return }
        isCurrentlyOffline = false

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.offlineBanner.alpha = 0
            }) { _ in
                self.offlineBanner.isHidden = true

            }
        }
    }

    @objc
    func checkNetworkStatus() {
        if NetworkMonitor.shared.isConnected {
            hideOfflineBanner()
        } else {
            showOfflineBanner()
        }
    }
}
