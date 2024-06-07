import Foundation

class ExpenseDataManager: ObservableObject {
    static let instance = ExpenseDataManager()
    private let dao = DAO.instance

    @Published var reports: [Report] = []
    @Published var items: [ExpenseItem] = []

    private init() {}

    func fetchReports(accessToken: String, completion: @escaping (Result<[Report], Error>) -> Void) {
        dao.fetchReports(accessToken: accessToken) { result in
            switch result {
            case .success(let reports):
                DispatchQueue.main.async {
                    self.reports = reports
                }
                completion(.success(reports))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchReportItems(reportId: Int, accessToken: String, completion: @escaping (Result<[ExpenseItem], Error>) -> Void) {
        dao.fetchReportItems(reportId: reportId, accessToken: accessToken) { result in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.items = items
                }
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
