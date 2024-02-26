//
//  SearchTab.swift
//  FlickrApp
//
//  Created by Suyash Srivastav on 20/02/24.
//

import Foundation
import SwiftUI

struct SearchTab: View {
    @Binding var searchText: String
    @ObservedObject var viewModel: PhotoViewModel
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $searchText, onSearch: {
                isLoading = true
                viewModel.searchPhotos(query: searchText)
            })
            .padding()
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(viewModel.photos, id: \.id) { photo in
                        NavigationLink(destination: PhotoView(viewModel: viewModel, photo: photo)) {
                            if photo != viewModel.photos.last {
                                AsyncImage(url: viewModel.buildPhotoURL(for: photo)) { phase in
                                    Group {
                                        switch phase {
                                        case .empty:
                                         
                                            if isLoading {
                                                ProgressView()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            }
                                        case .success(let image):
                                       
                                            ZStack(alignment: .bottom) {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)

                                             
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
                                         
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        @unknown default:
                                          
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }
                                    }
                                
                                }
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
                }
            }
        }
        .navigationTitle("Flickr App")
        .zIndex(1) 
    }
}
