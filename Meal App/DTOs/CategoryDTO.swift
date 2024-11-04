//
//  CategoriesDTO.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-04.
//

import Foundation

struct CategoriesDTO: Codable {
    let categories: [CategoryDTO]
}

struct CategoryDTO: Codable {
    let categoryId: String
    let categoryName: String
    let thumbnail: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "idCategory"
        case categoryName = "strCategory"
        case thumbnail = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}
