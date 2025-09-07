//
//  FilmVC.swift
//  CodeFlix
//
//  Created by Gryaznoy Alexander on 17.08.2025.
//
import UIKit

final class FilmVC: UIViewController {
    
    // MARK: - Private properties
    private let film: Film

    let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    private let filmCover = UIImageView()
    private let filmTitle = UILabel()
    private let ratingAndAlternativeName = UILabel()
    private let filmYearAndGenres: UILabel = UILabel()
    private let filmCountriesAndLength: UILabel = UILabel()
    private let actionBar: UIStackView = UIStackView()
    private let filmDescription: UILabel = UILabel()
    
    // MARK: - init
    
    init(film: Film) {
        self.film = film
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPoster()
        setupUI()
        setupLayout()
    }
    
    //MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground

        setupFilmCover()
        setupTitle()
        setupRatingAndAlternativeName()
        setupYearAndGenres()
        setupCountriesAndLength()
        setupActionBar()
        setupDescription()

        scrollView.contentInsetAdjustmentBehavior = .never

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // add subviews
        [filmCover,
         filmTitle,
         ratingAndAlternativeName,
         filmYearAndGenres,
         filmCountriesAndLength,
         actionBar,
         filmDescription].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupFilmCover() {
        filmCover.contentMode = .scaleAspectFit
        filmCover.clipsToBounds = true
    }
    
    private func setupTitle() {
        filmTitle.text = film.title
        filmTitle.font = .systemFont(ofSize: 27, weight: .bold)
        filmTitle.textColor = .label
        filmTitle.textAlignment = .center
        filmTitle.numberOfLines = 2
        filmTitle.lineBreakMode = .byTruncatingTail
    }

    private func setupRatingAndAlternativeName() {
        ratingAndAlternativeName.text = film.alternativeName?.description ?? ""

        ratingAndAlternativeName.font = .systemFont(ofSize: 14, weight: .medium)
        ratingAndAlternativeName.textColor = .secondaryLabel
        ratingAndAlternativeName.textAlignment = .center
        ratingAndAlternativeName.numberOfLines = 0

    }

    private func setPoster() {
        ImageService.shared.loadImage(from: film.poster?.url) { [weak self] image in
            self?.filmCover.image = image ?? UIImage(named: "placeholder")
        }
    }

    private func setupYearAndGenres() {
        let year: [String] = {
            guard let year = film.year else { return [] }
            return [String(year)]
        }()
        let genres = film.genres?.map { $0.name } ?? []
        let result = (year + genres).joined(separator: ", ")
        filmYearAndGenres.text = result

        filmYearAndGenres.font = .systemFont(ofSize: 14, weight: .medium)
        filmYearAndGenres.textColor = .secondaryLabel
        filmYearAndGenres.textAlignment = .center
        filmYearAndGenres.numberOfLines = 0
    }

    private func setupCountriesAndLength() {
        let countries = film.countries?.map { $0.name } ?? []

        let filmLength: [String] = {
            guard let length = film.movieLength else { return [] }
            return ["\(String(length / 60)) ч " + "\(String(length % 60)) мин"]
        }()
        filmCountriesAndLength.text = (countries + filmLength).joined(separator: ", ")

        filmCountriesAndLength.font = .systemFont(ofSize: 14, weight: .medium)
        filmCountriesAndLength.textColor = .secondaryLabel
        filmCountriesAndLength.textAlignment = .center
        filmCountriesAndLength.numberOfLines = 0
    }

    private func setupActionBar() {
        let items: [CustomActionButton] = [
            CustomActionButton(typeAction: FilmActionsType.like),
            CustomActionButton(typeAction: FilmActionsType.watchLater),
            CustomActionButton(typeAction: FilmActionsType.share),
            CustomActionButton(typeAction: FilmActionsType.more),
        ]

        for item in items {
            actionBar.addArrangedSubview(item)
        }

        actionBar.axis = .horizontal
        actionBar.distribution = .fillEqually
    }

    private func setupDescription() {
        filmDescription.text = film.description

        filmDescription.font = .systemFont(ofSize: 16, weight: .light)
        filmDescription.textColor = .label
        filmDescription.numberOfLines = 0
    }

    func creatingImageWithLabel(image: UIImage, text: String) -> UIStackView {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .secondaryLabel
        button.imageView?.contentMode = .scaleAspectFit

        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [button, label])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }

    //MARK: - Layout
    
    func setupLayout() {
        [
            scrollView,
            contentView,
            filmCover,
            filmTitle,
            filmYearAndGenres,
            filmDescription,
            filmCountriesAndLength,
            ratingAndAlternativeName,
            actionBar,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            filmCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            filmCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filmCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            filmCover.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            filmCover.heightAnchor.constraint(equalTo: filmCover.widthAnchor),

            filmTitle.topAnchor.constraint(equalTo: filmCover.bottomAnchor, constant: 15),
            filmTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            filmTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            ratingAndAlternativeName.topAnchor.constraint(equalTo: filmTitle.bottomAnchor, constant: 15),
            ratingAndAlternativeName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ratingAndAlternativeName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            filmYearAndGenres.topAnchor.constraint(equalTo: ratingAndAlternativeName.bottomAnchor),
            filmYearAndGenres.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            filmYearAndGenres.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            filmCountriesAndLength.topAnchor.constraint(equalTo: filmYearAndGenres.bottomAnchor),
            filmCountriesAndLength.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            filmCountriesAndLength.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            actionBar.topAnchor.constraint(equalTo: filmCountriesAndLength.bottomAnchor, constant: 20),
            actionBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            actionBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),

            filmDescription.topAnchor.constraint(equalTo: actionBar.bottomAnchor, constant: 30),
            filmDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            filmDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            filmDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -90)
        ])
    }
}
