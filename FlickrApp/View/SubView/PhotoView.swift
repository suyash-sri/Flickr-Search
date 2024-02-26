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
        }
      
        .navigationTitle("Photo Details")
    }
}

