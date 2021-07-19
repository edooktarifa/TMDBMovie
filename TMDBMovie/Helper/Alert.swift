//
//  Alert.swift
//  TMDBMovie
//
//  Created by Phincon on 11/07/21.
//

import Foundation

struct AlertError {
    let title: String
    let description: String
    let action: AlertAction
}

struct AlertAction {
    let title: String
    let handle: (() -> Void)?
}
