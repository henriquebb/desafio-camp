//
//  Investor.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 04/04/21.
//

import Foundation

struct Investor: Decodable {
    var investorID: Int
    var investorName: String
    var email: String
    var city: String
    var country: String
    var balance: Double
    var photo: String?
    var portfolio: Portfolio
    var firstAccess: Bool
    var superAngel: Bool

    enum CodingKeys: String, CodingKey {
        case investorID = "id"
        case investorName = "investor_name"
        case email
        case city
        case country
        case balance
        case photo
        case portfolio
        case firstAccess = "first_access"
        case superAngel = "super_angel"
    }
}
