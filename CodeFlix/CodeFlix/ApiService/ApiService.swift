//
//  ApiService.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

// потом под протокол надо будет завести

import Foundation

class ApiService {
    private let apiKey = "EGPARVP-T1C4CP0-PJCZ9SE-6TH4NVG"
    private let baseUrl = "https://api.kinopoisk.dev/v1.3/movie"

    func searchMovies(query: String, completion: @escaping (Result<[Film], Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let url = URL(string: "\(baseUrl)?name=\(encodedQuery)&limit=20")!
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
                let response = try JSONDecoder().decode(FilmsSearchResponse.self, from: data ?? Data())
                completion(.success(response.films))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchHighRatedMovies(completion: @escaping (Result<[Film], Error>) -> Void) {
        let url = URL(string: "\(baseUrl)?rating.imdb=8-10&limit=20&sortField=votes.imdb&sortType=-1")!
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
                let response = try JSONDecoder().decode(FilmsSearchResponse.self, from: data ?? Data())
                completion(.success(response.films))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
