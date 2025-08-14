//
//  FilmCell.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

import UIKit

class FilmCell: UITableViewCell {
    private lazy var layout = FilmCellLayout()

    private lazy var previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 6
        iv.backgroundColor = .systemGray5
        return iv
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .label
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        [previewImageView, titleLabel, releaseDateLabel, menuButton].forEach {
            contentView.addSubview($0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewImageView.frame = layout.previewImageViewFrame
        titleLabel.frame = layout.titleLabelFrame
        releaseDateLabel.frame = layout.releaseDateLabelFrame
        menuButton.frame = layout.menuButtonFrame
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout.calculateLayout(
            for: size.width,
            title: titleLabel.text ?? "",
            releaseDate: releaseDateLabel.text ?? ""
        )
        return layout.cellSize
    }

    func configure(with film: Film) {
        titleLabel.text = film.title
        releaseDateLabel.text = ""
        layout.calculateLayout(
            for: bounds.width,
            title: film.title,
            releaseDate: ""
        )
        setNeedsLayout()
    }

    func setImage(_ image: UIImage?) {
        previewImageView.image = image ?? UIImage(named: "placeholder")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
    }
}
