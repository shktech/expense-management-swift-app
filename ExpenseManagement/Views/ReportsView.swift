import SwiftUI

struct ReportsView: View {
    @State var initialDate: Date = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 1, day: 1))!
    @State var finalDate: Date = Date()
    
    @State var isShowingAddReport: Bool = false
    @State private var isLoading = false
    @State var reports: [Report] = []
    
    private let dao = DAO.instance
    
    var filteredReports: [Binding<Report>] {
        let filtered = reports.filter { report in
            if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                return date >= initialDate && date <= finalDate
            }
            return false
        }
        
        let sorted = filtered.sorted { report1, report2 in
            if let date1 = DateFormatter.iso8601Full.date(from: report1.createdAt),
               let date2 = DateFormatter.iso8601Full.date(from: report2.createdAt) {
                return date1 > date2
            }
            return false
        }
        
        return sorted.map { report in
            Binding(
                get: { report },
                set: { newValue in
                    if let index = reports.firstIndex(where: { $0.id == report.id }) {
                        reports[index] = newValue
                    }
                }
            )
        }
    }
    
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                PFULogo()
                ZStack {
                    content
                }.padding()
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        newReportButton
                            .padding()
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 3)
                    }
                }
            }
            .sheet(isPresented: $isShowingAddReport, content: {
                NewReportView(isShowing: $isShowingAddReport)
            })
            .onChange(of: isShowingAddReport) {
                loadData()
            }
        }
        .onAppear {
            loadData()
        }
        .refreshable(action: loadData)
        .loadingOverlay(isLoading: $isLoading)
    }
    
    var content: some View {
        VStack(alignment: .leading) {
            headerContent
            line
            reportsTitle
            datePickerContainer
            line
            if (reports.isEmpty) {
                ContentUnavailableView(title: "No reports", description: "Tap the “+“ button and start adding expense reports")
            } else {
                scrollViewReports
            }
            Spacer()
        }.padding()
    }
    
    var headerContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(authManager.user?.first_name ?? "") \(authManager.user?.last_name ?? "")")
                    .font(.system(size: 17).weight(.semibold))
                Text(authManager.user?.department ?? "")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundStyle(Color.black.opacity(0.5))
            }
            .padding(.bottom)
            Spacer()
        }
    }
    
    var line: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 1)
            .foregroundStyle(Color.gray.opacity(0.4))
    }
    
    var reportsTitle: some View {
        HStack {
            Text("Expense Reports")
                .font(.system(size: 32).weight(.semibold))
            Spacer()
        }
    }
    
    var newReportButton: some View {
        ZStack{
            Button(action: {
                isShowingAddReport.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.oceanBlue)
            }
            .zIndex(1)
        }.padding()
    }
    
    var datePickerContainer: some View {
        DateFilterPicker(initialDate: $initialDate, finalDate: $finalDate, isEditable: .constant(true))
    }
    
    var scrollViewReports: some View {
        ScrollView {
            ForEach(filteredReports, id: \.id) { $report in
                ReportComponent(report: $report)
            }
        }
    }
    
    private func loadData() {
        self.isLoading = true
        dao.fetchReports(accessToken: authManager.accessToken ?? "") { result in
            switch result {
            case .success(let reports):
                self.reports = reports
            case .failure(let error):
                print("Failed to fetch reports: \(error)")
            }
            self.isLoading = false
        }
    }
}

#Preview {
    ReportsView()
        .environmentObject(AuthenticationManager())
}


