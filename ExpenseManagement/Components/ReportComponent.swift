//
//  ReportComponent.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import SwiftUI

struct ReportComponent: View {
    
    let report: Reports
    
    var body: some View {
        NavigationLink(destination: ReportsDetailView(report: report, user: dao.user)) {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(report.id)")
                            .font(.system(size: 17))
                            .foregroundStyle(.black)
                        Text(report.createdAt.formatted(date: .numeric, time: .omitted))
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                        Text(report.purpose)
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
//                        Text("\(report.value.formatted())")
//                            .font(.system(size: 15))
//                            .foregroundStyle(.gray)
                        Text(report.reportStatus)
                            .foregroundStyle(report.reportStatus == "Submitted" ? .green : .red)
                            .font(.system(size: 15))
                    }
                    Spacer()
                    HStack(spacing: 0) {
                        Text("Detail")
                            .foregroundStyle(.black.opacity(0.5))
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.black.opacity(0.3))
                            .fontWeight(.semibold)
                    }
                }.padding()
            }
            .frame(height: 127)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
        }
    }
}

//#Preview {
//    ReportComponent(report: Reports(name: "Exp 1019", date: Date(), purpose: "LA Conference", status: false, expenseItems: []))
//}
