//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 17.09.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    private init() { }

    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = profileImageRequest(username: username)
        let task = object(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let profileImageURLs: UserResult? = body
                    
                    guard let profileImageURLs = profileImageURLs else {
                        return
                    }

                    let avatarSmallURL = profileImageURLs.profileImage.small
                    
                    self.avatarURL = avatarSmallURL
                    completion(.success(avatarSmallURL))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func profileImageRequest(username: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET", baseURL: URL(string: "https://api.unsplash.com")!)
        request.setValue("Client-ID \(AccessKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result { try decoder.decode(UserResult.self, from: data) }
            }
            completion(response)
        }
    }
}


//MARK: - Profile image URLs model
struct UserResult: Decodable {
    let profileImage: ImageForProfile
    
    private enum UserResultCodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserResultCodingKeys.self)

        self.profileImage = try container.decode(ImageForProfile.self, forKey: .profileImage)
    }
}

struct ImageForProfile: Codable {
    let small: String
    let medium: String
    let large: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        small = try container.decode(String.self, forKey: .small)
        medium = try container.decode(String.self, forKey: .medium)
        large = try container.decode(String.self, forKey: .large)
    }
}

