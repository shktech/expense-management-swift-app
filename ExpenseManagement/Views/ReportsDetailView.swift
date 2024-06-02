//
//  ReportsDetailView.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import SwiftUI

struct ReportsDetailView: View {
    
    let report: Reports
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ReportsDetailView(report: Reports(name: "", date: Date(), purpose: "", value: 0, status: false))
}
