import Foundation

class Utilities {
    struct CurrencyConverter {
        static func convert(amount: Double, from: String, to: String, accessToken: String, completion: @escaping (Double, Double) -> Void) {
            CommonDataManager.instance.fetchExchangeRates(base: from, accessToken: accessToken) { result in
                switch result {
                case .success(let rates):
                    let exchangeRate = rates[to] ?? 1.0
                    let convertedAmount = amount * exchangeRate
                    completion(convertedAmount, exchangeRate)
                case .failure:
                    completion(amount, 0.0)
                }
            }
        }
    }

    struct CurrencyFormatter {
        static func formatCurrency(amount: String, currencyCode: String) -> String {
            guard let amount = Double(amount) else {
                return "Invalid amount"
            }
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = currencyCode
            
            if currencyCode == "JPY" {
                formatter.minimumFractionDigits = 0
                formatter.maximumFractionDigits = 0
            } else {
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
            }
            
            return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        }
    }
}
