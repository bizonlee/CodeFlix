//
//  FilmModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

struct Film: Decodable {
    let title: String
    let year: Int?

    private enum CodingKeys: String, CodingKey {
        case title = "name"
        case year
    }
}

struct FilmsSearchResponse: Decodable {
    let films: [Film]

    enum CodingKeys: String, CodingKey {
        case films = "docs"
    }
}
