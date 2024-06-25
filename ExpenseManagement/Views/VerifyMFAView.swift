import SwiftUI

struct VerifyMFAView: View {
    @State private var code: [String] = Array(repeating: "", count: 5)
    @FocusState private var focusedField: Int?
    @State private var isLoading = false
    @State private var verificationFailed = false
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGray6).ignoresSafeArea()
                ZStack {
                    ourPfu
                    content
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $authManager.isSignedIn) {
                TabViewContainer()
            }
            
        }
    }
    
    var ourPfu: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
            }
            Spacer()
        }.ignoresSafeArea().padding()
    }
    
    var content: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Enter code")
                        .font(Font.custom("Poppins", size: 30).weight(.bold))
                        .foregroundColor(.black)
                    
                    Text("We’ve sent an SMS with an activation code to the registered phone number")
                        .font(Font.custom("Inter", size: 16))
                        .foregroundColor(Color.black.opacity(0.70))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack(spacing: 10) {
                        ForEach(0..<5, id: \.self) { index in
                            TextField("", text: $code[index])
                                .frame(width: 64, height: 72)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(focusedField == index ? Color.black : Color(.systemGray2), lineWidth: focusedField == index ? 1 : 0.80)
                                )
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 24, weight: .bold))
                                .focused($focusedField, equals: index)
                                .keyboardType(.numberPad)
                                .onChange(of: code[index]) { newValue in
                                    if newValue.count == 1 && index < 4 {
                                        focusedField = index + 1
                                    } else if newValue.count == 0 && index > 0 {
                                        focusedField = index - 1
                                    }
                                    checkCompleteCode()
                                }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height / 2)
                
                Spacer()
            }
        }
        
    }
    
    private func checkCompleteCode() {
        if code.allSatisfy({ $0.count == 1 }) {
            self.isLoading = true
            var mfaCode: String = code.joined()
            authManager.verifyMFA(code: mfaCode) { result in
                isLoading = false
                switch result {
                case .success(_):
                    break;
                case .failure(let error):
                    self.verificationFailed = true
                }
            }
            
        }
    }
}

//#Preview {
//    VerifyMFAView()
//}
