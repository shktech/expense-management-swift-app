import SwiftUI

struct SmallToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color.oceanBlue : Color.gray)
                .frame(width: 40, height: 20)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(Animation.linear(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
