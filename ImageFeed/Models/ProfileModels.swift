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
        self.lastName = try container.decode(String?.self, forKey: .lastName) ?? ""
        self.bio = try container.decode(String?.self, forKey: .bio) ?? ""
        self.email = try container.decode(String.self, forKey: .email)
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


