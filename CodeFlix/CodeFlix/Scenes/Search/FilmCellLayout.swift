//
//  FilmCellLayout.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 14.08.2025.
//

import UIKit

class FilmCellLayout {
    private enum Constants {
        static let imageWidth: CGFloat = 100
        static let imageHeight: CGFloat = 150
        static let padding: CGFloat = 12
        static let buttonSize: CGFloat = 24
        static let textSpacing: CGFloat = 8
        static let minCellHeight: CGFloat = 170
    }

    var previewImageViewFrame = CGRect.zero
    var menuButtonFrame = CGRect.zero
    var titleLabelFrame = CGRect.zero
    var releaseDateLabelFrame = CGRect.zero
    var ratingLabelFrame = CGRect.zero
    var cellSize = CGSize.zero

    func calculateLayout(for cellWidth: CGFloat,
                         title: String,
                         releaseDate: String) {
        let contentWidth = cellWidth

        previewImageViewFrame = CGRect(
            x: Constants.padding,
            y: Constants.padding,
            width: Constants.imageWidth,
            height: Constants.imageHeight
        )

        let textX = previewImageViewFrame.maxX + Constants.padding
        let textWidth = contentWidth - textX - Constants.buttonSize - Constants.padding * 2

        let titleHeight = heightForText(title, width: textWidth, font: .systemFont(ofSize: 18, weight: .semibold))
        let dateHeight = heightForText(releaseDate, width: textWidth, font: .systemFont(ofSize: 15, weight: .medium))

        var yOffset = Constants.padding

        titleLabelFrame = CGRect(
            x: textX,
            y: yOffset,
            width: textWidth,
            height: titleHeight
        )
        yOffset += titleHeight + Constants.textSpacing

        releaseDateLabelFrame = CGRect(
            x: textX,
            y: yOffset,
            width: textWidth,
            height: dateHeight
        )

        yOffset += dateHeight + Constants.textSpacing

        ratingLabelFrame = CGRect(
            x: textX,
            y: yOffset,
            width: textWidth,
            height: dateHeight
        )

        let contentHeight = max(
            Constants.imageHeight + 2 * Constants.padding,
            titleHeight + dateHeight + 3 * Constants.textSpacing
        )

        menuButtonFrame = CGRect(
            x: contentWidth - Constants.buttonSize - Constants.padding,
            y: (contentHeight - Constants.buttonSize) / 2,
            width: Constants.buttonSize,
            height: Constants.buttonSize
        )

        cellSize = CGSize(
            width: cellWidth,
            height: max(contentHeight, Constants.minCellHeight)
        )
    }

    private func heightForText(_ text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}
