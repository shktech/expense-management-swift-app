import SwiftUI

struct ReportStatusView: View {
    let reportStatus: String
    
    var body: some View {
        Text(reportStatus)
            .foregroundColor(textColor(for: reportStatus))
            .font(.system(size: 10).weight(.semibold))
            .roundedBorder(color: textColor(for: reportStatus), lineWidth: 2)
    }
    
    private func textColor(for status: String) -> Color {
        switch status {
        case "Open":
            return .red
        case "Submitted":
            return .yellow
        case "Approved":
            return .teal
        case "Paid":
            return .green
        default:
            return .gray
        }
    }
}

#Preview {
    VStack {
        ReportStatusView(reportStatus: "Open")
        ReportStatusView(reportStatus: "Submitted")
        ReportStatusView(reportStatus: "Approved")
        ReportStatusView(reportStatus: "Paid")
        ReportStatusView(reportStatus: "Unknown")
    }
}
