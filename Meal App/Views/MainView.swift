//
//  MainView.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-05.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                CategoriesView()
            }

            Tab("Favorits", systemImage: "star") {
                FavouriteView()
            }
        }
    }
}

#Preview {
    MainView()
}
