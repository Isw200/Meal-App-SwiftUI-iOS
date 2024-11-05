//
//  MealDetailView.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-04.
//

import SwiftUI

struct MealDetailView: View {
    @StateObject var viewModel: MealItemViewModel = MealItemViewModel()
    @StateObject private var notificationVM = NotificationViewModel()
    @State var meal: MealListItem
    
    var body: some View {
        ZStack (alignment: .bottom) {
            VStack(alignment: .leading)  {
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                        Text("Loading...")
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: viewModel.meal?.thumbnail ?? "")){ image in
                                image.resizable()
                            } placeholder: {
                                HStack{
                                    ProgressView()
                                }
                                .frame(width: 600, height: 340)
                            }
                            .scaledToFill()
                            .frame(height: 340)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            VStack(alignment: .leading)  {
                                Text(viewModel.meal?.name ?? "Unknown")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)
                                
                                HStack {
                                    Text(viewModel.meal?.category ?? "Unknown")
                                        .font(.subheadline)
                                        .padding(10)
                                        .background(Color.red.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    HStack {
                                        ForEach(viewModel.meal?.tags.split(separator: ",") ?? ["Unknown"] , id: \.self) { tag in
                                            Text(tag)
                                                .font(.subheadline)
                                                .padding(10)
                                                .background(Color.blue.opacity(0.2))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        viewModel.toggogleFavourite(meal: meal)
                                        viewModel.checkIfFavorite(mealId: meal.id)
                                    } label: {
                                        if (viewModel.isFavorite) {
                                            Image(systemName: "heart.fill")
                                                .resizable()
                                                .frame(width: 34, height: 30)
                                                .foregroundStyle(.red)
                                        } else {
                                            Image(systemName: "heart")
                                                .resizable()
                                                .frame(width: 34, height: 30)
                                                .foregroundStyle(.red)
                                        }
                                    }
                                }
                                
                                HStack {
                                    Image(systemName: "globe")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.gray)
                                    Text(viewModel.meal?.area ?? "Unknown")
                                }
                                .padding(.vertical, 10)
                                
                                Text("Ingredients")
                                    .font(.headline)
                                    .padding(.bottom, 6)
                                
                                VStack (alignment: .leading) {
                                    let ingredients = viewModel.meal?.ingredients ?? []
                                    if !ingredients.isEmpty {
                                        ForEach (ingredients , id: \.self) { ingredient in
                                            HStack {
                                                Text(ingredient.name)
                                                    .font(.system(size: 15))
                                                    .foregroundStyle(.black.opacity(0.7))
                                                
                                                Spacer()
                                                
                                                Text(ingredient.amount)
                                                    .font(.system(size: 15))
                                                    .foregroundStyle(.black.opacity(0.7))
                                            }
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 10)
                                            .background(.gray.opacity(0.1))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                                .padding(.bottom, 15)
                                
                                Text("How to make?")
                                    .font(.headline)
                                    .padding(.bottom, 8)
                                Text(viewModel.meal?.instructions ?? "Unknown")
                                    .font(.system(size: 15))
                                    .lineSpacing(7)
                                    .foregroundStyle(.black.opacity(0.7))
                                
                                HStack (alignment: .center) {
                                    Spacer()
                                    Button {
                                        if let youtubeURLString = viewModel.meal?.youtube,
                                           let youtubeURL = URL(string: youtubeURLString) {
                                            UIApplication.shared.open(youtubeURL)
                                        } else if let defaultURL = URL(string: "https://www.youtube.com") {
                                            UIApplication.shared.open(defaultURL)
                                        }
                                    } label: {
                                        Text("Watch on YouTube")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(Color.red)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .padding(.vertical, 15)
                                    Spacer()
                                }
                                .padding(.bottom, 100)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchMeal(id: meal.id)
                    viewModel.checkIfFavorite(mealId: meal.id)
                    viewModel.notficationVM = notificationVM
                }
            }
            
            if notificationVM.isVisible {
                NotificationView(message: notificationVM.message)
                    .padding(.bottom, 40)
                    .animation(.spring(), value: notificationVM.isVisible)
            }
        }
        .ignoresSafeArea(.all)
        .environmentObject(notificationVM)
    }
}

#Preview {
    MealDetailView(meal: dummyMealListItem)
}
