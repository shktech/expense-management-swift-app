import SwiftUI

struct MileageRatePickerView<CommonDataManager: CommonDataManagerProtocol>: View {
    @Binding var selectedMileage: String
    @Binding var isEditable: Bool
    @EnvironmentObject var commonDataManager: CommonDataManager
    @State private var showMileagePicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Mileage Rate")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isEditable ? .ourLightGray : .black.opacity(0.15))
                HStack {
                    Text(selectedMileage.isEmpty ? "---" : selectedMileage)
                        .foregroundStyle(selectedMileage.isEmpty ? .gray : .oceanBlue)
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
                showMileagePicker.toggle()
            }
        }
        .sheet(isPresented: $showMileagePicker) {
            VStack(spacing: 15) {
                Text("Select your Mileage Rate")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(commonDataManager.mileageRates, id: \.title) { relation in
                            Button {
                                selectedMileage = relation.title
                                showMileagePicker = false
                            } label: {
                                ZStack {
                                    if selectedMileage == relation.title {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(relation.title)
                                                .font(Font.custom("Nunito", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.gray.opacity(0.2))
                                        HStack {
                                            Text(relation.title)
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

struct MileageRatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        MileageRatePickerView<MockCommonDataManager>(selectedMileage: .constant(""), isEditable: .constant(true))
            .environmentObject(MockCommonDataManager())
    }
}
