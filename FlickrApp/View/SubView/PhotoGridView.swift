//
//  PhotoGridView.swift
//  FlickrApp
//
//  Created by Suyash Srivastav on 12/02/24.
//

import SwiftUI

struct PhotoGridView: View {
    @Binding var searchText: String
    @ObservedObject var viewModel: PhotoViewModel
    @State var isLoading: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar fixed at the top
            SearchBar(text: $searchText, onSearch: {
                isLoading = true // Set loading state to true when searching
                viewModel.searchPhotos(query: searchText)
            })
            .padding()
            
            // Use ScrollView with LazyVGrid for the grid view
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(viewModel.photos, id: \.id) { photo in
                        NavigationLink(destination: PhotoView(viewModel: viewModel, photo: photo)) {
                            // Display the photo in the grid using an Image view.
                            if photo != viewModel.photos.last {
                                // Check if the current photo is not the last one, and load more if needed
                                AsyncImage(url: viewModel.buildPhotoURL(for: photo)) { phase in
                                    // Use Group to handle the various states of the AsyncImage
                                    Group {
                                        switch phase {
                                        case .empty:
                                            // Placeholder while loading
                                            if isLoading {
                                                ProgressView()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            }
                                        case .success(let image):
                                            // Image loaded successfully
                                            ZStack(alignment: .bottom) {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                
                                                // Title displayed at the bottom
                                                Text(photo.title)
                                                    .font(.caption)
                                                    .multilineTextAlignment(.center)
                                                    .padding(8)
                                                    .lineLimit(1)
                                                    .background(Color.black.opacity(0.7))
                                                    .foregroundColor(.white)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                        case .failure:
                                            // Placeholder for failure
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        @unknown default:
                                            // Placeholder for unknown state
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }
                                    }
                                }
                                .frame(height: 100) // Adjust the height according to your preference
                                .cornerRadius(10)
                                .padding(4) // Adjust the padding between grid items
                            } else {
                                // Placeholder for the last item
                                ProgressView()
                                    .onAppear {
                                        viewModel.searchPhotos(query: searchText)
                                    }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Flickr App")
    }
}
struct PhotoGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridView(searchText: .constant(""), viewModel: PhotoViewModel(), isLoading: false)
    }
}
