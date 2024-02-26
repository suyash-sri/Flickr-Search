//  FlickrApp
//
//  Created by Suyash Srivastav on 20/02/24.

import SwiftUI

struct FavoriteTab: View {
    @ObservedObject var viewModel: PhotoViewModel

    var body: some View {
        VStack {
            Text("Favorite")
                .font(.title)
                .padding()

            List(viewModel.favorites, id: \.id) { favoritePhoto in
                NavigationLink(destination: PhotoView(viewModel: viewModel, photo: favoritePhoto)) {
                    Text(favoritePhoto.title)
                        .font(.headline)
                }
            }
        }
    }
}
