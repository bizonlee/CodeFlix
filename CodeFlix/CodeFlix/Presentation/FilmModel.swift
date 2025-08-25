//
//  FilmModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

struct Film: Decodable {
    let title: String
    let year: Int?
    let poster: Poster?
    let movieLength: Int?
    let countries: [Countries]?
    let genres: [Genres]?
    let description: String?
    let type: String?
    let alternativeName: String?

    private enum CodingKeys: String, CodingKey {
        case title = "name"
        case year
        case poster
        case movieLength
        case countries
        case genres
        case description
        case type
        case alternativeName
    }
}

struct Poster: Decodable {
    let url: String?
}

struct Countries: Decodable {
    let name: String
}

struct Genres: Decodable {
    let name: String
}

struct FilmsSearchResponse: Decodable {
    let docs: [Film]

//    enum CodingKeys: String, CodingKey {
//        case films = "docs"
//    }
}
