//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 07.09.2023.
//

import Foundation
import SwiftKeychainWrapper

// MARK: - Storage
final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case token
    }
    var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
            return token
        }
        
        set {
            guard let newValue = newValue else {
                return
            }
            
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
            guard isSuccess else {
                return
            }
        }
    }
}
