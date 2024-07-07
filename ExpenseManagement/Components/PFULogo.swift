import SwiftUI

struct PFULogo: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
                    .resizable()
                    .frame(width: 80, height: 40)
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
