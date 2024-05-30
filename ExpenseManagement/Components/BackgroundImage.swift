//
//  BackgroundImage.swift
//  ExpenseManagement
//
//  Created by infra on 30/05/24.
//

import SwiftUI

struct BackgroundImage: View {
    var body: some View {
        Image("backgroundImage")
            .resizable()
            .ignoresSafeArea()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    BackgroundImage()
}
