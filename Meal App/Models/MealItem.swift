//
//  MealItem.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-04.
//

import Foundation

struct Ingredient: Hashable {
    let name: String
    let amount: String
}

class MealItem {
    let id: String
    let name: String
    let drinkAlt: String
    let category: String
    let area: String
    let instructions: String
    let thumbnail: String
    let tags: String
    let youtube: String
    var ingredients: [Ingredient]
    let source: String
    
    init(meal: MealItemDTO) {
        self.id = meal.idMeal
        self.name = meal.strMeal
        self.drinkAlt = meal.strDrinkAlternate ?? ""
        self.category = meal.strCategory
        self.area = meal.strArea
        self.instructions = meal.strInstructions
        self.thumbnail = meal.strMealThumb
        self.tags = meal.strTags ?? ""
        self.youtube = meal.strYoutube ?? "www.youtube.com"
        self.ingredients = []
        self.source = meal.strSource ?? ""
        
        mapToIngredients(meal: meal)
    }
    
    func mapToIngredients(meal: MealItemDTO) {
        let mirror = Mirror(reflecting: meal)
        var ingredients: [Ingredient] = []
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let ingredientAmountKey = "strMeasure\(i)"
            
            let ingredientName = mirror.children.first(where: { $0.label == ingredientKey })?.value as? String
            let ingredientAmount = mirror.children.first(where: { $0.label == ingredientAmountKey })?.value as? String
            
            guard let ingredientName, let ingredientAmount else { continue }
            
            ingredients.append(Ingredient(name: ingredientName, amount: ingredientAmount))
        }
        
        ingredients.removeAll(where: { $0.name.isEmpty })
        self.ingredients = ingredients
    }
}
