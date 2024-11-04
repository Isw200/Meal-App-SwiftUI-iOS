//
//  CategoryViewModel.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-04.
//

import Foundation

class CategoryViewModel: ObservableObject {
    @Published var categories: [CategoryItem] = []
    @Published var filteredCategories: [CategoryItem] = []
    @Published var isCategoryLoading: Bool = true
    @Published var searchText: String = ""
    
    func fetchCategories() async {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")
        
        guard let unwrappedUrl = url else {
            print("Error: Invalid URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: unwrappedUrl)
            
            guard let response = response as? HTTPURLResponse else {
                print("Error: Invalid response")
                return
            }
            
            switch response.statusCode {
                case 200:
                    let categoriesDto = try JSONDecoder().decode(CategoriesDTO.self, from: data)
                    let categories = categoriesDto.categories.map { CategoryItem(from: $0) }
                            
                    DispatchQueue.main.async {
                        self.categories = categories
                        self.filteredCategories = categories
                        self.isCategoryLoading = false
                    }
                
                case 400...599:
                    print("Error: \(response.statusCode)")
                
                default:
                    print("Error: \(response.statusCode)")
            }
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    func trimDescription(_ description: String, maxLength: Int) -> String {
       if description.count > maxLength {
           let endIndex = description.index(description.startIndex, offsetBy: maxLength)
           let trimmedDescription = String(description[..<endIndex])
           return trimmedDescription + "..."
       } else {
           return description
       }
    }
    
    func handleSearch() {
        if (searchText.count > 0) {
            let filteredItems = categories.filter( { $0.categoryName.lowercased().contains(searchText.lowercased()) } )
            self.filteredCategories = filteredItems
        } else {
            self.filteredCategories = categories
        }
    }
}
