//
//  NetworkService.swift
//  GithubProject
//
//  Created by Manish Kumar on 16/07/24.
//

import Foundation

enum APIEndpoint {
    static let baseURL = "https://api.github.com"
    
    case userDetails(username: String)
    case userFollowers(username: String)
    case searchUsers(query: String, page: Int)
    
    var urlString: String {
        switch self {
        case .userDetails(let username):
            return "\(APIEndpoint.baseURL)/users/\(username)"
        case .userFollowers(let username):
            return "\(APIEndpoint.baseURL)/users/\(username)/followers"
        case .searchUsers(let query, let page):
            return "\(APIEndpoint.baseURL)/search/users?q=\(query)&page=\(page)"
        }
    }
    var url: URL? {
        return URL(string: urlString)
    }
}

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchUserDetails(username: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = APIEndpoint.userDetails(username: username).url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchUserFollowers(username: String, completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = APIEndpoint.userFollowers(username: username).url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let followers = try JSONDecoder().decode([User].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchUsers(query: String, page: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = APIEndpoint.searchUsers(query: query, page: page).url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(.success(searchResult.items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
