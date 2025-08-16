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

    private enum CodingKeys: String, CodingKey {
        case title = "name"
        case year
        case poster
    }
}

struct Poster: Decodable {
    let url: String?
}

struct FilmsSearchResponse: Decodable {
    let docs: [Film]

//    enum CodingKeys: String, CodingKey {
//        case films = "docs"
//    }
}
