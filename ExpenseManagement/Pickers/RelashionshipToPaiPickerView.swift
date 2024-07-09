import SwiftUI

struct RelashionshipToPaiPickerView<CommonDataManager: CommonDataManagerProtocol>: View {
    @Binding var selectedRelation: String
    @Binding var isEditable: Bool
    @EnvironmentObject var commonDataManager: CommonDataManager
    @State private var showRelationPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Relationship to PAI")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isEditable ? .ourLightGray : .black.opacity(0.15))
                HStack {
                    Text(selectedRelation.isEmpty ? "---" : selectedRelation)
                        .foregroundStyle(selectedRelation.isEmpty ? .gray : .oceanBlue)
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
                showRelationPicker.toggle()
            }
        }
        .sheet(isPresented: $showRelationPicker) {
            VStack(spacing: 15) {
                Text("Select your Relationship to PAI")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(commonDataManager.relationshipsToPAI, id: \.value) { relation in
                            Button {
                                selectedRelation = relation.value
                                showRelationPicker = false
                            } label: {
                                ZStack {
                                    if selectedRelation == relation.value {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(relation.value)
                                                .font(Font.custom("Nunito", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.gray.opacity(0.2))
                                        HStack {
                                            Text(relation.value)
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

struct RelashionshipToPaiPickerView_Previews: PreviewProvider {
    static var previews: some View {
        RelashionshipToPaiPickerView<MockCommonDataManager>(selectedRelation: .constant(""), isEditable: .constant(true))
            .environmentObject(MockCommonDataManager())
    }
}
