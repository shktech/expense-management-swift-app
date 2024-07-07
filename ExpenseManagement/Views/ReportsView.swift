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
                    .frame(width: 55, height: 55)
                    .foregroundColor(.oceanBlue)
            }
            .zIndex(1)
        }.padding()
    }
    
    var datePickerContainer: some View {
        DateFilterPicker(initialDate: $initialDate, finalDate: $finalDate, isEditable: .constant(true))
//        HStack {
//            DatePicker("", selection: $initialDate, displayedComponents: [.date] )
//                .labelsHidden()
//            RoundedRectangle(cornerRadius: 10)
//                .frame(width: 20, height: 1)
//                .foregroundStyle(Color.gray.opacity(0.4))
//            DatePicker("", selection: $finalDate, displayedComponents: [.date])
//                .labelsHidden()
//            Spacer()
//        }.padding(.bottom, 10)
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
