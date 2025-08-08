//
//  FilmModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

struct Film: Decodable {
    let title: String
    let year: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
    }
}

struct FilmsSearchResponse: Decodable {
    let Search: [Film]

    enum CodingKeys: String, CodingKey {
        case Search = "Search"
    }
}

