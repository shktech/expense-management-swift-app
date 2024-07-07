import SwiftUI

struct HotelBaseRatePickerView: View {
    
    @StateObject private var commonDataManager = CommonDataManager.instance
    
    @State var searchText: String = ""
    
    @Binding var selectedBaseRate: String
    
//    var filteredBaseRates: [HotelDailyBaseRate] {
//            if searchText.isEmpty {
//                return commonDataManager.hotelDailyBaseRates
//            } else {
//                return commonDataManager.hotelDailyBaseRates.filter { $0.value.lowercased().contains(searchText.lowercased()) }
//            }
//        }
    
    var body: some View {
        ZStack {
//            VStack(spacing: 15) {
//                Text("Select your Rental Agency")
//                    .font(Font.custom("Poppins", size: 24).weight(.semibold))
//                    .foregroundStyle(.oceanBlue)
//                ScrollView {
//                    VStack(spacing: 15) {
//                        ForEach(Array(filteredRelation.enumerated()), id:\.element.value) { index, relation in
//                            Button {
//                                selectedBaseRate = relation.value
//                            } label: {
//                                ZStack {
//                                    if selectedBaseRate == relation.value {
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .foregroundStyle(.oceanBlue)
//                                        HStack {
//                                            Text(relation.value)
//                                                .font(Font.custom("Poppins", size: 16))
//                                                .foregroundStyle(.white)
//                                            Spacer()
//                                            Image(systemName: "checkmark")
//                                        }.padding()
//                                    } else {
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .foregroundStyle(index % 2 == 0 ? .ourLightBlue : .ourLightGray)
//                                        HStack {
//                                            Text(relation.value)
//                                                .font(Font.custom("Poppins", size: 16))
//                                                .foregroundStyle(.black)
//                                            Spacer()
//                                        }.padding()
//                                    }
//                                }
//                            }
//                            .frame(height: 44)
//                        }
//                    }.padding(.top)
//                }
//            }
        }.padding()
    }
}

//#Preview {
//    HotelBaseRatePickerView()
//}
