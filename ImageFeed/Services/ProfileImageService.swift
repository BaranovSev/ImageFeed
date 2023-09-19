//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 17.09.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    private init() { }

    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = profileImageRequest(username: username)
        let fulfillCompletionOnMainThread: (Result<UserResult, Error>) -> Void = { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let profileImageURLs: UserResult? = body
                    
                    guard let profileImagesURLs = profileImageURLs else {
                        return
                    }

                    let profileImageURL = profileImagesURLs.profileImage.small
                    
                    self.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.DidChangeNotification,
                            object: self,
                            userInfo: ["URL": profileImageURL])
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.task = nil
                }
            }
        }
        
        let task = urlSession.objectTask(request: request, fulfillCompletionOnMainThread: fulfillCompletionOnMainThread)
        
        self.task = task
        task.resume()
    }
    
    private func profileImageRequest(username: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET", baseURL: URL(string: "https://api.unsplash.com")!)
        request.setValue("Client-ID \(AccessKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}


