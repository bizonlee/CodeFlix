//
//  CustomActionButton.swift
//  CodeFlix
//
//  Created by Gryaznoy Alexander on 07.09.2025.
//

import UIKit

extension UIControl.State: @retroactive Hashable {

}

final class CustomActionButton: UIControl {

    // MARK: - Private properties

    private let imageButton = UIImageView()
    private let title = UILabel()
    private var images: [UIControl.State: UIImage] = [:]

    var onTap: (() -> Void)?

    // MARK: - init

    init() {
        super.init(frame: .zero)
        setup()

        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        setupImageUI()
        setupTitleUI()
    }

    func updateAppearance() {
        let newImage = isSelected ? images[.selected] : images[.normal]
        UIView.transition(
            with: imageButton,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                self.imageButton.image = newImage
            }
        )
    }

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    //MARK: - Setup Image

    func setupImage(_ image: UIImage?, for state: UIControl.State) {
        guard let image = image else { return }

        if state == .normal {
            self.imageButton.image = image
        }
        images[state] = image
    }

    func setupImageUI() {
        addSubview(imageButton)

        imageButton.tintColor = .secondaryLabel
        imageButton.contentMode = .scaleAspectFit

        imageButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: topAnchor),
            imageButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageButton.heightAnchor.constraint(equalToConstant: 24),
            imageButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    //MARK: - Setup Title

    func setupTitle(_ title: String) {
        self.title.text = title
    }

    func setupTitleUI() {
        addSubview(title)

        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 10)
        title.textColor = .secondaryLabel

        title.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    //MARK: - Setup Actions

    func changeSelectedState() {
        isSelected.toggle()
        let newImage = isSelected ? images[.selected] : images[.normal]
        UIView.transition(
            with: imageButton,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
            self.imageButton.image = newImage
        })
    }

    @objc
    private func handleTap() {
        onTap?()
    }
}

enum FilmActionsType: CaseIterable {
    case like
    case watchLater
    case share
    case more

    var title: String {
        switch self {
        case .like:
            "Лайк"
        case .watchLater:
            "Буду смотреть"
        case .share:
            "Поделиться"
        case .more:
            "Ещё"
        }
    }

    var imageNormalState: UIImage {
        switch self {
        case .like:
            UIImage(systemName: "heart") ?? UIImage()
        case .watchLater:
            UIImage(systemName: "bookmark") ?? UIImage()
        case .share:
            UIImage(systemName: "square.and.arrow.up") ?? UIImage()
        case .more:
            UIImage(systemName: "ellipsis") ?? UIImage()
        }
    }

    var imageSelectedState: UIImage {
        switch self {
        case .like:
            UIImage(systemName: "heart.fill") ?? UIImage()
        case .watchLater:
            UIImage(systemName: "bookmark.fill") ?? UIImage()
        case .share:
            UIImage(systemName: "square.and.arrow.up") ?? UIImage()
        case .more:
            UIImage(systemName: "ellipsis") ?? UIImage()
        }
    }
}
