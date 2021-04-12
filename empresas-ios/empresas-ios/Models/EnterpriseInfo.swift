//
//  EnterpriseInfo.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 08/04/21.
//

import Foundation

struct EnterpriseInfo: Decodable {
    var enterpriseID: Int?
    var emailEnterprise: String?
    var facebook: String?
    var twitter: String?
    var linkedin: String?
    var phone: String?
    var ownEnterprise: Bool?
    var enterpriseName: String?
    var photo: String?
    var description: String?
    var city: String?
    var country: String?
    var value: Int?
    var sharePrice: Double?
    var enterpriseType: EnterpriseType?

    enum CodingKeys: String, CodingKey {
        case enterpriseID = "id"
        case emailEnterprise = "email_enterprise"
        case facebook
        case twitter
        case linkedin
        case phone
        case ownEnterprise = "own_enterprise"
        case enterpriseName = "enterprise_name"
        case photo
        case description
        case city
        case country
        case value
        case sharePrice = "share_price"
        case enterpriseType = "enterprise_type"
    }
}
