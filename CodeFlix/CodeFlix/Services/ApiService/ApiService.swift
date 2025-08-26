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
    private let filmsCountPerPage: Int = 10

    private func performRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<[Film], Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let url = URL(string: "\(baseUrl)?page=\(page)&limit=\(filmsCountPerPage)&name=\(encodedQuery)")!
        performRequest(url: url) { (result: Result<FilmsSearchResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.docs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchHighRatedMovies(completion: @escaping (Result<[Film], Error>) -> Void) {
        let url = URL(string: "\(baseUrl)?rating.kp=8-10&limit=20&sortField=votes.kp&sortType=-1")!

        performRequest(url: url) { (result: Result<FilmsSearchResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.docs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
