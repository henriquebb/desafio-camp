//
//  EnterpriseType.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 08/04/21.
//

import Foundation

struct EnterpriseType: Decodable {
    var typeID: Int?
    var enterpriseTypeName: String?

    enum CodingKeys: String, CodingKey {
        case typeID = "id"
        case enterpriseTypeName = "enterprise_type_name"
    }
}
