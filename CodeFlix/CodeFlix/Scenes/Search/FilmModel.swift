//
//  FilmModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

struct Film: Decodable, Hashable {
    let id: Int
    let title: String
    let year: Int?
    let poster: Poster?
    let movieLength: Int?
    let countries: [Countries]?
    let genres: [Genres]?
    let description: String?
    let type: String?
    let alternativeName: String?
    let rating: Rating

    private enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case year
        case poster
        case movieLength
        case countries
        case genres
        case description
        case type
        case alternativeName
        case rating
    }
}

struct Poster: Decodable, Hashable {
    let url: String?
}

struct Countries: Decodable, Hashable {
    let name: String
}

struct Genres: Decodable, Hashable {
    let name: String
}

struct FilmsSearchResponse: Decodable {
    let docs: [Film]
}

struct Rating: Decodable, Hashable {
    let imdb: Double?
}
