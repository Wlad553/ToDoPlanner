//
//  FBUserProfile.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 25/09/2024.
//

import Foundation

struct FBUserProfile: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
    }
    
    let id: String
    let name: String
    let email: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
    }
}
