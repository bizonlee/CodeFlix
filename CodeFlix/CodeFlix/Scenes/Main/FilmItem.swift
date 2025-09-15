//
//  FilmItem.swift
//  CodeFlix
//
//  Created by Gryaznoy Alexander on 11.09.2025.
//
import UIKit

final class FilmItem: UICollectionViewCell {

    // MARK: - Private properties

    private let filmCover = UIImageView()
    private let filmTitle = UILabel()

    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(filmCover)
        contentView.addSubview(filmTitle)
    }

    func configure(title: String, image: UIImage?) {
        filmTitle.text = title
        filmCover.image = image
        filmCover.contentMode = .scaleAspectFit
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        filmCover.frame = .init(origin:
                .init(
                    x: 0,
                    y: 0),
                                size:
                .init(
                    width: contentView.frame.width,
                    height: 100))
        filmTitle.frame = .init(origin:
                .init(
                    x: 0,
                    y: filmCover.frame.height),
                                size:
                .init(
                    width: 40,
                    height: 50))

        //filmTitle.center = contentView.center
    }





    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


////////////////

}
