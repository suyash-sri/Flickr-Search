//  FlickrApp
//
//  Created by Suyash Srivastav on 07/02/24.

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $text, onCommit: onSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .padding(.horizontal)
            }
        }
    }
}
