//
//  ImageForProfile.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 19.09.2023.
//

import Foundation

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

