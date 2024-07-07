import SwiftUI

struct DateFilterPicker: View {
    @Binding var initialDate: Date
    @Binding var finalDate: Date
    @Binding var isEditable: Bool
    @State private var isShowingSheet: Bool = false
    @State private var selectedOption: DateOption = .thisYear

    enum DateOption: String, CaseIterable, Identifiable {
        case lastThreeMonths = "Last 3 months"
        case lastSixMonths = "Last 6 months"
        case thisYear = "This year"
        case lastYear = "Last year"
        case custom = "Custom"

        var id: String { self.rawValue }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(isEditable ? .ourLightGray : .black.opacity(0.15))
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundStyle(.oceanBlue)
                    Text("From \(formattedDate(initialDate)) to \(formattedFinalDate())")
                        .foregroundStyle(.oceanBlue)
                        .font(Font.custom("Nunito", size: 16))
                }
                .padding(.horizontal)
            }
            .frame(height: 35)
            .fixedSize(horizontal: true, vertical: true)
            .onTapGesture {
                if isEditable {
                    isShowingSheet.toggle()
                }
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            ScrollViewReader { proxy in
                VStack(spacing: 15) {
                    Text("Select Date Range")
                        .font(Font.custom("Nunito", size: 18).weight(.semibold))
                        .foregroundStyle(.oceanBlue)
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(DateOption.allCases) { option in
                                Button {
                                    withAnimation {
                                        selectedOption = option
                                        handleDateSelection(option: option)
                                        if option == .custom {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                proxy.scrollTo(DateOption.custom.id, anchor: .bottom)
                                            }
                                        } else {
                                            isShowingSheet.toggle()
                                        }
                                    }
                                } label: {
                                    ZStack {
                                        if selectedOption == option {
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(.oceanBlue)
                                            HStack {
                                                Text(option.rawValue)
                                                    .font(Font.custom("Nunito", size: 16))
                                                    .foregroundStyle(.white)
                                                Spacer()
                                                Image(systemName: "checkmark")
                                            }.padding()
                                        } else {
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(.gray.opacity(0.2))
                                            HStack {
                                                Text(option.rawValue)
                                                    .font(Font.custom("Nunito", size: 16))
                                                    .foregroundStyle(.black)
                                                Spacer()
                                            }.padding()
                                        }
                                    }
                                }
                                .frame(height: 44)
                                .id(option.id) // Add id for scrolling
                            }
                            if selectedOption == .custom {
                                VStack(spacing: 0) {
                                    DateFieldView(title: "From", date: $initialDate, isEditable: .constant(true))
                                    DateFieldView(title: "To", date: $finalDate, isEditable: .constant(true))
                                }
                                .padding(.horizontal)
                                .id(DateOption.custom.id)
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .padding()
                .presentationDetents([.fraction(0.5)])
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        return date.formatted(.dateTime.month().day().year())
    }

    private func formattedFinalDate() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(finalDate) {
            return "Today"
        } else {
            return formattedDate(finalDate)
        }
    }

    private func handleDateSelection(option: DateOption) {
        let calendar = Calendar.current
        let today = Date()

        switch option {
        case .lastThreeMonths:
            initialDate = calendar.date(byAdding: .month, value: -3, to: today) ?? today
            finalDate = today
        case .lastSixMonths:
            initialDate = calendar.date(byAdding: .month, value: -6, to: today) ?? today
            finalDate = today
        case .thisYear:
            initialDate = calendar.date(from: calendar.dateComponents([.year], from: today)) ?? today
            finalDate = today
        case .lastYear:
            initialDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: today) - 1, month: 1, day: 1)) ?? today
            finalDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: today) - 1, month: 12, day: 31)) ?? today
        case .custom:
            break
        }
    }
}

struct DateFilterPicker_Previews: PreviewProvider {
    static var previews: some View {
        DateFilterPicker(initialDate: .constant(Date()), finalDate: .constant(Date()), isEditable: .constant(true))
    }
}
