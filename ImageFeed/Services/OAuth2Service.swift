//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 02.09.2023.
//

import Foundation

// MARK: - OAuth2Service
final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    private init() { }
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        
        task?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        
        let fulfillCompletionOnMainThread: (Result<OAuthTokenResponseBody, Error>) -> Void = { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(body))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.task = nil
                    self.lastCode = nil
                }
            }
        }
        
        let task = urlSession.objectTask(request: request, fulfillCompletionOnMainThread: fulfillCompletionOnMainThread)
        
        self.task = task
        task.resume()
    }
}

func makeGenericError() {
// TODO: handle
}

// MARK: - Helpers for sprint 10
extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}

// MARK: - Helpers for sprint 11
extension OAuth2Service {    
    func photosRequest(page: Int, perPage: Int) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/photos?"
          + "page=\(page)"
          + "&&per_page=\(perPage)",
                                   httpMethod: "GET"
        )
    }
    
    func likeRequest(photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
          path: "/photos/\(photoId)/like",
          httpMethod: "POST"
        )
    }
    
    func unlikeRequest(photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
          path: "/photos/\(photoId)/like",
          httpMethod: "DELETE"
        )
    }
}
