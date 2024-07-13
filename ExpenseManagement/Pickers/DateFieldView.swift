import SwiftUI

struct DateFieldView: View {
    let title: String
    @Binding var date: Date
    @Binding var isEditable: Bool
    @State var showCalendar = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.ourLightGray2)
                    .frame(height: 45)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.oceanBlue, lineWidth: 1.5)
                    .frame(height: 45)
                HStack {
                    Text("\(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(Font.custom("Nunito", size: 16))
                        .foregroundStyle(.oceanBlue)
                    Spacer()
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundStyle(.oceanBlue)
                        .onTapGesture {
                            showCalendar = true
                        }
                        .overlay {
                            if (showCalendar) {
                                DatePicker(
                                    "",
                                    selection: $date,
                                    displayedComponents: [.date]
                                )
                                .onChange(of: date) { _, _ in
                                    showCalendar = false
                                }
                                .blendMode(.destinationOver)
                            }
                        }
                }.padding(.horizontal)
                if !isEditable {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.black)
                        .opacity(0.15)
                }
            }
            .disabled(!isEditable)
        }
    }
}

struct DateFieldView_Previews: PreviewProvider {
    @State static var previewDate = Date()
    @State static var isEditable = true

    static var previews: some View {
        DateFieldView(title: "Date", date: $previewDate, isEditable: $isEditable)
    }
}
