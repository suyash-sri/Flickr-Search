//  FlickrApp
//
//  Created by Suyash Srivastav on 07/02/24.

import SwiftUI

class PhotoViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var page = 1
    @Published var isLoading = false
    
    
    func searchPhotos(query: String) {
        guard !isLoading else {return}
        
        isLoading = true
        
        FlickrAPI.searchPhotos(query: query,page: page) { result in
            switch result {
            case .success(let flickrResponse):
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: flickrResponse.photos.photo)
                    self.page += 1
                    self.isLoading = false
                }
            case .failure(let error):
                print("Error searching photos: \(error)")
                self.isLoading = false
            }
        }
    }
    func buildPhotoURL(for photo: Photo) -> URL? {
        let baseURL = "https://live.staticflickr.com/"
        let path = "\(photo.server)/\(photo.id)_\(photo.secret)_w.jpg"
 
        
        return URL(string: baseURL + path)
    }
}