//import SwiftUI
//
//
//struct ReportsView: View {
//    
//    @State var initialDate: Date = Calendar.current.date(byAdding: .day, value: -180, to: Date())!
//    @State private var finalDate: Date = {
//        let calendar = Calendar.current
//        let now = Date()
//        let startOfDay = calendar.startOfDay(for: now)
//        return calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
//    }()
//    
//    @State var isShowingAddReport: Bool = false
//    @State private var isLoading = false
////    @State private var reports: [Report] = []
//    
//    let reports: [Report] = [
//        Report(
//            id: "1",
//            user: (dao.user?.first_name ?? "") + (dao.user?.last_name ?? ""),
//            reportNumber: "RPT123456",
//            reportStatus: "Pending",
//            reportSubmitDate: "2023-01-15",
//            integrationStatus: "Not Integrated",
//            integrationDate: nil,
//            reportDate: "2024-06-08",
//            expenseType: "Travel",
//            purpose: "Business trip to NYC",
//            paymentMethod: "Credit Card",
//            reportAmount: "1200.00",
//            reportCurrency: "USD",
//            createdAt: "2023-01-10T10:00:00Z",
//            updatedAt: "2023-01-15T12:00:00Z"
//        ),
//        Report(
//            id: "2",
//            user: (dao.user?.first_name ?? "") + (dao.user?.last_name ?? ""),
//            reportNumber: "RPT654321",
//            reportStatus: "Approved",
//            reportSubmitDate: "2023-02-20",
//            integrationStatus: "Integrated",
//            integrationDate: "2023-02-21",
//            reportDate: "2024-06-08",
//            expenseType: "Meals",
//            purpose: "Client lunch meeting",
//            paymentMethod: "Cash",
//            reportAmount: "150.00",
//            reportCurrency: "USD",
//            createdAt: "2023-02-18T11:00:00Z",
//            updatedAt: "2023-02-20T15:00:00Z"
//        ),
//        Report(
//            id: "3",
//            user: (dao.user?.first_name ?? "") + (dao.user?.last_name ?? ""),
//            reportNumber: "RPT789012",
//            reportStatus: "Rejected",
//            reportSubmitDate: "2023-03-10",
//            integrationStatus: "Not Integrated",
//            integrationDate: nil,
//            reportDate: "2024-06-08",
//            expenseType: "Accommodation",
//            purpose: "Hotel stay during conference",
//            paymentMethod: "Debit Card",
//            reportAmount: "500.00",
//            reportCurrency: "USD",
//            createdAt: "2023-03-08T09:00:00Z",
//            updatedAt: "2023-03-10T14:00:00Z"
//        )
//    ]
//    
//    var filteredReports: [Report] {
//        let filtered = reports.filter { report in
//            if let date = DateFormatter.apiDate.date(from: report.reportDate) {
//                return date >= initialDate && date <= finalDate
//            }
//            return false
//        }
//        
//        return filtered.sorted { report1, report2 in
//            if let date1 = DateFormatter.iso8601Full.date(from: report1.createdAt),
//               let date2 = DateFormatter.iso8601Full.date(from: report2.createdAt) {
//                return date1 > date2
//            }
//            return false
//        }
//    }
//    
//    @EnvironmentObject var authManager: AuthenticationManager
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color.white
//                    .ignoresSafeArea()
//                PFULogo()
//                ZStack {
//                    content.loadingOverlay(isLoading: $isLoading)
//                }.padding()
//            }
//            .sheet(isPresented: $isShowingAddReport, content: {
//                NewReportView(isShowing: $isShowingAddReport)
//            })
//            .onChange(of: isShowingAddReport) {
//                loadData()
//            }
//        }.onAppear(perform: loadData)
//            .refreshable(action: loadData)
//    }
//    
//    var content: some View {
//        VStack {
//            headerContent
//            line
//            HStack {
//                reportsTitle
//                Spacer()
//                newReportButton
//            }
//            datePickerContainer
//            scrollViewReports
//            Spacer()
//        }.padding()
//    }
//    
//    var headerContent: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 10) {
//                Text(authManager.user?.first_name ?? "")
//                    .font(.system(size: 17).weight(.semibold))
//                Text(authManager.user?.department ?? "")
//                    .font(.system(size: 17).weight(.semibold))
//                    .foregroundStyle(Color.black.opacity(0.5))
//            }
//            .padding(.bottom)
//            Spacer()
//        }
//    }
//    
//    var line: some View {
//        RoundedRectangle(cornerRadius: 10)
//            .frame(height: 1)
//            .foregroundStyle(Color.gray.opacity(0.4))
//    }
//    
//    var reportsTitle: some View {
//        HStack {
//            Text("Reports")
//                .font(Font.custom("Nunito", size: 26).weight(.bold))
//        }
//    }
//    
//    var newReportButton: some View {
//        Button(action: {
//            isShowingAddReport.toggle()
//        }, label: {
//            Image(systemName: "plus.circle.fill")
//                .font(.title)
//                .foregroundStyle(.oceanBlue)
//        })
//        .frame(height: 45)
//    }
//    
//    var datePickerContainer: some View {
//        VStack {
//            HStack {
//                Text("Date")
//                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
//                Spacer()
//            }
//            HStack {
//                DatePicker("", selection: $initialDate, displayedComponents: [.date])
//                    .colorScheme(.dark)
//                    .accentColor(.blue)
//                    .foregroundStyle(.white)
//                    .labelsHidden()
//                    .background {
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundStyle(.oceanBlue)
//                    }
//                RoundedRectangle(cornerRadius: 10)
//                    .frame(width: 20, height: 1)
//                    .foregroundStyle(Color.gray.opacity(0.4))
//                DatePicker("", selection: $finalDate, displayedComponents: [.date])
//                    .colorScheme(.dark)
//                    .labelsHidden()
//                    .accentColor(.blue)
//                    .background {
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundStyle(.oceanBlue)
//                    }
//                Spacer()
//            }.padding(.bottom)
//        }
//    }
//    
//    var scrollViewReports: some View {
//        ScrollView {
//            ForEach(filteredReports, id: \.id) { report in
//                ReportComponent(report: report)
//                    .padding(.horizontal, 1)
//            }
//        }
//    }
//    
//    
//    
//    private func loadData() {
//        self.isLoading = true
//        dao.fetchReports(accessToken: authManager.accessToken ?? "") { result in
//            switch result {
//            case .success(let reports):
//                print(reports)
////                self.reports = reports
//            case .failure(let error):
//                print("Failed to fetch reports: \(error)")
//            }
//            self.isLoading = false
//        }
//    }
//}
//
//#Preview {
//    ReportsView()
//        .environmentObject(AuthenticationManager())
//}
