//
//  FilmCell.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

import UIKit

class FilmCell: UITableViewCell {

    private enum Constants {
        static let imageWidth: CGFloat = 100
        static let imageHeight: CGFloat = 150
        static let padding: CGFloat = 12
        static let buttonSize: CGFloat = 24
        static let textSpacing: CGFloat = 8
        static let minCellHeight: CGFloat = 170
    }

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

        let contentWidth = contentView.bounds.width
        let contentHeight = contentView.bounds.height

        previewImageView.frame = CGRect(
            x: Constants.padding,
            y: Constants.padding,
            width: Constants.imageWidth,
            height: Constants.imageHeight
        )

        menuButton.frame = CGRect(
            x: contentWidth - Constants.buttonSize - Constants.padding,
            y: (contentHeight - Constants.buttonSize) / 2,
            width: Constants.buttonSize,
            height: Constants.buttonSize
        )

        // Text Content
        let textX = previewImageView.frame.maxX + Constants.padding
        let textWidth = contentWidth - textX - Constants.buttonSize - Constants.padding * 2

        let titleHeight = titleLabel.sizeThatFits(
            CGSize(width: textWidth, height: .greatestFiniteMagnitude)
        ).height

        let dateHeight = releaseDateLabel.sizeThatFits(
            CGSize(width: textWidth, height: .greatestFiniteMagnitude)
        ).height

        var yOffset = Constants.padding

        titleLabel.frame = CGRect(
            x: textX,
            y: yOffset,
            width: textWidth,
            height: titleHeight
        )
        yOffset += titleHeight + Constants.textSpacing

        releaseDateLabel.frame = CGRect(
            x: textX,
            y: yOffset,
            width: textWidth,
            height: dateHeight
        )
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let textWidth = size.width - Constants.imageWidth - Constants.buttonSize - 3 * Constants.padding

        let titleHeight = titleLabel.sizeThatFits(
            CGSize(width: textWidth, height: .greatestFiniteMagnitude)
        ).height

        let dateHeight = releaseDateLabel.sizeThatFits(
            CGSize(width: textWidth, height: .greatestFiniteMagnitude)
        ).height

        let calculatedHeight = max(
            Constants.imageHeight + 2 * Constants.padding,
            titleHeight + dateHeight + 3 * Constants.textSpacing
        )

        return CGSize(width: size.width, height: max(calculatedHeight, Constants.minCellHeight))
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
