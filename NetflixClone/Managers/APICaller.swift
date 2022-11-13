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
    static let YoutubeAPIKey = "AIzaSyD2zSuMe7Y_vWdD7jPTWMBQU5AsJ8DQnGo"
    static let youtubebaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(Constants.APIKey)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        dataTask.resume()
    }
    
    func getTrendingTV(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.APIKey)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        dataTask.resume()
        
    }
    
    
    func getUpcomingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.APIKey)&language=en-US&page=1") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        dataTask.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.APIKey)&language=en-US&page=1") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        dataTask.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.APIKey)&language=en-US&page=1") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        dataTask.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
    
        guard let url = URL(string: "\(Constants.baseUrl)/3/discover/movie?api_key=\(Constants.APIKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        dataTask.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Media], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseUrl)/3/search/movie?api_key=\(Constants.APIKey)&query=\(query)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        dataTask.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<Video, Error>) -> Void) {

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubebaseURL)q=\(query)&key=\(Constants.YoutubeAPIKey)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
                
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
        
    }
    
}
