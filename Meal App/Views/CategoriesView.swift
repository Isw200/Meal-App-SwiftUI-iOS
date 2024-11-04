//
//  ContentView.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-03.
//

import SwiftUI

struct CategoriesView: View {
    @StateObject var viewModel: CategoryViewModel = CategoryViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if (viewModel.isCategoryLoading) {
                    VStack {
                        ProgressView()
                        Text("Loading...")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.gray)
                    }
                } else {
                    List(viewModel.filteredCategories) { category in
                        NavigationLink(destination: MealListView(category: category)) {
                            HStack{
                                AsyncImage(url: URL(string: category.thumbnail)) { image in
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
                                    Text(category.categoryName)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(.primary)
                                        .padding(.bottom, 5)
                                    
                                    Text(viewModel.trimDescription(category.description, maxLength: 140))
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Meal Categories")
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) {
                viewModel.handleSearch()
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCategories()
            }
        }
    }
}

#Preview {
    CategoriesView()
}
