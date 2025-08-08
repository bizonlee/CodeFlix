//
//  ApiService.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

import Foundation

// потом под протокол надо будет завести

class ApiService {
    private let apiKey = "a724f676"
    private let baseUrl = "https://www.omdbapi.com/"

    func searchMovies(query: String, completion: @escaping ([Film]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseUrl)?apikey=\(apiKey)&s=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }

            do {
                let response = try JSONDecoder().decode(FilmsSearchResponse.self, from: data)
                completion(response.Search, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
