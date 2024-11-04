//
//  MealListView.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-04.
//

import SwiftUI

struct MealListView: View {
    @State var category: CategoryItem
    @StateObject var viewModel: MealListViewModel = MealListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if (viewModel.isMEalsLoading) {
                    VStack {
                        ProgressView()
                        Text("Loading...")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.gray)
                    }
                } else {
                    if (viewModel.filteredMeals.isEmpty) {
                        VStack {
                            Image(systemName: "carrot")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height:  50)
                                .symbolEffect(.bounce , options: .speed(0.0001))
                                .foregroundStyle(.gray)
                            
                            Text("Meal Not Found")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.gray)
                        }
                    } else {
                        List (viewModel.filteredMeals) { meal in
                            HStack {
                                AsyncImage(url: URL(string: meal.thumbnail)) {image in
                                    image.resizable()
                                } placeholder: {
                                    HStack{
                                        ProgressView()
                                    }
                                    .frame(width: 140, height: 140)
                                }
                                .scaledToFit()
                                .frame(width: 140, height: 140)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack (alignment: .leading) {
                                    Text(meal.name)
                                        .font(.system(size: 16, weight: .regular))
                                    
                                    NavigationLink(destination: MealDetailView(meal: meal)) {
                                        Text("View Details")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 10)
                            }
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("\(category.categoryName) Meals")
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) {
                viewModel.handleSearchMeal()
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchMeals(category: category.categoryName)
            }
        }
    }
}

#Preview {
    MealListView(category: dummyCategoryItem)
}
