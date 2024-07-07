import SwiftUI

struct WarningMessageView: View {
    let expenseType: ExpenseType

    var warningMessage: String? {
        switch expenseType {
        case .airlineClubMembershipDues:
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        case .autoRental, .automobile:
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        case .companySponsorVPDF:
            return "Pre-approval required, include approved form with receipts"
        case .customerGifts:
            return "Pre-approval required, include approved form with receipts"
        case .dataProcessingDisksManual:
            return "Pre-approval required, include approved form with receipts"
        case .entertainment, .entertainmentLevi:
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        case .fieldEngineerSupplies:
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        case .officeSupplies:
            return "Must include approved Purchase Requisition number"
        case .otherMarketingExpenses:
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        case .seminarsTraining:
            return "Must include approved ETA number. Enter ETA number in Justification field"
        case .marketingDevelopment:
            return "Approved Requisition is required for this expense type. Enter Requisition number in Justification Field"
        default:
            return nil
        }
    }

    var body: some View {
        if let warningMessage = warningMessage {
            Text(warningMessage)
                .foregroundColor(.red)
                .font(Font.custom("Poppins", size: 12).weight(.semibold))
                .multilineTextAlignment(.center)
        }
    }
}

struct WarningMessageView_Previews: PreviewProvider {
    static var previews: some View {
        WarningMessageView(expenseType: .airlineClubMembershipDues)
    }
}
