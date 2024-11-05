//
//  FavouriteViewModel.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-05.
//

import Foundation

class FavouriteViewModel: ObservableObject {
    @Published var meals: [MealListItem] = []
    @Published var notficationVM: NotificationViewModel?
    
    func loadFavourites() {
        if let savedFavorites = UserDefaults.standard.data(forKey: "favorites"),
           let decodedFavorites = try? JSONDecoder().decode([MealListItem].self, from: savedFavorites) {
            self.meals = decodedFavorites
        }
    }
    
    func removeFavourite(_ meal: MealListItem) {
        var currentFavorites = load()
        
        if let index = currentFavorites.firstIndex(where: { $0.id == meal.id }) {
            currentFavorites.remove(at: index)
            notficationVM?.showNotification(with: "Removed from favorites")
        }
        saveFavorites(currentFavorites)
        loadFavourites()
    }
    
    func saveFavorites(_ favorites: [MealListItem]) {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }
    
    func load() -> [MealListItem] {
        if let savedFavorites = UserDefaults.standard.data(forKey: "favorites"),
           let decodedFavorites = try? JSONDecoder().decode([MealListItem].self, from: savedFavorites) {
            return decodedFavorites
        }
        return []
    }
}
