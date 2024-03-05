import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @ObservedObject private var viewModel = PhotoViewModel()

    var body: some View {
        NavigationView {
            TabView {
                SearchTab(searchText: $searchText, viewModel: viewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(0)
                FavoriteTab(viewModel: viewModel)
                                 .tabItem {
                                     Label("Favorite", systemImage: "heart")
                                 }
                    .tag(1)
                SettingsTab(viewModel: viewModel)
                                .tabItem {
                                    Label("Settings", systemImage: "gearshape")
                                }
                    .tag(2)
              
            }
            .background(Color.white)
            .zIndex(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
