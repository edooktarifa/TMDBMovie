//
//  LoginModel.swift
//  TMDBMovie
//
//  Created by Phincon on 11/07/21.
//

import Foundation

struct LoginModel: Codable {
    let succes: Bool?
    let expires_at: String?
    let request_token: String?
    
    enum CodingKeys: String, CodingKey {
        case succes = "succes"
        case expires_at = "expires_at"
        case request_token = "request_token"
    }
}

struct TokenModel: Codable {
    
}
