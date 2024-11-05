//
//  FavouriteView.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-05.
//

import SwiftUI

struct FavouriteView: View {
    @StateObject var favouritesVM : FavouriteViewModel = FavouriteViewModel()
    @StateObject private var notificationVM = NotificationViewModel()
    
    var body: some View {
        ZStack (alignment: .bottom) {
            NavigationStack {
                List (favouritesVM.meals)  {meal in
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
                    .swipeActions {
                        Button {
                            favouritesVM.removeFavourite(meal)
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                Text("Remove")
                                    .foregroundColor(.red)
                            }
                        }
                        .tint(.red)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Favourites")
                .onAppear {
                    favouritesVM.loadFavourites()
                    favouritesVM.notficationVM = notificationVM
                }
            }
            
            if notificationVM.isVisible {
                NotificationView(message: notificationVM.message)
                    .padding(.bottom, 40)
                    .animation(.spring(), value: notificationVM.isVisible)
            }
        }
    }
}

#Preview {
    FavouriteView()
}
