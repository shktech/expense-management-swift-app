//
//  PFULogo.swift
//  ExpenseManagement
//
//  Created by infra on 30/05/24.
//

import SwiftUI

struct PFULogo: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
                    .padding(.top, UIScreen.main.bounds.height / 10)
                    .padding(.trailing, 20)
            }
            Spacer()
        }.ignoresSafeArea()
    }
}

#Preview {
    PFULogo()
}
