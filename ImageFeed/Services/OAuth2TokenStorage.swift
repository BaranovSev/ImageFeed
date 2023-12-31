//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 07.09.2023.
//

import Foundation

// MARK: - Storage
final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case token
    }
    var token: String? {
        get {
            guard let data = userDefaults.data(forKey: Keys.token.rawValue),
                  let record = try? JSONDecoder().decode(String.self, from: data) else {
                return nil
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            
            userDefaults.set(data, forKey: Keys.token.rawValue)
        }
    }
}
