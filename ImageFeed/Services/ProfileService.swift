//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 14.09.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private(set) var profile: Profile?
    
    private init() { }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == token { return } //TODO: read abour Task groups in swift & async await
        
        task?.cancel()
        lastCode = token //? 
        
        let request = profileRequest(token: token)
        let task = object(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let profile = convertProfile(from: body)
                    self.profile = profile
                    completion(.success(profile))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.task = nil
                    self.lastCode = nil
                }
            }
        }
        self.task = task
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
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
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
