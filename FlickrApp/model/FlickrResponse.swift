//  FlickrApp
//
//  Created by Suyash Srivastav on 07/02/24.

struct FlickrResponse: Codable {
    let photos: Photos
    
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
}

struct Photos: Codable {
    let photo: [Photo]
}
