//
//  PhotoViewModel.swift
//  FlickrApp
//
//  Created by Suyash Srivastav on 07/02/24.

import SwiftUI

class PhotoViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var favorites: [Photo] = []
    @Published var page = 1
    @Published var isLoading = false
    @Published var isDarkModeEnabled = false
    
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

    func isFavorite(photo: Photo) -> Bool {
        return favorites.contains { $0.id == photo.id }
    }

    func addToFavorite(photo: Photo) {
        if !isFavorite(photo: photo) {
            favorites.append(photo)
        }
    }

    func removeFromFavorite(photo: Photo) {
        if let index = favorites.firstIndex(where: { $0.id == photo.id }) {
            favorites.remove(at: index)
        }
    }
    func setDarkMode(_ isDarkModeEnabled: Bool) {
        self.isDarkModeEnabled = isDarkModeEnabled
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        if isDarkModeEnabled {
            window.overrideUserInterfaceStyle = .dark
        } else {
            window.overrideUserInterfaceStyle = .light
        }
    }

}

//@Published var isDarkModeEnabled: Bool = false
class ThemeManager: ObservableObject {
    @Published var isDarkModeEnabled: Bool = false
}
