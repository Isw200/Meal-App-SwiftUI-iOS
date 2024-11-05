//
//  MealListItem.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-04.
//

import Foundation

struct MealListItem: Identifiable, Codable {
    let id: String
    let name: String
    let thumbnail: String
    
    init(meal: MealListItemDTO) {
        self.id = meal.id
        self.name = meal.name
        self.thumbnail = meal.thumbnail
    }
}

let dummyMealListItem = MealListItem(meal: .init(id: "52772", name: "Dummy Meal", thumbnail: "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg"))
