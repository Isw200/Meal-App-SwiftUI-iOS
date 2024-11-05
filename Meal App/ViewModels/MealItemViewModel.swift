//
//  MealItemViewModel.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-04.
//

import Foundation

class MealItemViewModel: ObservableObject {
    @Published var meal: MealItem?
    @Published var notficationVM: NotificationViewModel?
    @Published var isLoading: Bool = true
    @Published var isFavorite: Bool = false
    
    func fetchMeal(id: String) async {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)")
        
        guard let unwrappedUrl = url else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: unwrappedUrl)
            
            guard let response = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            switch response.statusCode {
                case 200:
                    let mealDto = try JSONDecoder().decode(MealsDTO.self, from: data)
                    let meal = mealDto.meals.map({MealItem(meal: $0)})
                
                    DispatchQueue.main.async {
                        self.meal = meal[0]
                        self.isLoading = false
                    }
                
                case 400...599:
                    print("Error fetching meal: \(response.statusCode)")
                default:
                    print("Error fetching meal: \(response.statusCode)")
            }
            
        } catch {
            print("Error fetching meal: \(error)")
        }
    }
    
    func toggogleFavourite(meal: MealListItem) {
           var currentFavorites = loadFavorites()
           
           if let index = currentFavorites.firstIndex(where: { $0.id == meal.id }) {
               currentFavorites.remove(at: index)
               notficationVM?.showNotification(with: "Removed from favorites")
           } else {
               currentFavorites.append(meal)
               notficationVM?.showNotification(with: "Added to favorites")
           }
           
           saveFavorites(currentFavorites)
    }
    
    func checkIfFavorite(mealId: String) {
        let currentFavorites = loadFavorites()
        self.isFavorite = currentFavorites.contains(where: { $0.id == mealId })
    }
    
    func saveFavorites(_ favorites: [MealListItem]) {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }

    func loadFavorites() -> [MealListItem] {
        if let savedFavorites = UserDefaults.standard.data(forKey: "favorites"),
           let decodedFavorites = try? JSONDecoder().decode([MealListItem].self, from: savedFavorites) {
            return decodedFavorites
        }
        return []
    }
}
