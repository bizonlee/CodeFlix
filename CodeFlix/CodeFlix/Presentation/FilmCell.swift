//
//  FilmCell.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

import UIKit

class FilmCell: UITableViewCell {
    private let imageWidth: CGFloat = 100
    private let imageHeight: CGFloat = 120
    private let padding: CGFloat = 10
    private let buttonSize: CGFloat = 24

    var previewImageView: UIImageView!
    var titleLabel: UILabel!
    var releaseDateLabel: UILabel!
    var ratingLabel: UILabel!
    var descriptionLabel: UILabel!
    var threeDotsButton: UIButton!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        previewImageView = UIImageView()
        previewImageView.contentMode = .scaleAspectFit
        contentView.addSubview(previewImageView)

        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)

        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)

        releaseDateLabel = UILabel()
        releaseDateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        releaseDateLabel.textColor = .secondaryLabel
        contentView.addSubview(releaseDateLabel)

        ratingLabel = UILabel()
        ratingLabel.font = .systemFont(ofSize: 14, weight: .regular)
        ratingLabel.textColor = .secondaryLabel
        contentView.addSubview(ratingLabel)

        threeDotsButton = UIButton(type: .custom)
        threeDotsButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        threeDotsButton.tintColor = .label
        contentView.addSubview(threeDotsButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let contentWidth = contentView.bounds.width
        let contentHeight = contentView.bounds.height

        previewImageView.frame = CGRect(
            x: padding,
            y: padding,
            width: imageWidth,
            height: imageHeight
        )

        threeDotsButton.frame = CGRect(
            x: contentWidth - buttonSize - padding,
            y: (contentHeight - buttonSize) / 2,
            width: buttonSize,
            height: buttonSize
        )

        let labelsX = previewImageView.frame.maxX + padding
        let labelsWidth = contentWidth - labelsX - buttonSize - 2 * padding

        let titleHeight = titleLabel.sizeThatFits(
            CGSize(width: labelsWidth, height: .greatestFiniteMagnitude)
        ).height

        let descriptionHeight = descriptionLabel.sizeThatFits(
            CGSize(width: labelsWidth, height: .greatestFiniteMagnitude)
        ).height

        let dateHeight = releaseDateLabel.sizeThatFits(
            CGSize(width: labelsWidth, height: .greatestFiniteMagnitude)
        ).height

        let ratingHeight = ratingLabel.sizeThatFits(
            CGSize(width: labelsWidth, height: .greatestFiniteMagnitude)
        ).height

        let totalTextHeight = titleHeight + descriptionHeight + dateHeight + ratingHeight + 3 * padding
        var yOffset = max(padding, (contentHeight - totalTextHeight) / 2)

        titleLabel.frame = CGRect(
            x: labelsX,
            y: yOffset,
            width: labelsWidth,
            height: titleHeight
        )
        yOffset += titleHeight + padding

        descriptionLabel.frame = CGRect(
            x: labelsX,
            y: yOffset,
            width: labelsWidth,
            height: descriptionHeight
        )
        yOffset += descriptionHeight + padding

        releaseDateLabel.frame = CGRect(
            x: labelsX,
            y: yOffset,
            width: labelsWidth,
            height: dateHeight
        )
        yOffset += dateHeight + padding

        ratingLabel.frame = CGRect(
            x: labelsX,
            y: yOffset,
            width: labelsWidth,
            height: ratingHeight
        )
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelsWidth = size.width - imageWidth - buttonSize - 3 * padding

        let titleHeight = titleLabel.sizeThatFits(
            CGSize(width: labelsWidth, height: .greatestFiniteMagnitude)
        ).height

        let descriptionHeight = descriptionLabel.sizeThatFits(
            CGSize(width: labelsWidth, height: .greatestFiniteMagnitude)
        ).height

        let dateHeight = releaseDateLabel.sizeThatFits(
            CGSize(width: labelsWidth, height: .greatestFiniteMagnitude)
        ).height

        let ratingHeight = ratingLabel.sizeThatFits(
            CGSize(width: labelsWidth, height: .greatestFiniteMagnitude)
        ).height

        let totalHeight = max(
            imageHeight + 2 * padding,
            titleHeight + descriptionHeight + dateHeight + ratingHeight + 4 * padding
        )

        return CGSize(width: size.width, height: totalHeight)
    }
}
