import SwiftUI


struct ReportsView: View {
    
    @State var initialDate: Date = Calendar.current.date(byAdding: .day, value: -180, to: Date())!
    @State private var finalDate: Date = {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        return calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
    }()
    
    @State var isShowingAddReport: Bool = false
    @State private var isLoading = false
    @State private var reports: [Report] = []
    
//    let reports: [Report] = [
//        Report(
//            id: 1,
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
//            id: 2,
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
//            id: 3,
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
    
    var filteredReports: [Report] {
        let filtered = reports.filter { report in
            if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                return date >= initialDate && date <= finalDate
            }
            return false
        }
        
        return filtered.sorted { report1, report2 in
            if let date1 = DateFormatter.iso8601Full.date(from: report1.createdAt),
               let date2 = DateFormatter.iso8601Full.date(from: report2.createdAt) {
                return date1 > date2
            }
            return false
        }
    }
    
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                PFULogo()
                ZStack {
                    content.loadingOverlay(isLoading: $isLoading)
                }.padding()
            }
            .sheet(isPresented: $isShowingAddReport, content: {
                NewReportView(isShowing: $isShowingAddReport)
            })
            .onChange(of: isShowingAddReport) {
                loadData()
            }
        }.onAppear(perform: loadData)
            .refreshable(action: loadData)
    }
    
    var content: some View {
        VStack {
            headerContent
            line
            reportsTitle
            newReportButton
            datePickerContainer
            scrollViewReports
            Spacer()
        }.padding()
    }
    
    var headerContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(authManager.user?.first_name ?? "")
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
            Text("Reports")
                .font(.system(size: 32).weight(.semibold))
            Spacer()
        }
    }
    
    var newReportButton: some View {
        Button(action: {
            isShowingAddReport.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.blue)
                Text("+ Add New Report")
                    .foregroundStyle(.white)
                    .font(.system(size: 17).weight(.semibold))
            }
        })
        .frame(height: 45)
    }
    
    var datePickerContainer: some View {
        HStack {
            DatePicker("", selection: $initialDate, displayedComponents: [.date] )
                .labelsHidden()
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 20, height: 1)
                .foregroundStyle(Color.gray.opacity(0.4))
            DatePicker("", selection: $finalDate, displayedComponents: [.date])
                .labelsHidden()
            Spacer()
        }.padding(.vertical)
    }
    
    var scrollViewReports: some View {
        ScrollView {
            ForEach(filteredReports, id: \.id) { report in
                ReportComponent(report: report)
            }
        }
    }
    
    
    
    private func loadData() {
        self.isLoading = true
        dao.fetchReports(accessToken: authManager.accessToken ?? "") { result in
            switch result {
            case .success(let reports):
                print(reports)
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
