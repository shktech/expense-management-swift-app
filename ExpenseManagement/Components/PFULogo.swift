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
                    .padding(.top, 60)
                    .padding(.trailing, 40)
            }
            Spacer()
        }
    }
}

#Preview {
    PFULogo()
}
