//
//  NetworkManager.swift
//
//
//  Created by Gheorghi Petis on 15.06.2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case error(err: String)
    case decodingError(err: String)
}

public final class NetworkManager<T: Codable> {

    public static func fetch(for url: URL, completion: @escaping(Result<T, NetworkError>) -> Void) {

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(String(describing: error!))
                completion(.failure(.error(err: error!.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(.success(json))
            } catch let err {
                print(err.localizedDescription)
                completion(.failure(.decodingError(err: err.localizedDescription)))
            }

        }.resume()
    }

}
