//
//  FilmCell.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

import UIKit

class FilmCell: UITableViewCell {
    private lazy var layout = FilmCellLayout()
    private var viewModel: FilmCellViewModel?

    lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .systemGray5
        return imageView
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        for item in [previewImageView, titleLabel, releaseDateLabel, menuButton] {
            contentView.addSubview(item)
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
        layout.calculateLayout(for: size.width,
                               title: titleLabel.text ?? "",
                               releaseDate: releaseDateLabel.text ?? "")
        return layout.cellSize
    }

    func configure(with viewModel: FilmCellViewModel) {
        self.viewModel = viewModel

        titleLabel.text = viewModel.film.title
        releaseDateLabel.text = viewModel.film.year.map { String($0) } ?? ""
        previewImageView.image = nil
        let currentUrl = viewModel.film.poster?.url

        viewModel.loadImage { [weak self] image in

            DispatchQueue.main.async {
                if currentUrl == self?.viewModel?.film.poster?.url {
                    self?.previewImageView.image = image
                }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        viewModel?.cancelImageDownloadTask()
        viewModel = nil
    }
}
