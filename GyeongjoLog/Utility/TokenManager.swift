import Foundation

class TokenManager {
    static let shared = TokenManager()

    private init() {}

    func saveAccessToken(_ token: String) {
        guard let data = token.data(using: .utf8) else { return }
        KeychainHelper.shared.save(data, account: "accessToken")
    }

    func loadAccessToken() -> String? {
        guard let data = KeychainHelper.shared.load(account: "accessToken") else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func deleteAccessToken() {
        KeychainHelper.shared.delete(account: "accessToken")
    }

    func saveRefreshToken(_ token: String) {
        guard let data = token.data(using: .utf8) else { return }
        KeychainHelper.shared.save(data, account: "refreshToken")
    }

    func loadRefreshToken() -> String? {
        guard let data = KeychainHelper.shared.load(account: "refreshToken") else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func deleteRefreshToken() {
        KeychainHelper.shared.delete(account: "refreshToken")
    }
}
