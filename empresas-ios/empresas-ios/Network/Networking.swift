//
//  Networking.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 03/04/21.
//

import Foundation

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

class Networking {

    var header: [AnyHashable: Any]?

    func request(url: URL,
                 method: HttpMethod,
                 header: [String: String]?,
                 body: Data?,
                 completion: @escaping (_: Data, _: HTTPURLResponse) -> Void) {

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = method.rawValue
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            }
            guard let response = response as? HTTPURLResponse else {
                return
            }
            self.header = response.allHeaderFields
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                completion(data, response)
            }
        }.resume()
    }

    func encodeToJSON<T: Encodable>(data: T) -> Data? {
        do {
            return try JSONEncoder().encode(data)
        } catch {
            return nil
        }
    }

    func decodeFromJSON<T: Decodable>(type: T.Type, data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }

    func getHeaderValue(forKey: String) -> String {
        return header?[forKey] as? String ?? ""
    }
}
