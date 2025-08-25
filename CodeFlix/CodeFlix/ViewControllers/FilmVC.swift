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

    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    private let filmCover: UIImageView = UIImageView()
    private let filmTitle: UILabel = UILabel()
    private let ratingAndAlternativeName: UILabel = UILabel()
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
        //scrollView.bouncesVertically = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // add subviews
        [filmCover,
         filmTitle,
         ratingAndAlternativeName,
         filmYearAndGenres,
         filmCountriesAndLength,
         actionBar,
         filmDescription].forEach{contentView.addSubview($0)}
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
        filmYearAndGenres.text = film.year?.description

        for genre in film.genres ?? [] {
            filmYearAndGenres.text!+=", \(genre.name.description)"
        }

        filmYearAndGenres.font = .systemFont(ofSize: 14, weight: .medium)
        filmYearAndGenres.textColor = .secondaryLabel
        filmYearAndGenres.textAlignment = .center
        filmYearAndGenres.numberOfLines = 0
    }

    private func setupCountriesAndLength() {
        filmCountriesAndLength.text = ""

        for country in film.countries ?? [] {
            filmCountriesAndLength.text! += "\(country.name.description), "
        }

        if film.type == "movie" {
            let hour = Int(film.movieLength ?? 0) / 60
            let minutes = Int(film.movieLength ?? 0) % 60

            if hour > 0 {
                filmCountriesAndLength.text! += " \(hour) ч"
            }

            if minutes > 0 {
                filmCountriesAndLength.text! += " \(minutes) мин"
            }
        }

        filmCountriesAndLength.font = .systemFont(ofSize: 14, weight: .medium)
        filmCountriesAndLength.textColor = .secondaryLabel
        filmCountriesAndLength.textAlignment = .center
        filmCountriesAndLength.numberOfLines = 0
    }

    private func setupActionBar() {
        let items: [(UIImage, String)] = [
            (UIImage(systemName: "star") ?? UIImage(), "Оценить"),
            (UIImage(systemName: "bookmark") ?? UIImage(), "Буду смотреть"),
            (UIImage(systemName: "square.and.arrow.up") ?? UIImage(), "Поделиться"),
            (UIImage(systemName: "ellipsis") ?? UIImage(), "Ещё")
        ]

        for item in items {
            let itemStack = creatingImageWithLabel(image: item.0, text: item.1)
            actionBar.addArrangedSubview(itemStack)
        }

        actionBar.axis = .horizontal
        actionBar.distribution = .fillEqually
        //actionBar.spacing = 10

    }

    private func setupDescription() {
        filmDescription.text = film.description

        filmDescription.font = .systemFont(ofSize: 16, weight: .light)
        filmDescription.textColor = .label
        filmDescription.numberOfLines = 0
    }

     func creatingImageWithLabel(image: UIImage, text: String) -> UIStackView {
        let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .secondaryLabel
            imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = .secondaryLabel

            let stack = UIStackView(arrangedSubviews: [imageView, label])
            stack.axis = .vertical
            stack.spacing = 5
            return stack
    }


    //MARK: - Layout
    
    func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        filmCover.translatesAutoresizingMaskIntoConstraints = false
        filmTitle.translatesAutoresizingMaskIntoConstraints = false
        filmYearAndGenres.translatesAutoresizingMaskIntoConstraints = false
        filmDescription.translatesAutoresizingMaskIntoConstraints = false
        filmCountriesAndLength.translatesAutoresizingMaskIntoConstraints = false
        ratingAndAlternativeName.translatesAutoresizingMaskIntoConstraints = false
        actionBar.translatesAutoresizingMaskIntoConstraints = false

        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        filmCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100).isActive = true
        filmCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        filmCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        filmCover.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        filmCover.heightAnchor.constraint(equalTo: filmCover.widthAnchor).isActive = true
        
        filmTitle.topAnchor.constraint(equalTo: filmCover.bottomAnchor, constant: 15).isActive = true
        filmTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        filmTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true

        ratingAndAlternativeName.topAnchor.constraint(equalTo: filmTitle.bottomAnchor, constant: 15).isActive = true
        ratingAndAlternativeName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        ratingAndAlternativeName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true

        filmYearAndGenres.topAnchor.constraint(equalTo: ratingAndAlternativeName.bottomAnchor).isActive = true
        filmYearAndGenres.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        filmYearAndGenres.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true

        filmCountriesAndLength.topAnchor.constraint(equalTo: filmYearAndGenres.bottomAnchor).isActive = true
        filmCountriesAndLength.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        filmCountriesAndLength.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true

        actionBar.topAnchor.constraint(equalTo: filmCountriesAndLength.bottomAnchor, constant: 20).isActive = true
        actionBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        actionBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true

        filmDescription.topAnchor.constraint(equalTo: actionBar.bottomAnchor, constant: 30).isActive = true
        filmDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        filmDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        filmDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -90).isActive = true
    }
}
