//
//  Photo.swift
//  FlickrApp
//
//  Created by Suyash Srivastav on 07/02/24.

struct Photo: Codable,Identifiable, Equatable {
    let id: String
    let title: String
    let farm: Int
    let server: String
    let secret: String
    
    // Equatable conformance
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case farm
        case server
        case secret
    }
}


