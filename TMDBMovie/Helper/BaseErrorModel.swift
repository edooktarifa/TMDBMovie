//
//  BaseErrorModel.swift
//  TMDBMovie
//
//  Created by Phincon on 11/07/21.
//

import Foundation

struct BaseErrorModel: Codable {
    let status_message: String?
    let status_code: Int?
}
