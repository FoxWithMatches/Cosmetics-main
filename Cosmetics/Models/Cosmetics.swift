//
//  Cosmetics.swift
//  Cosmetics
//
//  Created by Alisa Ts on 30.11.2021.
//

import UIKit

    struct MakeUpElement: Codable {

        let brand: String?
        let name: String?
        let price: String?
        let imageLink: String?
        let makeUpDescription: String?
   
        enum CodingKeys: String, CodingKey {
            case brand, name, price
            case imageLink = "image_link"
            case makeUpDescription = "description"
        }
        
        init(name: String, brand: String, price: String, imageLink: String, makeUpDescription: String) {
            self.name = name
            self.brand = brand
            self.price = price
            self.imageLink = imageLink
            self.makeUpDescription = makeUpDescription
        }
        
        init(cosmeticsData: [String: Any]) {
            name = cosmeticsData["name"] as? String
            brand = cosmeticsData["brand"] as? String
            price = cosmeticsData["price"] as? String
            imageLink = cosmeticsData["image_link"] as? String
            makeUpDescription = cosmeticsData["description"] as? String
        }
        
        static func getCosmetics(from value: Any) -> [MakeUpElement] {
            guard let cosmeticsData = value as? [[String: Any]] else { return [] }
            return cosmeticsData.compactMap { MakeUpElement(cosmeticsData: $0)}
        }
    }

enum Link: String {
    case cosmetics = "https://makeup-api.herokuapp.com/api/v1/products.json"
}

//    typealias MakeUp = [MakeUpElement]
