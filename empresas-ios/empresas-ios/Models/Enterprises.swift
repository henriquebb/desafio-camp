//
//  Enterprises.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 08/04/21.
//

import Foundation

struct Enterprises: Decodable {
    var enterprises: [EnterpriseInfo]?

    enum CodingKeys: String, CodingKey {
        case enterprises
    }
}
