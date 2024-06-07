import Foundation

class Utilities {
    struct CurrencyConverter {
        static func convert(amount: Double, from: String, to: String) -> Double {
            let exchangeRate = exchangeRate(from: from, to: to)
            return amount * exchangeRate
        }

        private static func exchangeRate(from: String, to: String) -> Double {
            // Define exchange rates for conversion
            let rates: [String: [String: Double]] = [
                "USD": ["CAD": 0.80, "JPY": 110.0, "USD": 1.0],
                "CAD": ["USD": 1.25, "JPY": 88.0, "CAD": 1.0],
                "JPY": ["USD": 0.0091, "CAD": 0.011, "JPY": 1.0]
            ]
            
            return rates[from]?[to] ?? 1.0
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
