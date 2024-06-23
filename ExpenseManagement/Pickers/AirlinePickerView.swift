//
//  FormOptionsView.swift
//  ExpenseManagement
//
//  Created by infra on 23/06/24.
//

import SwiftUI

struct AirlinePickerView: View {
    @StateObject private var commonDataManager = CommonDataManager.instance
    
    @State var searchText: String = ""
    
    @Binding var selectedAirline: String
    
    var filteredAirlines: [Airline] {
            if searchText.isEmpty {
                return commonDataManager.airlines
            } else {
                return commonDataManager.airlines.filter { $0.value.lowercased().contains(searchText.lowercased()) }
            }
        }
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                Text("Select your Airfare")
                    .font(Font.custom("Poppins", size: 24).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(Array(filteredAirlines.enumerated()), id:\.element.value) { index, airline in
                            Button {
                                selectedAirline = airline.value
                            } label: {
                                ZStack {
                                    if selectedAirline == airline.value {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(airline.value)
                                                .font(Font.custom("Poppins", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(index % 2 == 0 ? .ourLightBlue : .ourLightGray)
                                        HStack {
                                            Text(airline.value)
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

#Preview {
    AirlinePickerView(selectedAirline: .constant(""))
}
