import SwiftUI

struct TimelineView: View {
    let steps: [(Bool, String)]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<steps.count, id: \.self) { index in
                VStack {
                    if index != 0 {
                        line(isCompletedBefore: steps[index - 1].0, isCompletedAfter: steps[index].0)
                    }
                    stepCircle(isCompleted: steps[index].0)
                    Text(steps[index].1)
                        .font(.system(size: 12))
                        .foregroundColor(.oceanBlue)
                }
                if index != steps.count - 1 {
                    line(isCompletedBefore: steps[index].0, isCompletedAfter: steps[index + 1].0)
                        .padding(.horizontal, -20)
                        .padding(.vertical, -10)
                }
            }
        }.padding(.horizontal)
    }
    
    func line(isCompletedBefore: Bool, isCompletedAfter: Bool) -> some View {
        Spacer()
            .frame(height: isCompletedBefore && isCompletedAfter ? 4 : 1)
            .background(Color.oceanBlue)
    }
    
    func stepCircle(isCompleted: Bool) -> some View {
        ZStack {
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(Font.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Image(systemName: "ellipsis")
                    .font(Font.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 30, height: 30)
        .background(Color.oceanBlue)
        .cornerRadius(15)
    }
}

struct TimeLineContentView: View {
    let status: String
    
    var body: some View {
        VStack {
            TimelineView(steps: generateSteps(from: status))
        }
    }
    
    func generateSteps(from status: String) -> [(Bool, String)] {
        var steps: [(String, Bool)] = [
            ("Submitted", false),
            ("Approved", false),
            ("Paid", false)
        ]
        switch (status) {
        case "Submitted":
            steps = [
                ("Submitted", true),
                ("Approved", false),
                ("Paid", false)
            ]
            break
        case "Approved":
            steps = [
                ("Submitted", true),
                ("Approved", true),
                ("Paid", false)
            ]
            break
        case "Paid":
            steps = [
                ("Submitted", true),
                ("Approved", true),
                ("Paid", true)
            ]
            break
        default:
            break
        }
        return steps.map { ($0.1, $0.0) }
    }
}

#Preview {
    TimeLineContentView(status: "Submitted")
}
