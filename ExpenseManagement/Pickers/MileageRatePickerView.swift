//
//  MileageRatePickerView.swift
//  ExpenseManagement
//
//  Created by infra on 23/06/24.
//

import SwiftUI

struct MileageRatePickerView: View {
    @StateObject private var commonDataManager = CommonDataManager.instance
    
    @State var searchText: String = ""
    
    @Binding var selectedMileage: String
    
    var filteredMileage: [MileageRate] {
            if searchText.isEmpty {
                return commonDataManager.mileageRates
            } else {
                return commonDataManager.mileageRates.filter { $0.title.lowercased().contains(searchText.lowercased()) }
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
                        ForEach(Array(filteredMileage.enumerated()), id:\.element.title) { index, relation in
                            Button {
                                selectedMileage = relation.title
                            } label: {
                                ZStack {
                                    if selectedMileage == relation.title {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(relation.title)
                                                .font(Font.custom("Poppins", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(index % 2 == 0 ? .ourLightBlue : .ourLightGray)
                                        HStack {
                                            Text(relation.title)
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
//    MileageRatePickerView()
//}
