//
//  APICaller.swift
//  NetflixClone
//
//  Created by Aaron Johncock on 03/11/2022.
//

import Foundation

struct Constants {
    static let APIKey = "6e9e9b065d74dd788d2623c8ff1225b2"
    static let baseUrl = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/all/day?api_key=\(Constants.APIKey)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
}
