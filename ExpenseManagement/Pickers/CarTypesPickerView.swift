//
//  CarTypesPIckerView.swift
//  ExpenseManagement
//
//  Created by infra on 23/06/24.
//

import SwiftUI

struct CarTypesPickerView: View {
    
    @StateObject private var commonDataManager = CommonDataManager.instance
    
    @State var searchText: String = ""
    
    @Binding var selectedCar: String
    
    var filteredCars: [CarType] {
            if searchText.isEmpty {
                return commonDataManager.carTypes
            } else {
                return commonDataManager.carTypes.filter { $0.value.lowercased().contains(searchText.lowercased()) }
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
                        ForEach(Array(filteredCars.enumerated()), id:\.element.value) { index, car in
                            Button {
                                selectedCar = car.value
                            } label: {
                                ZStack {
                                    if selectedCar == car.value {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(car.value)
                                                .font(Font.custom("Poppins", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(index % 2 == 0 ? .ourLightBlue : .ourLightGray)
                                        HStack {
                                            Text(car.value)
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
//    CarTypesPIckerView()
//}
