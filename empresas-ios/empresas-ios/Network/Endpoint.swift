//
//  Endpoint.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 05/04/21.
//

import Foundation

struct Endpoint {
    var url: URL?
    var host: String = "https://empresas.ioasys.com.br"
    init() {
        url = URL(string: host)
    }
    init(withHost: String) {
        url = URL(string: withHost)
    }
    init(withPath: Path) {
        self.url = URL(string: host)
        url?.appendPathComponent(withPath.rawValue)
    }
    init(withPath: String) {
        self.url = URL(string: host)
        url?.appendPathComponent(withPath)
    }
}
