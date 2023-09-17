//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 14.09.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
//    private(set) var imageForProfile: ImageForProfile?
    private init() { }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = profileRequest(token: token)
        let task = object(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let profile = convertProfile(from: body)
                    
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    private func profileRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET", baseURL: URL(string: "https://api.unsplash.com")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return URLSession.shared.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
    
    // for image url
        
    func fetchImage(username: String, completion: @escaping (Result<ImageForProfile, Error>) -> Void) {
        let request = profileImageRequest(username: username)
        let task = object(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let body):
                    let profileImageURLs: ProfileImageURLs? = body
                    guard let profileImageURLs = profileImageURLs else {
                        return
                    }
                    
                    let imageURLs = profileImageURLs.profileImage
                    completion(.success(imageURLs))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    private func profileImageRequest(username: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET", baseURL: URL(string: "https://api.unsplash.com")!)
        request.setValue("Client-ID \(AccessKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileImageURLs, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return URLSession.shared.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileImageURLs, Error> in
                Result { try decoder.decode(ProfileImageURLs.self, from: data) }
            }
            completion(response)
        }
    }
}

func convertProfile(from result: ProfileResult) -> Profile {
    Profile(username: result.username,
            firstName: result.firstName,
            lastName: result.lastName,
            bio: result.bio,
            email: result.email)
}
