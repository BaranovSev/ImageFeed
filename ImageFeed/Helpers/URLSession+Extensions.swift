//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 07.09.2023.
//

import Foundation

// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func objectTask<T: Decodable>(request: URLRequest,
                                  fulfillCompletionOnMainThread: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        return URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if
                let data = data,
                let response = response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletionOnMainThread(.success(result))
                    } catch {
                        fulfillCompletionOnMainThread(.failure(error))
                    }
                } else {
                    fulfillCompletionOnMainThread(.failure(makeGenericError() as! Error))
                }
            } else if let error = error {
                fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnMainThread(.failure(makeGenericError() as! Error))
            }
        })
    }
}
