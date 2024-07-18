import SwiftUI

struct PickerField: View {
    let title: String
    let options: [String]
    @Binding var selectedOption: String
    @Binding var isEditable: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                    }, label: {
                        Text(option)
                    })
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        Text(selectedOption.isEmpty ? "Select \(title)" : selectedOption)
                            .foregroundStyle(selectedOption.isEmpty ? .gray : .oceanBlue)
                            .font(Font.custom("Nunito", size: 16))
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.oceanBlue)
                            .opacity(isEditable ? 1 : 0)
                    }.padding(.horizontal)
                    if !isEditable {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .opacity(0.15)
                    }
                }
                .frame(height: 40)
            }
            .disabled(!isEditable)
        }
    }
}

struct PickerField_Previews: PreviewProvider {
    static var previews: some View {
        PickerField(title: "Expense Type", options: ["Domestic", "International"], selectedOption: .constant(""), isEditable: .constant(true))
        PickerField(title: "Preferred Payment Method", options: ["Cash", "Credit card"], selectedOption: .constant(""), isEditable: .constant(true))
    }
}
