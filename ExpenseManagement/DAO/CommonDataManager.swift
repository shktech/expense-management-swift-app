import Foundation
import Combine

protocol CommonDataManagerProtocol: ObservableObject {
    var airlines: [Airline] { get set }
    var rentalAgencies: [RentalAgency] { get set }
    var carTypes: [CarType] { get set }
    var mealCategories: [MealCategory] { get set }
    var relationshipsToPAI: [RelationshipToPAI] { get set }
    var cities: [City] { get set }
    var hotelDailyBaseRates: [HotelDailyBaseRate] { get set }
    var mileageRates: [MileageRate] { get set }
    var exchangeRates: [String: [String: Double]] { get set }
    
    func loadCommonData(accessToken: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchExchangeRates(base: String, accessToken: String, completion: @escaping (Result<[String: Double], Error>) -> Void)
}

class CommonDataManager: CommonDataManagerProtocol {
    static let instance = CommonDataManager()
    
    @Published var airlines: [Airline] = []
    @Published var rentalAgencies: [RentalAgency] = []
    @Published var carTypes: [CarType] = []
    @Published var mealCategories: [MealCategory] = []
    @Published var relationshipsToPAI: [RelationshipToPAI] = []
    @Published var cities: [City] = []
    @Published var hotelDailyBaseRates: [HotelDailyBaseRate] = []
    @Published var mileageRates: [MileageRate] = []
    @Published var exchangeRates: [String: [String: Double]] = [:]
    
    private let dao = DAO.instance
    
    private init() {}
    
    func loadCommonData(accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print(accessToken)
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        dao.fetchData(endpoint: "common/airlines/", accessToken: accessToken) { (result: Result<[Airline], Error>) in
            switch result {
            case .success(let data):
                self.airlines = data
            case .failure(let error):
                print("Failed to fetch airlines: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        dao.fetchData(endpoint: "common/rental-agencies/", accessToken: accessToken) { (result: Result<[RentalAgency], Error>) in
            switch result {
            case .success(let data):
                self.rentalAgencies = data
            case .failure(let error):
                print("Failed to fetch rental agencies: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        dao.fetchData(endpoint: "common/car-types/", accessToken: accessToken) { (result: Result<[CarType], Error>) in
            switch result {
            case .success(let data):
                self.carTypes = data
            case .failure(let error):
                print("Failed to fetch car types: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        dao.fetchData(endpoint: "common/meal-categories/", accessToken: accessToken) { (result: Result<[MealCategory], Error>) in
            switch result {
            case .success(let data):
                self.mealCategories = data
            case .failure(let error):
                print("Failed to fetch meal categories: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        dao.fetchData(endpoint: "common/relationships-to-pai/", accessToken: accessToken) { (result: Result<[RelationshipToPAI], Error>) in
            switch result {
            case .success(let data):
                self.relationshipsToPAI = data
            case .failure(let error):
                print("Failed to fetch relationships to PAI: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        dao.fetchData(endpoint: "common/cities/", accessToken: accessToken) { (result: Result<[City], Error>) in
            switch result {
            case .success(let data):
                self.cities = data
            case .failure(let error):
                print("Failed to fetch cities: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        dao.fetchData(endpoint: "common/hotel-daily-base-rates/", accessToken: accessToken) { (result: Result<[HotelDailyBaseRate], Error>) in
            switch result {
            case .success(let data):
                self.hotelDailyBaseRates = data
            case .failure(let error):
                print("Failed to fetch hotel daily base rates: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        dao.fetchData(endpoint: "common/mileage-rates/", accessToken: accessToken) { (result: Result<[MileageRate], Error>) in
            switch result {
            case .success(let data):
                self.mileageRates = data
            case .failure(let error):
                print("Failed to fetch mileage rates: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    func fetchExchangeRates(base: String, accessToken: String, completion: @escaping (Result<[String: Double], Error>) -> Void) {
        if let cachedRates = exchangeRates[base] {
            completion(.success(cachedRates))
            return
        }
        
        dao.fetchExchangeRates(base: base, accessToken: accessToken) { result in
            switch result {
            case .success(let rates):
                DispatchQueue.main.async {
                    self.exchangeRates[base] = rates
                    completion(.success(rates))
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
