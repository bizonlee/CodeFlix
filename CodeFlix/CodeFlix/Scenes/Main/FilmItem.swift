//
//  FilmItem.swift
//  CodeFlix
//
//  Created by Gryaznoy Alexander on 11.09.2025.
//
import UIKit

final class FilmItem: UICollectionViewCell {

    // MARK: - Private properties

    private let filmCover: UIImageView = {
        let cover = UIImageView()
        cover.contentMode = .scaleAspectFit
        return cover
    }()
    private let filmTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 15, weight: .medium)
        title.textColor = .white
        title.numberOfLines = 0
        title.textAlignment = .center
        
        return title
    }()

    private var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(filmCover)
        contentView.addSubview(filmTitle)
    }

    func configure(title: String, imageURL: String) {
        filmTitle.text = title
        ImageService.shared.loadImage(from: imageURL) { [weak self] image in
            self?.filmCover.image = image ?? UIImage(named: "placeholder")
        }
    }

    // MARK: - Setup Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        filmCover.frame = .init(
            origin: .zero,
            size: .init(
                width: contentView.bounds.width,
                height: contentView.bounds.height - 30))

        filmTitle.frame = .init(
            origin: .init(
                x: contentView.bounds.minX,
                y: filmCover.frame.maxY),
            size: .init(
                width: contentView.bounds.width,
                height: 30))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
