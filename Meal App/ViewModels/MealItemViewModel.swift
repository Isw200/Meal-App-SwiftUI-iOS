//
//  MealItemViewModel.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-04.
//

import Foundation

class MealItemViewModel: ObservableObject {
    @Published var meal: MealItem?
    @Published var isLoading: Bool = true
    
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
}
