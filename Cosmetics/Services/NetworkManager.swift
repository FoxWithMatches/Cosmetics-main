//
//  NetworkManager.swift
//  Cosmetics
//
//  Created by Alisa Ts on 30.11.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    static var imageView: UIImageView?
    static var onProgress: ((Double) -> ())?
    static var completed: ((String) -> ())?
    
    private init() {}
    
    static func fetchMakeUp(from url: String?, competion: @escaping (_ makeUp: [MakeUpElement]) -> ()) {
        AF.request(Link.cosmetics.rawValue)
            .validate()
            .downloadProgress { (progress) in
                self.onProgress?(progress.fractionCompleted)
                self.completed?(progress.localizedDescription)
            }
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

class ImageManager {
    static var shared = ImageManager()
    
    private init() {}
    
    func fetchImage(from url: String?) -> Data? {
        guard let stringUrl = url else { return nil }
        guard let imageUrl = URL(string: stringUrl) else { return nil }
        return try? Data(contentsOf: imageUrl)
    }
}



