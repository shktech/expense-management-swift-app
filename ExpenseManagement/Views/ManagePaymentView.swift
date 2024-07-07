//import SwiftUI
//
//struct ManagePaymentView: View {
//    
//    @Binding var isShowing: Bool
//    @EnvironmentObject var authManager: AuthenticationManager
//        
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color(uiColor: .systemGray6)
//                    .ignoresSafeArea()
//                PFULogo()
//                ZStack {
//                    content
//                }.padding()
//            }
//        }
//    }
//    
//    var content: some View {
//        VStack {
//            headerContent
//            line
//            defaultPaymentMethod
//            creditCards
//            Spacer()
//            saveButton
//        }.padding()
//    }
//    
//    var headerContent: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 10) {
//                Text(authManager.user?.first_name ?? "")
//                    .font(.system(size: 17).weight(.semibold))
//                Text(authManager.user?.department ?? "")
//                    .font(.system(size: 17).weight(.semibold))
//                    .foregroundStyle(Color.black.opacity(0.5))
//            }
//            .padding(.bottom)
//            Spacer()
//        }
//    }
//    
//    var line: some View {
//        RoundedRectangle(cornerRadius: 10)
//            .frame(height: 1)
//            .foregroundStyle(Color.gray.opacity(0.4))
//    }
//    
//    var defaultPaymentMethod: some View {
//        VStack(alignment: .leading, spacing: 3) {
//            Text("Default Payment Method")
//                .foregroundStyle(.gray)
//            Menu {
//                Button(action: {
//                    
//                }, label: {
//                    Text("Card ending in 1111")
//                })
//                Button(action: {
//                    
//                }, label: {
//                    Text("Card ending in 2222")
//                })
//            } label: {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.black.opacity(0.5), lineWidth: 2)
//                        .frame(height: 41)
//                        .foregroundStyle(Color(uiColor: .systemGray6))
//                    HStack {
//                        if authManager.user?.creditCard != nil {
//                            Text("Card ending in xxx")
//                                .foregroundStyle(Color.gray)
//                        } else {
//                            Text("---")
//                                .foregroundStyle(Color.gray)
//                        }
//                        Spacer()
//                        Image(systemName: "chevron.down")
//                            .foregroundStyle(Color.gray)
//                    }.padding()
//                }
//            }
//        }.padding(.top, 7)
//    }
//    
//    var creditCards: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Credit Card")
//                .foregroundStyle(.gray)
//            if authManager.user?.creditCard != nil {
//                let card = authManager.user?.creditCard ?? nil
//                VStack(spacing: 0) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.black.opacity(0.5), lineWidth: 2)
//                                .frame(height: 41)
//                                .foregroundStyle(Color(uiColor: .systemGray6))
//                            HStack() {
//                                Image("Visa")
//                                Text("XXX.XXX.XXX.\(getLastFourCharacters(from: card?.cardNumber ?? ""))")
//                                    .foregroundStyle(Color.black.opacity(0.3))
//                                Spacer()
//                                Button(action: {
//                                    
//                                }, label: {
//                                    Image(systemName: "trash")
//                                        .foregroundStyle(.red)
//                                })
//                            }.padding()
//                        }
//                }
//            } else {
//                NavigationLink(destination: NewCreditCardForm()) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 8)
//                            .frame(height: 41)
//                            .foregroundStyle(.green)
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.black.opacity(0.5), lineWidth: 2)
//                            .frame(height: 41)
//                            .foregroundStyle(Color(uiColor: .systemGray6))
//                        HStack() {
//                            Text("+ Add new Credit Card")
//                                .fontWeight(.bold)
//                                .foregroundStyle(.white)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    var saveButton: some View {
//        Button(action: {
//            
//        }, label: {
//            ZStack {
//                RoundedRectangle(cornerRadius: 14)
//                    .foregroundStyle(.blue)
//                Text("Save")
//                    .foregroundStyle(.white)
//                    .font(.system(size: 17).weight(.semibold))
//            }
//        }).frame(height: 45)
//    }
//    
//    var cancelButton: some View {
//        Button(action: {
//            isShowing.toggle()
//        }, label: {
//            ZStack {
//                RoundedRectangle(cornerRadius: 14)
//                    .foregroundStyle(.gray)
//                Text("Cancel")
//                    .foregroundStyle(.white)
//                    .font(.system(size: 17).weight(.semibold))
//            }
//        }).frame(height: 45)
//    }
//    
//    func getLastFourCharacters(from string: String) -> String {
//            let length = string.count
//            if length < 4 {
//                return string
//            }
//            let startIndex = string.index(string.endIndex, offsetBy: -4)
//            let lastFour = string[startIndex...]
//            return String(lastFour)
//        }
//}
//
//#Preview {
//    ManagePaymentView(isShowing: .constant(false))
//        .environmentObject(AuthenticationManager())
//}
