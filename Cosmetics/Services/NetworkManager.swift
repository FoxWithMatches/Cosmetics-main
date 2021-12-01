//
//  NetworkManager.swift
//  Cosmetics
//
//  Created by Alisa Ts on 30.11.2021.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    static func fetchMakeUp(from url: String?, competion: @ escaping (_ makeUp: [MakeUpElement]) -> ()) {
        AF.request(Link.cosmetics.rawValue)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let makeUps = MakeUpElement.getCosmetics(from: value)
                   competion(makeUps)
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
}




