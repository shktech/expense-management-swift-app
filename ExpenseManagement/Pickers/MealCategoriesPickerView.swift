import SwiftUI

struct MealCategoriesPickerView<CommonDataManager: CommonDataManagerProtocol>: View {
    @Binding var selectedMeal: String
    @Binding var isEditable: Bool
    @EnvironmentObject var commonDataManager: CommonDataManager
    @State private var showMealPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Meal Category")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isEditable ? .ourLightGray : .black.opacity(0.15))
                HStack {
                    Text(selectedMeal.isEmpty ? "---" : selectedMeal)
                        .foregroundStyle(selectedMeal.isEmpty ? .gray : .oceanBlue)
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
                    showMealPicker.toggle()
                }
            }
        }
        .sheet(isPresented: $showMealPicker) {
            VStack(spacing: 15) {
                Text("Select your Meal Category")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(commonDataManager.mealCategories, id: \.value) { meal in
                            Button {
                                selectedMeal = meal.value
                                showMealPicker = false
                            } label: {
                                ZStack {
                                    if selectedMeal == meal.value {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text(meal.value)
                                                .font(Font.custom("Nunito", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.gray.opacity(0.2))
                                        HStack {
                                            Text(meal.value)
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

struct MealCategoriesPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MealCategoriesPickerView<MockCommonDataManager>(selectedMeal: .constant(""), isEditable: .constant(true))
            .environmentObject(MockCommonDataManager())
    }
}
