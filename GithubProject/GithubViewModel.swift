//
//  GithubViewModel.swift
//  GithubProject
//
//  Created by Manish Kumar on 16/07/24.
//

import Foundation
import Combine

class GitHubViewModel: ObservableObject {
    @Published var user: User?
    @Published var followers: [User] = []
    @Published var searchResults: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUserDetails(username: String) {
        isLoading = true
        errorMessage = nil
        
        NetworkService.shared.fetchUserDetails(username: username) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchUserFollowers(username: String) {
        isLoading = true
        errorMessage = nil
        
        NetworkService.shared.fetchUserFollowers(username: username) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let followers):
                    self?.followers = followers
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func searchUsers(query: String, page: Int) {
        isLoading = true
        errorMessage = nil
        
        NetworkService.shared.searchUsers(query: query, page: page) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let searchResults):
                    self?.searchResults = searchResults
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

