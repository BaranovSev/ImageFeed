//
//  ProfileModels.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 17.09.2023.
//

import Foundation

//MARK: - ProfileResult model of responce
struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    let email: String
    
    private enum ProfileResultCodingKeys: String, CodingKey {
        case username
        case bio
        case email
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProfileResultCodingKeys.self)
        
        self.username = try container.decode(String.self, forKey: .username)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.bio = try container.decode(String.self, forKey: .bio)
        self.email = try container.decode(String.self, forKey: .email)
    }
}

//MARK: - Profile image URLs model
struct ProfileImageURLs: Decodable {
    let profileImage: ImageForProfile
    
    private enum CodingKeysProfileImageURLs: String, CodingKey {
        case profileImage = "profile_image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeysProfileImageURLs.self)

        self.profileImage = try container.decode(ImageForProfile.self, forKey: .profileImage)
    }
}

struct ImageForProfile: Codable {
    let small: URL
    let medium: URL
    let large: URL

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        small = try container.decode(URL.self, forKey: .small)
        medium = try container.decode(URL.self, forKey: .medium)
        large = try container.decode(URL.self, forKey: .large)
    }
}

//MARK: - Profile model
struct Profile: Codable {
    let username, loginName, firstName, lastName, name, bio, email: String
    
    init(username: String,
         firstName: String,
         lastName: String,
         bio: String,
         email: String
    ) {
        self.username = username
        self.loginName = "@\(username)"
        self.firstName = firstName
        self.lastName = lastName
        self.name = firstName + " " + lastName
        self.bio = bio
        self.email = email
    }
}


