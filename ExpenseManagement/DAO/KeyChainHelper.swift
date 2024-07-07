import Security
import Foundation

class KeychainHelper {
    
    static private var service: String = "pfu_expense"

    @discardableResult
    static func save(_ value: Any, forKey key: String) -> Bool {
        let data: Data?
        if let stringValue = value as? String {
            data = stringValue.data(using: .utf8)
        } else if let boolValue = value as? Bool {
            data = Data([boolValue ? 1 : 0])
        } else if let dictionaryValue = value as? [String: Any] {
            data = try? JSONSerialization.data(withJSONObject: dictionaryValue, options: [])
        } else {
            return false
        }
        
        guard let valueData = data else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: valueData
        ]
        SecItemDelete(query as CFDictionary) // Delete any existing item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    static func load(key: String) -> Any? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == errSecSuccess, let data = dataTypeRef as? Data else { return nil }
        
        if let stringValue = String(data: data, encoding: .utf8) {
            return stringValue
        } else if data.count == 1, let boolValue = data.first {
            return boolValue == 1
        } else if let dictionaryValue = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return dictionaryValue
        }
        
        return nil
    }

    @discardableResult
    static func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }

    static func deleteItem(fromDictionaryWithKey dictionaryKey: String, forItemKey itemKey: String) -> Bool {
        guard var dictionary = load(key: dictionaryKey) as? [String: Any] else { return false }
        dictionary[itemKey] = nil
        return save(dictionary, forKey: dictionaryKey)
    }
}
