//
//  NetworkManager.swift
//  Genz
//
//  Created by Vivek MV on 08/03/24.
//

import Foundation

enum GenxError: Error {
    case invalidURL
    case invalidData
    case invalidDecoding
}

enum GenxAPI {
    case posts
    case postDetail
    case userDetail
    
    private var baseURL: String {
         "https://3675b858-7e98-4956-9c10-ecc8d76c1b41.mock.pstmn.io" 
    }
    
    var path: String {
        switch self {
            case .posts:
                "\(baseURL)/api/feed"
            case .postDetail:
                "\(baseURL)/api/post/10001"
            case .userDetail:
                "\(baseURL)/api/profile/alice"
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: Codable>(from urlString: String, completion: @escaping (Result<T, Error>) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(GenxError.invalidURL))
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(GenxError.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("error", error)
                completion(.failure(GenxError.invalidDecoding))
            }
        }
        
        task.resume()
    }
}
