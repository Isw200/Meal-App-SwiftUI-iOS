//
//  MealListViewModel.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-04.
//

import Foundation

class MealListViewModel: ObservableObject {
    @Published var meals: [MealListItem] = []
    @Published var isMEalsLoading: Bool = true
    @Published var filteredMeals: [MealListItem] = []
    @Published var searchText: String = ""
    
    func fetchMeals(category: String) async {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)")
        
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
                let mealsDto = try JSONDecoder().decode(MealListDTO.self, from: data)
                let meals = mealsDto.meals.map({MealListItem(meal: $0)})
                
                DispatchQueue.main.async {
                    self.meals = meals
                    self.filteredMeals = meals
                    self.isMEalsLoading = false
                }
                
            case 400...599:
                print("Error fetching meals: \(response.statusCode)")
                
            default:
                print("Error fetching meals: \(response.statusCode)")
            }
        } catch {
            print("Error fetching meals: \(error)")
        }
    }
    
    func handleSearchMeal() {
        if (searchText.count > 0) {
            let filteredMeals = meals.filter({ $0.name.lowercased().contains(searchText.lowercased())})
            self.filteredMeals = filteredMeals
        } else {
            filteredMeals = meals
        }
    }
}
