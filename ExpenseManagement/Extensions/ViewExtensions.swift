import Foundation
import SwiftUI

extension View {
    func roundedBorder(color: Color, lineWidth: CGFloat) -> some View {
        self.modifier(RoundedBorderModifier(color: color, lineWidth: lineWidth))
    }
    
    func truncatedFileName(_ fileName: String, maxLength: Int) -> some View {
        self.modifier(TruncatedFileNameModifier(fileName: fileName, maxLength: maxLength))
    }
    
    func addTopRight<T: View>(view overlayClosure: @autoclosure @escaping () -> T) -> some View {
        modifier(TopRight(overlay:overlayClosure()))
    }
    func addTopRight(@ViewBuilder _ overlayClosure: @escaping () -> some View) -> some View {
        modifier(TopRight(overlay:overlayClosure()))
    }
}

struct TopRight<T: View>: ViewModifier {
    let overlay: T
    public func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            content
            VStack {
                HStack {
                    Spacer()
                    overlay
                }
                Spacer()
            }
        }
    }
}


struct RoundedBorderModifier: ViewModifier {
    var color: Color
    var lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: lineWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension String {
    func truncatedFilename(to maxLength: Int) -> String {
        let components = self.split(separator: ".")
        guard components.count > 1 else { return self.truncated(to: maxLength) }
        
        let filename = components.dropLast().joined(separator: ".")
        let fileExtension = components.last!
        
        let truncatedFilename = filename.truncated(to: maxLength - fileExtension.count - 1)
        return "\(truncatedFilename).\(fileExtension)"
    }
    
    private func truncated(to maxLength: Int) -> String {
        guard self.count > maxLength else { return self }
        
        let start = self.prefix(maxLength / 2)
        let end = self.suffix(maxLength / 2)
        return "\(start)...\(end)"
    }
    
    func chunked(by chunkSize: Int) -> [SubSequence] {
        stride(from: 0, to: count, by: chunkSize).map {
            self[index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: Swift.min($0 + chunkSize, count))]
        }
    }
}

struct TruncatedFileNameModifier: ViewModifier {
    var fileName: String
    var maxLength: Int

    func body(content: Content) -> some View {
        content
            .overlay(
                Text(fileName.truncatedFilename(to: maxLength))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
            )
    }
}
