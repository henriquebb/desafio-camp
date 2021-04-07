//
//  Portfolio.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 04/04/21.
//

import Foundation

struct Portfolio: Decodable {
    var enterprisesNumber: Int?
    var enterprises: [String]

    enum CondingKeys: String, CodingKey {
        case enterprisesNumber = "enterprises_number"
        case enterprises = "enterprises"
    }
}
