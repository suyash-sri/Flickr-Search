//
//  PhotoView.swift
//  FlickrApp
//
//  Created by Suyash Srivastav on 07/02/24.

import SwiftUI

struct PhotoView: View {
    @ObservedObject var viewModel: PhotoViewModel
    let photo: Photo

    var body: some View {
        VStack {
            Text(photo.title)
                .font(.title)
                .padding()

            if let url = viewModel.buildPhotoURL(for: photo) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
            }
            Spacer()
            Button(action: {
                if viewModel.isFavorite(photo: photo) {
                    viewModel.removeFromFavorite(photo: photo)
                } else {
                    viewModel.addToFavorite(photo: photo)
                }
            }) {
                if viewModel.isFavorite(photo: photo) {
                    Label("Remove from Favorites", systemImage: "heart.fill")
                        .font(.headline)
                        .foregroundColor(.red) // You can customize the color
                } else {
                    Label("Add to Favorite", systemImage: "heart.fill")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle("Photo Details")
    }
}
