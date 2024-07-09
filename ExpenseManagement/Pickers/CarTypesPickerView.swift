import SwiftUI

struct CarTypeInputField<CommonDataManager: CommonDataManagerProtocol>: View {
    @Binding var selectedCar: String;
    @State private var showCarTypesPicker = false
    @Binding var isEditable: Bool
    @EnvironmentObject var commonDataManager: CommonDataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Car Type")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isEditable ? .ourLightGray : .black.opacity(0.15))
                HStack {
                    Text(selectedCar.isEmpty ? "---" : selectedCar)
                        .foregroundStyle(selectedCar.isEmpty ? .gray : .oceanBlue)
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
        }
        .onTapGesture {
            if isEditable {
                showCarTypesPicker.toggle()
            }
        }
        .sheet(isPresented: $showCarTypesPicker) {
            CarTypesPickerView<CommonDataManager>(selectedCar: $selectedCar)
                .presentationDetents([.fraction(0.5)])
        }
    }
}

struct CarTypesPickerView<CommonDataManager: CommonDataManagerProtocol>: View {
    @Binding var selectedCar: String
    @EnvironmentObject var commonDataManager: CommonDataManager
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                Text("Select your car type")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(Array(commonDataManager.carTypes.enumerated()), id:\.element.value) { index, car in
                            Button {
                                selectedCar = car.value
                            } label: {
                                ZStack {
                                    if selectedCar == car.value {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(car.value)
                                                .font(Font.custom("Nunito", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(index % 2 == 0 ? .ourLightBlue : .ourLightGray)
                                        HStack {
                                            Text(car.value)
                                                .font(Font.custom("Nunito", size: 16))
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

struct CarTypeInputField_Previews: PreviewProvider {
    static var previews: some View {
        CarTypeInputField<MockCommonDataManager>(selectedCar: .constant(""), isEditable: .constant(true))
            .environmentObject(MockCommonDataManager())
    }
}
