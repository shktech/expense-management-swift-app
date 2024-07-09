import SwiftUI

struct AirlinePickerView<CommonDataManager: CommonDataManagerProtocol>: View {
    @Binding var selectedAirline: String
    @Binding var isEditable: Bool
    @EnvironmentObject var commonDataManager: CommonDataManager
    @State private var showAirlinePicker = false
    @State private var searchText: String = ""

    var filteredAirlines: [Airline] {
        if searchText.isEmpty {
            return commonDataManager.airlines
        } else {
            return commonDataManager.airlines.filter { $0.value.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Airline")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isEditable ? .ourLightGray : .black.opacity(0.15))
                HStack {
                    Text(selectedAirline.isEmpty ? "---" : selectedAirline)
                        .foregroundStyle(selectedAirline.isEmpty ? .gray : .oceanBlue)
                        .font(Font.custom("Nunito", size: 16))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.oceanBlue)
                        .fontWeight(.semibold)
                        .opacity(isEditable ? 1:0)
                }
                .padding(.horizontal)
            }
            .frame(height: 45)
            .onTapGesture {
                if isEditable {
                    showAirlinePicker.toggle()
                }
            }
        }
        .sheet(isPresented: $showAirlinePicker) {
            VStack(spacing: 15) {
                Text("Select your Airfare")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                SearchBar(text: $searchText, placeholder: "Search airlines")
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(filteredAirlines, id: \.value) { airline in
                            Button {
                                selectedAirline = airline.value
                                showAirlinePicker = false
                            } label: {
                                ZStack {
                                    if selectedAirline == airline.value {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(airline.value)
                                                .font(Font.custom("Nunito", size: 13))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.gray.opacity(0.2))
                                        HStack {
                                            Text(airline.value)
                                                .font(Font.custom("Nunito", size: 16))
                                                .foregroundStyle(.black)
                                            Spacer()
                                        }.padding()
                                    }
                                }
                            }
                            .frame(height: 44)
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
            }
            .padding()
            .presentationDetents([.fraction(0.5)])
        }
    }
}

struct AirlinePickerView_Previews: PreviewProvider {
    static var previews: some View {
        AirlinePickerView<MockCommonDataManager>(selectedAirline: .constant(""), isEditable: .constant(true))
            .environmentObject(MockCommonDataManager())
    }
}
