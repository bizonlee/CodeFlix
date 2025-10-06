//
//  FilmCell.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

import UIKit

protocol FilmCellDelegate: AnyObject {
    func filmCellDidTapMenu(_ cell: FilmCell, film: Film, sourceView: UIView)
}

class FilmCell: UITableViewCell {
    private lazy var layout = FilmCellLayout()
    private var viewModel: FilmCellViewModel?
    private var filmViewedManager: FilmViewedManagerProtocol = FilmViewedManager()
    weak var delegate: FilmCellDelegate?

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

    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .systemGray
        return label
    }()

    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var flagView: FlagView = {
        let view = FlagView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupFlagView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        for item in [previewImageView, titleLabel, releaseDateLabel, ratingLabel, menuButton] {
            contentView.addSubview(item)
        }
    }

    private func setupFlagView() {
        contentView.addSubview(flagView)
        NSLayoutConstraint.activate([
            flagView.topAnchor.constraint(equalTo: contentView.topAnchor),
            flagView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            flagView.widthAnchor.constraint(equalToConstant: 25),
            flagView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewImageView.frame = layout.previewImageViewFrame
        titleLabel.frame = layout.titleLabelFrame
        releaseDateLabel.frame = layout.releaseDateLabelFrame
        ratingLabel.frame = layout.ratingLabelFrame
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
        ratingLabel.text = viewModel.film.rating.kp.map {
            String(format: "%.1f", $0)
        } ?? ""

        let posterUrl = viewModel.film.poster?.url

        previewImageView.image = UIImage(named: "new_launch_image")

        if let posterUrl = posterUrl, !posterUrl.isEmpty {
            viewModel.loadImage { [weak self] image in
                DispatchQueue.main.async {
                    if posterUrl == self?.viewModel?.film.poster?.url {

                        self?.previewImageView.image = image ?? UIImage(named: "new_launch_image")
                    }
                }
            }
        }
        updateCellState()
    }

    private func updateCellState() {
        if filmViewedManager.isViewed(with: (viewModel?.film.id)!) {
            contentView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        } else {
            contentView.backgroundColor = .clear
        }

        guard let filmId = viewModel?.film.id else {
            flagView.isHidden = true
            return
        }
        flagView.isHidden = !filmViewedManager.isMarkedForWatching(with: filmId)
    }

    @objc
    private func menuButtonTapped() {
        guard let film = viewModel?.film else { return }
        delegate?.filmCellDidTapMenu(self, film: film, sourceView: menuButton)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        ratingLabel.text = nil
        viewModel?.cancelImageDownloadTask()
        viewModel = nil
    }
}
