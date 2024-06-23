//
//  carRentalPickerView.swift
//  ExpenseManagement
//
//  Created by infra on 23/06/24.
//

import SwiftUI

struct CarRentalPickerView: View {
    
    @StateObject private var commonDataManager = CommonDataManager.instance
    
    @State var searchText: String = ""
    
    @Binding var selectedRental: String
    
    var filteredRentals: [RentalAgency] {
            if searchText.isEmpty {
                return commonDataManager.rentalAgencies
            } else {
                return commonDataManager.rentalAgencies.filter { $0.value.lowercased().contains(searchText.lowercased()) }
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
                        ForEach(Array(filteredRentals.enumerated()), id:\.element.value) { index, rental in
                            Button {
                                selectedRental = rental.value
                            } label: {
                                ZStack {
                                    if selectedRental == rental.value {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(rental.value)
                                                .font(Font.custom("Poppins", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(index % 2 == 0 ? .ourLightBlue : .ourLightGray)
                                        HStack {
                                            Text(rental.value)
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
//    carRentalPickerView()
//}
