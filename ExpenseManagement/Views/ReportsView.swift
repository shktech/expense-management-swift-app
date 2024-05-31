//
//  ReportsView.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import SwiftUI
struct ReportsView: View {
    
    var user: User?
    
    @State var initialDate: Date = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
    @State private var finalDate: Date = {
            let calendar = Calendar.current
            let now = Date()
            let startOfDay = calendar.startOfDay(for: now)
            return calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
        }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                PFULogo()
                ZStack {
                    content
                }.padding()
            }
        }
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
                Text(user?.name ?? "")
                    .font(.system(size: 17).weight(.semibold))
                Text(user?.department ?? "")
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
            // Add new Report
            dao.addReports()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.blue)
                Text("+ Add New Report")
                    .foregroundStyle(.white)
                    .font(.system(size: 17).weight(.semibold))
            }
        })
        .frame(width: .infinity, height: 45)
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
            ForEach(filteredReports) { report in
                ReportComponent(report: report)
            }
        }
    }
    
    var filteredReports: [Reports] {
        guard let reports = user?.reports else { return [] }
        return reports.filter { report in
            report.date >= initialDate && report.date <= finalDate
        }
    }
}


#Preview {
    ReportsView(user: User(name: "John Doe", email: "john.doe@example.com", password: "password123", department: "IT Department", reports: [
        Reports(name: "Exp 1019", type: .Hotel, date: Calendar.current.date(byAdding: .day, value: -31, to: Date())!, purpose: "LA Conference", value: 120.89, status: false),
        Reports(name: "Exp 1020", type: .Hotel, date: Date(), purpose: "LA Conference", value: 120.89, status: true),
        Reports(name: "Exp 1021", type: .Hotel, date: Calendar.current.date(byAdding: .day, value: -15, to: Date())!, purpose: "LA Conference", value: 120.89, status: true),
        Reports(name: "Exp 1022", type: .Hotel, date: Date(), purpose: "LA Conference", value: 120.89, status: false)
    ]))
}
