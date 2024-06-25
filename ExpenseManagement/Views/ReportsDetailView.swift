import SwiftUI

struct ReportsDetailView: View {
    
    @Binding var report: Report
    
    @State var isShowingForm: Bool = false
    @State var isLoading: Bool = false
    @State var expenseItems: [ExpenseItem] = []
    
    @EnvironmentObject var authManager: AuthenticationManager
    
    private let dao = DAO.instance
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                ZStack {
                    content.loadingOverlay(isLoading: $isLoading)
                }.padding()
            }
        }.sheet(isPresented: $isShowingForm, content: {
            SelectTypeForm(isShowingSelf: $isShowingForm, report: report)
        })
        .onChange(of: isShowingForm) {
            if !isShowingForm {
                refreshReport()
            }
            loadData()
        }
        .onAppear(perform: loadData)
    }
    
    var ourPfu: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
            }
            Spacer()
        }.ignoresSafeArea()
    }
    
    var content: some View {
        VStack {
            reportHeader
            addNewButton
            expenseItemsList
            Spacer()
            submittingButton
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
    
    var reportHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(report.reportNumber)
                        .font(Font.custom("Nunito", size: 32).weight(.semibold))
                        .foregroundStyle(.ourDarkGray)
                    if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                        Text(DateFormatter.userFriendly.string(from: date))
                            .font(Font.custom("Poppins", size: 17).weight(.semibold))
                            .foregroundStyle(.gray)
                    }
                }
                Text(report.purpose)
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.ourDarkGray)
                Text("\(Utilities.CurrencyFormatter.formatCurrency(amount: report.reportAmount, currencyCode: report.reportCurrency))")
                    .font(Font.custom("Nunito", size: 18).weight(.bold))
                    .foregroundStyle(.oceanBlue)
            }
            Spacer()
        }
    }
    
    var addNewButton: some View {
        Button(action: {
            isShowingForm.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.oceanBlue.opacity(0.75))
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.oceanBlue2, lineWidth: 4)
                Text("+ Add New Expense")
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
                    .foregroundStyle(.white)
            }
        }).frame(height: 55)
    }

    var expenseItemsList: some View {
        VStack {
            ScrollView {
                ForEach(expenseItems, id:\.id) { expenseItem in
                    ExpenseComponent(expense: expenseItem)
                        .frame(height: 86)
                        .padding(.vertical, 7)
                }
            }
        }.padding(.top)
    }
    
    var submittingButton: some View {
        Button {
            // submitting
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.oceanBlue)
                Text("Submit")
                    .font(Font.custom("Poppins", size: 17).weight(.semibold))
                    .foregroundStyle(.white)
            }
        }.frame(height: 45)
    }
    
    private func loadData() {
        self.isLoading = true
        guard let accessToken = authManager.accessToken else {
            print("Access token not found")
            return
        }
        dao.fetchReportItems(reportId: report.id, accessToken: accessToken) { result in
            switch result {
            case .success(let items):
                self.expenseItems = items
            case .failure(let error):
                print("Failed to fetch items: \(error)")
            }
            self.isLoading = false
        }
    }
    
    private func refreshReport() {
        self.isLoading = true
        guard let accessToken = authManager.accessToken else {
            print("Access token not found")
            return
        }
        dao.fetchReport(reportId: report.id, accessToken: accessToken) { result in
            switch result {
            case .success(let report):
                print("Refreshing report")
                self.report = report
            case .failure(let error):
                print("Failed to fetch report: \(error)")
            }
            self.isLoading = false
        }

    }

}

#Preview {
    ReportsDetailView(report: .constant(
                        Report(
                            id: "1",
                            reportNumber: "RPT123456",
                            reportStatus: "Pending",
                            reportSubmitDate: "2023-01-15",
                            integrationStatus: "Not Integrated",
                            integrationDate: nil,
                            reportDate: "2024-06-08",
                            expenseType: "Travel",
                            purpose: "Business trip to NYC",
                            paymentMethod: "Credit Card",
                            reportAmount: "1200.00",
                            reportCurrency: "USD",
                            createdAt: "2023-01-10T10:00:00Z",
                            updatedAt: "2023-01-15T12:00:00Z"
                        )))
    .environmentObject(AuthenticationManager())
}
