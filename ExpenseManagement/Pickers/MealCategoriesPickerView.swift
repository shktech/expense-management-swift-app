//
//  MealCategoriesPickerView.swift
//  ExpenseManagement
//
//  Created by infra on 23/06/24.
//

import SwiftUI

struct MealCategoriesPickerView: View {

    @StateObject private var commonDataManager = CommonDataManager.instance

    @State var searchText: String = ""

    @Binding var selectedMeal: String

    var filteredMeal: [MealCategory] {
            if searchText.isEmpty {
                return commonDataManager.mealCategories
            } else {
                return commonDataManager.mealCategories.filter { $0.value.lowercased().contains(searchText.lowercased()) }
            }
        }

    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                Text("Select your Rental Agency")
                    .font(Font.custom("Poppins", size: 24).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(Array(filteredMeal.enumerated()), id:\.element.value) { index, meal in
                            Button {
                                selectedMeal = meal.value
                            } label: {
                                ZStack {
                                    if selectedMeal == meal.value {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(meal.value)
                                                .font(Font.custom("Poppins", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(index % 2 == 0 ? .ourLightBlue : .ourLightGray)
                                        HStack {
                                            Text(meal.value)
                                                .font(Font.custom("Poppins", size: 16))
                                                .foregroundStyle(.black)
                                            Spacer()
                                        }.padding()
                                    }
                                }
                            }
                            .frame(height: 44)
                        }
                    }.padding(.top)
                }
            }
        }.padding()
    }
}

//#Preview {
//    MealCategoriesPickerView()
//}
