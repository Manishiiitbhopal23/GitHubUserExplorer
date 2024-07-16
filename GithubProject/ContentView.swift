//
//  ContentView.swift
//  GithubProject
//
//  Created by Manish Kumar on 16/07/24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GitHubViewModel()
    @State private var username: String = ""
    @State private var query: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Fetch User Details") {
                    viewModel.fetchUserDetails(username: username)
                }
                .padding()
                
                if let user = viewModel.user {
                    VStack {
                        AsyncImage(url: URL(string: user.avatar_url)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        
                        Text(user.login)
                            .font(.largeTitle)
                        
                        Text(user.url)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                // Handle URL tap
                            }
                        
                        Button("Fetch Followers") {
                            viewModel.fetchUserFollowers(username: username)
                        }
                        .padding()
                        
                        if !viewModel.followers.isEmpty {
                            List(viewModel.followers) { follower in
                                HStack {
                                    AsyncImage(url: URL(string: follower.avatar_url)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    
                                    Text(follower.login)
                                }
                            }
                        }
                    }
                }
                
                Divider()
                    .padding()
                
                TextField("Search users", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Search") {
                    viewModel.searchUsers(query: query, page: 1)
                }
                .padding()
                
                if !viewModel.searchResults.isEmpty {
                    List(viewModel.searchResults) { user in
                        HStack {
                            AsyncImage(url: URL(string: user.avatar_url)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            
                            Text(user.login)
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .navigationTitle("GitHub Users")
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
