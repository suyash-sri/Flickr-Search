//  FlickrApp
//
//  Created by Suyash Srivastav on 20/02/24.
import SwiftUI

struct SettingsTab: View {
  @Environment(\.colorScheme) private var colorScheme
  @StateObject private var themeManager = ThemeManager()
  @State private var selectedLanguage = "English"
  @State private var isLanguagePickerExpanded = false
    @ObservedObject var viewModel: PhotoViewModel

  var body: some View {
    NavigationView {
      List {
        Section {
          Toggle("Dark Mode", isOn: $themeManager.isDarkModeEnabled)
            .onChange(of: themeManager.isDarkModeEnabled) { isDarkModeEnabled in
                viewModel.setDarkMode(isDarkModeEnabled)
            }

          DisclosureGroup("Languages", isExpanded: $isLanguagePickerExpanded) {
            Picker("Select Language", selection: $selectedLanguage) {
              Text("English").tag("en")
              Text("Hindi").tag("hi")
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedLanguage) { newLanguage in
              updateAppInterface(for: newLanguage)
            }
          }
        }
      }
      .navigationTitle("Settings")
      .environmentObject(themeManager)
    }
  }

  private func updateAppInterface(for language: String) {
    let localizedBundle = Bundle(path: Bundle.main.path(forResource: language, ofType: ".lproj")!)
      UserDefaults.standard.set([localizedBundle?.bundlePath], forKey: "AppleLanguages")
    UserDefaults.standard.set(language, forKey: "selectedLanguage")
  }
}
