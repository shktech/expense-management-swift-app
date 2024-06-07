import SwiftUI

struct ReportsDetailView: View {
    
    let report: Report
    
    @State var isShowingForm: Bool = false
    @State var isLoading: Bool = false
    @State var expenseItems: [ExpenseItem] = []
    
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                ZStack {
                    ourPfu
                    content.loadingOverlay(isLoading: $isLoading)
                }.padding()
            }
        }.sheet(isPresented: $isShowingForm, content: {
            NewExpenseForm(isShowingSelf: $isShowingForm, report: report)
        })
        .onChange(of: isShowingForm) {
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
            headerContent
            line
            reportHeader
            addNewButton
            expenseItemsList
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
    
    var reportHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(report.reportNumber)
                    .font(.system(size: 32).weight(.semibold))
                if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                    Text(DateFormatter.userFriendly.string(from: date))
                        .font(.system(size: 17))
                        .foregroundStyle(.gray)
                }
                Text(report.purpose)
                    .font(.system(size: 17).weight(.semibold))
                Text(report.reportStatus)
                    .foregroundStyle(report.reportStatus == "Submitted" ? .green : .red)
                    .font(.system(size: 15))
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
                    .foregroundStyle(.black.opacity(0.5))
                Text("+ Add New Expense")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundStyle(.white)
            }
        }).frame(height: 45)
    }

    var expenseItemsList: some View {
        VStack {
            ScrollView {
                ForEach(expenseItems, id:\.id) { expenseItem in
                    ExpenseComponent(expense: expenseItem)
                }
            }
        }.padding(.top)
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
                print(items)
                self.expenseItems = items
            case .failure(let error):
                print("Failed to fetch items: \(error)")
            }
            self.isLoading = false
        }
    }

}

//#Preview {
//    ReportsDetailView(report: Reports(name: "Exp 1020", date: Date(), purpose: "New Conference", status: false, expenseItems: [
//        ExpenseItem(type: .Food, date: Date(), value: 120, purpose: "New Conference", preferredPaymentMethod: CreditCard(cardNumber: "", expirationDate: Date()), currency: "USD"),ExpenseItem(type: .Food, date: Date(), value: 120, purpose: "New Conference", preferredPaymentMethod: CreditCard(cardNumber: "", expirationDate: Date()), currency: "USD")
//    ]), user: User(name: "John Doe", username: "johnDoe", email: "john.doe@example.com", password: "password123", department: "IT Department", reports: [], paymentMethods: [
//        CreditCard(cardNumber: "1234123412341234", expirationDate: Date().addingTimeInterval(-3600)),
//        CreditCard(cardNumber: "1234123412341234", expirationDate: Date())
//    ]))
//}
