//
//  User.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 03/04/21.
//

import Foundation

struct User: Codable {
    var email: String = ""
    var password: String = ""
    var accessToken: String = ""
    var client: String = ""
    var userId: String = ""

    enum CodingKeys: String, CodingKey {
        case email
        case password
        case accessToken = "access-token"
        case client
        case userId = "id"
    }
}
