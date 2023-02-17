//
//  NatureDataModel.swift
//  IlaBankDemo
//
//  Created by webwerks on 17/02/23.
//

import Foundation

struct NatureDataModel: Codable {
    let headerImage: String?
    var details: [ImageDetails]?
    
    enum CodingKeys: String, CodingKey {
        case headerImage = "headerImage"
        case details = "details"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        headerImage = try container.decodeIfPresent(String.self, forKey: .headerImage)
        details = try container.decodeIfPresent([ImageDetails].self, forKey: .details)
    }
}

struct ImageDetails: Codable {
    let img: String?
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case img = "img"
        case text = "text"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        img = try container.decodeIfPresent(String.self, forKey: .img)
        text = try container.decodeIfPresent(String.self, forKey: .text)
    }
}
