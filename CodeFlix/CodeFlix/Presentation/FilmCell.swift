//
//  FilmCell.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

import UIKit

class FilmCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //test github

    lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var threeDotsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func setupViews() {
        descriptionStackView.addArrangedSubview(titleLabel)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(releaseDateLabel)
        descriptionStackView.addArrangedSubview(ratingLabel)

        contentView.addSubview(previewImageView)
        contentView.addSubview(descriptionStackView)
        contentView.addSubview(threeDotsButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            previewImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            previewImageView.widthAnchor.constraint(equalToConstant: 100),
            previewImageView.heightAnchor.constraint(equalToConstant: 120),

            descriptionStackView.topAnchor.constraint(equalTo: previewImageView.topAnchor),
            descriptionStackView.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: 10),
            descriptionStackView.trailingAnchor.constraint(equalTo: threeDotsButton.leadingAnchor, constant: -10),
            descriptionStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),

            threeDotsButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            threeDotsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            threeDotsButton.widthAnchor.constraint(equalToConstant: 24),
            threeDotsButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
