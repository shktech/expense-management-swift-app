import SwiftUI

struct CityPickerView<CommonDataManager: CommonDataManagerProtocol>: View {
    @Binding var selectedCity: String
    @Binding var isEditable: Bool
    @EnvironmentObject var commonDataManager: CommonDataManager
    @State private var showCityPicker = false
    @State private var searchText: String = ""

    var filteredCities: [City] {
        if searchText.isEmpty {
            return commonDataManager.cities
        } else {
            return commonDataManager.cities.filter { $0.value.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("City")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isEditable ? .ourLightGray : .black.opacity(0.15))
                HStack {
                    Text(selectedCity.isEmpty ? "---" : selectedCity)
                        .foregroundStyle(selectedCity.isEmpty ? .gray : .oceanBlue)
                        .font(Font.custom("Nunito", size: 16))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.oceanBlue)
                        .fontWeight(.semibold)
                        .opacity(isEditable ? 1:0)
                }
                .padding(.horizontal)
            }
            .frame(height: 40)
            .onTapGesture {
                if isEditable {
                    showCityPicker.toggle()
                }
            }
        }
        .sheet(isPresented: $showCityPicker) {
            VStack(spacing: 15) {
                Text("Select City")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                SearchBar(text: $searchText, placeholder: "Search cities")
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(filteredCities, id: \.value) { city in
                            Button {
                                selectedCity = city.value
                                showCityPicker = false
                            } label: {
                                ZStack {
                                    if selectedCity == city.value {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(city.value)
                                                .font(Font.custom("Nunito", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.gray.opacity(0.2))
                                        HStack {
                                            Text(city.value)
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

struct CityPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CityPickerView<MockCommonDataManager>(selectedCity: .constant(""), isEditable: .constant(true))
            .environmentObject(MockCommonDataManager())
    }
}
