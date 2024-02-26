//  FlickrApp
//
//  Created by Suyash Srivastav on 07/02/24.

import Foundation

class FlickrAPI {
    static let apiKey = "14421833cdc3cfa8baa53dd28a2db182"
    static let baseURL = "https://api.flickr.com/services/rest/"
    
    static func searchPhotos(query: String,page: Int, completion: @escaping (Result<FlickrResponse, Error>) -> Void) {
        guard var components = URLComponents(string: baseURL) else {
            fatalError("Invalid base URL")
        }
        
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "text", value: query),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(10)),
        ]
        
        guard let url = components.url else {
            fatalError("Invalid URL components")
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            

            guard let data = data else {
                let error = NSError(domain: "FlickrAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }

            do {
                let decoder = JSONDecoder()
                let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
                completion(.success(flickrResponse))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
