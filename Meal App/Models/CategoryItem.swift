//
//  CategoryItem.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-04.
//

import Foundation

struct CategoryItem : Hashable, Identifiable {
    let id: String
    let categoryName: String
    let thumbnail: String
    let description: String
    
    init(from: CategoryDTO) {
        self.id = from.categoryId
        self.categoryName = from.categoryName
        self.thumbnail = from.thumbnail
        self.description = from.description
    }
}

let dummyCategoryItem = CategoryItem(from: .init(
    categoryId: "1",
    categoryName: "Beef",
    thumbnail: "https://www.themealdb.com/images/category/beef.png",
    description: "Beef is the culinary name for meat from cattle, particularly skeletal muscle. Humans have been eating beef since prehistoric times.[1] Beef is a source of high-quality protein and essential nutrients.[2]")
)
