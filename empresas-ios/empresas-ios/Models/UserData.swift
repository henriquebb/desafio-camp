//
//  UserData.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 04/04/21.
//

import Foundation

struct UserData: Decodable {
    var investor: Investor
    var enterprise: String?
    var success: Bool?

    enum CodingKeys: String, CodingKey {
        case investor
        case enterprise
        case success
    }
}
