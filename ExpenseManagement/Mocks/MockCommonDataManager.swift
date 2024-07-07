import Foundation
import Combine

class MockCommonDataManager: CommonDataManagerProtocol {
    @Published var airlines: [Airline] = [
        Airline(value: "Air Canada"),
        Airline(value: "Air Transat"),
        Airline(value: "American Airlines"),
        Airline(value: "Delta Airlines"),
        Airline(value: "Japan Airlines"),
        Airline(value: "OTHER"),
        Airline(value: "Porter"),
        Airline(value: "Sunwing"),
        Airline(value: "Westjet")
    ]
    
    @Published var rentalAgencies: [RentalAgency] = [
        RentalAgency(value: "Enterprise"),
        RentalAgency(value: "Hertz"),
        RentalAgency(value: "Avis"),
        RentalAgency(value: "Budget"),
        RentalAgency(value: "National"),
        RentalAgency(value: "Alamo"),
        RentalAgency(value: "Thrifty"),
        RentalAgency(value: "Dollar"),
        RentalAgency(value: "Sixt")
    ]
    
    @Published var carTypes: [CarType] = [
        CarType(value: "Mock Sedan", description: ""),
        CarType(value: "Mock SUV", description: ""),
        CarType(value: "Mock Convertible", description: ""),
        CarType(value: "Mock Coupe", description: ""),
        CarType(value: "Mock Hatchback", description: "")
    ]
    
    @Published var mealCategories: [MealCategory] = [
        MealCategory(value: "Breakfast"),
        MealCategory(value: "Lunch"),
        MealCategory(value: "Dinner"),
        MealCategory(value: "Snack"),
        MealCategory(value: "Drinks")
    ]
    
    @Published var relationshipsToPAI: [RelationshipToPAI] = [
        RelationshipToPAI(value: "Parent"),
        RelationshipToPAI(value: "Child"),
        RelationshipToPAI(value: "Sibling"),
        RelationshipToPAI(value: "Spouse"),
        RelationshipToPAI(value: "Friend")
    ]
    
    @Published var cities: [City] = [
        City(value: "Alberta"),
        City(value: "Barrie"),
        City(value: "Bellevue"),
        City(value: "Boston"),
        City(value: "British Columbia"),
        City(value: "Calgary"),
        City(value: "CAN-Other Cities"),
        City(value: "CAN-Toronto, Vancouver, and Calgary"),
        City(value: "Canada"),
        City(value: "CANADA-Calgary"),
        City(value: "CANADA-Other"),
        City(value: "CANADA-Toronto"),
        City(value: "CANADA-Vancouver"),
        City(value: "Chandler"),
        City(value: "Chicago"),
        City(value: "Chicoutimi?Jonquiere"),
        City(value: "Edmonton"),
        City(value: "Fredericton"),
        City(value: "Gatineau"),
        City(value: "Guelph"),
        City(value: "Halifax"),
        City(value: "JAPAN-Other"),
        City(value: "Japan-Other Cities"),
        City(value: "JAPAN-Tokyo"),
        City(value: "JAPAN-Yokohama"),
        City(value: "Japan-Yokohama, Tokyo"),
        City(value: "Kanata"),
        City(value: "Kingston"),
        City(value: "Lethbridge"),
        City(value: "London"),
        City(value: "Los Angeles"),
        City(value: "Manitoba"),
        City(value: "Moncton"),
        City(value: "Nanaimo"),
        City(value: "New York City"),
        City(value: "Ontario"),
        City(value: "Other"),
        City(value: "Ottawa"),
        City(value: "Peterborough"),
        City(value: "Philadelphia"),
        City(value: "Quebec City"),
        City(value: "Red Deer"),
        City(value: "Regina"),
        City(value: "San Francisco"),
        City(value: "San Jose"),
        City(value: "Santa Clara"),
        City(value: "Saskatoon"),
        City(value: "Scottsdale"),
        City(value: "Seattle"),
        City(value: "Sherbrooke"),
        City(value: "St. Catharines?Niagara Falls"),
        City(value: "St. John's"),
        City(value: "Sudbury"),
        City(value: "Sunnyvale"),
        City(value: "Tokyo"),
        City(value: "Toronto"),
        City(value: "Trois-Rivieres"),
        City(value: "USA-Bellevue"),
        City(value: "USA-Bellevue/Seattle, WA"),
        City(value: "USA-Boston"),
        City(value: "USA-Boston, MA"),
        City(value: "USA-Chicago"),
        City(value: "USA-Chicago, IL"),
        City(value: "USA-El Segundo"),
        City(value: "USA-El Segundo/Los Angeles/Irvine, CA"),
        City(value: "USA-Irvine"),
        City(value: "USA-Los Angeles"),
        City(value: "USA-New York City"),
        City(value: "USA-New York City, NY"),
        City(value: "USA-Other"),
        City(value: "USA-Other Cities"),
        City(value: "USA-Philadelphia"),
        City(value: "USA-San Francisco Bay Area"),
        City(value: "USA-San Jose"),
        City(value: "USA-Santa Clara"),
        City(value: "USA-Seattle"),
        City(value: "USA-Sunnyvale"),
        City(value: "USA-Sunnyvale/San Jose/Santa Clara, San Francisco, CA and Bay Area"),
        City(value: "USA-Washington DC"),
        City(value: "USA-Washington, DC"),
        City(value: "Vancouver"),
        City(value: "Victoria"),
        City(value: "Washington DC"),
        City(value: "Windsor"),
        City(value: "Winnipeg"),
        City(value: "Yokohoma")
    ]
    
    @Published var hotelDailyBaseRates: [HotelDailyBaseRate] = [
        HotelDailyBaseRate(id: 1, country: "USA", city: "New York", amount: "300", currency: "USD"),
        HotelDailyBaseRate(id: 2, country: "Canada", city: "Toronto", amount: "250", currency: "CAD"),
        HotelDailyBaseRate(id: 3, country: "Japan", city: "Tokyo", amount: "35000", currency: "JPY")
    ]
    
    @Published var mileageRates: [MileageRate] = [
        MileageRate(id: 1, rate: "0.56", title: "Standard Rate"),
        MileageRate(id: 2, rate: "0.70", title: "Business Rate")
    ]
    
    @Published var exchangeRates: [String: [String: Double]] = [
        "USD": [
            "CAD": 1.37,
            "EUR": 0.93,
            "GBP": 0.79,
            "INR": 83.42,
            "JPY": 160.81
        ],
        "CAD": [
            "USD": 0.73,
            "EUR": 0.68,
            "GBP": 0.58,
            "INR": 61.00,
            "JPY": 117.50
        ]
    ]
    
    func loadCommonData(accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func fetchExchangeRates(base: String, accessToken: String, completion: @escaping (Result<[String: Double], Error>) -> Void) {
        if let rates = exchangeRates[base] {
            completion(.success(rates))
        } else {
            completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Exchange rates not found"])))
        }
    }
}
