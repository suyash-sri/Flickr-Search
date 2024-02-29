//  FlickrApp
//
//  Created by Suyash Srivastav on 20/02/24.

import Foundation
import SwiftUI

struct SearchTab: View {
    @Binding var searchText: String
    @ObservedObject var viewModel: PhotoViewModel
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Flickr Search")
                .font(.system(size: 24))
            SearchBar(text: $searchText, onSearch: {
                isLoading = true
                viewModel.searchPhotos(query: searchText)
            })
            .padding()
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(viewModel.photos, id: \.id) { photo in
                        NavigationLink(destination: PhotoView(viewModel: viewModel, photo: photo)) {
                                PhotoItemView(photo: photo, viewModel: viewModel, isLoading: isLoading, searchText: searchText)
                        }
                    }
                }
            }
        }
        .navigationTitle("Flickr App")
        .zIndex(1) 
    }
}

struct PhotoItemView: View {
    let photo: Photo
    let viewModel: PhotoViewModel
    let isLoading: Bool
    let searchText: String

    var body: some View {
        if photo != viewModel.photos.last {
            AsyncImageView(photo: photo, viewModel: viewModel, isLoading: isLoading, searchText: searchText)
                .frame(height: 100)
                .cornerRadius(10)
                .padding(4)
        } else {
            ProgressView()
                .onAppear {
                    viewModel.searchPhotos(query: searchText)
                }
        }
    }
}

struct AsyncImageView: View {
    let photo: Photo
    let viewModel: PhotoViewModel
    let isLoading: Bool
    let searchText: String

    var body: some View {
        AsyncImage(url: viewModel.buildPhotoURL(for: photo)) { phase in
            Group {
                switch phase {
                case .empty:
                    if isLoading {
                        ProgressView()
                    } else {
                        PlaceholderImageView()
                    }
                case .success(let image):
                    PhotoWithOverlayView(image: image, title: photo.title)
                case .failure:
                    PlaceholderImageView()
                @unknown default:
                    PlaceholderImageView()
                }
            }
        }
    }
}

struct PlaceholderImageView: View {
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct PhotoWithOverlayView: View {
    let image: Image
    let title: String

    var body: some View {
        ZStack(alignment: .bottom) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)

            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(8)
                .lineLimit(1)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
