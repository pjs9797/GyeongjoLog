import Foundation

struct ConfigManager {
    static var BaseURL: String {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found")
        }
        
        guard let baseURL = infoDictionary["BASE_URL"] as? String else {
            fatalError("BaseURL not found in Info.plist")
        }
        return baseURL
    }
}
