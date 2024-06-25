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
    @State var reports: [Report] = []
    
    private let dao = DAO.instance
    
    @EnvironmentObject var floatingButtonViewModel: FloatingButtonViewModel
    
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
        }
        .onAppear {
            floatingButtonViewModel.action = {
                isShowingAddReport.toggle()
            }
            floatingButtonViewModel.visible = true
            loadData()
        }
        .refreshable(action: loadData)
    }
    
    var content: some View {
        VStack {
            headerContent
            line
            reportsTitle
//            newReportButton
            datePickerContainer
            line
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
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
                    .foregroundStyle(.white)
            }
        })
        .frame(height: 55)
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
        }.padding(.bottom, 10)
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
        .environmentObject(FloatingButtonViewModel())
}
