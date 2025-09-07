//
//  CustomActionButton.swift
//  CodeFlix
//
//  Created by Gryaznoy Alexander on 07.09.2025.
//
import UIKit

final class CustomActionButton: UIButton {

    // MARK: - Private properties

    private var imageButton = UIImageView()
    private var title = UILabel()

    private var actionType: FilmActionsType
    private var isSelect: Bool = false

    // MARK: - init

    init(typeAction: FilmActionsType) {
        actionType = typeAction
        super.init(frame: .zero)

        setup()
        setupAction(typeAction: typeAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        setupImage()
        setupTitle()
    }

    //MARK: - Setup Image

    func setupImage() {
        title.text = actionType.title

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

    func setupTitle() {
        imageButton.image = actionType.imageNormalState

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

    func setupAction(typeAction: FilmActionsType) {
        switch typeAction {
        case .like:
            self.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        case .watchLater:
            addTarget(self, action: #selector(watchLaterTapped), for: .touchUpInside)
        case .share:
            addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        case .more:
            addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        }
    }

    @objc
    func likeTapped() {
        print("Like tapped")
        changeSelectedState()
    }

    @objc
    func watchLaterTapped() {
        print("Watch later tapped")
        changeSelectedState()
    }

    @objc
    func shareTapped() {
        print("Share tapped")

    }

    @objc
    func moreTapped() {
        print("More tapped")

    }

    func changeSelectedState() {
        isSelect.toggle()
        let newImage = isSelect ? actionType.imageSelectedState : actionType.imageNormalState
        UIView.transition(
            with: imageButton,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
            self.imageButton.image = newImage
        })
    }
}

enum FilmActionsType {
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
