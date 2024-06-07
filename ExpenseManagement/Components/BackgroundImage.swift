//
//  BackgroundImage.swift
//  ExpenseManagement
//
//  Created by infra on 30/05/24.
//

import SwiftUI

struct BackgroundImage: View {
    var opacity: Double = 1.0
    
    var body: some View {
        Image("backgroundImage")
            .resizable()
            .ignoresSafeArea()
            .aspectRatio(contentMode: .fill)
            .opacity(opacity)
    }
}

#Preview {
    BackgroundImage()
}
