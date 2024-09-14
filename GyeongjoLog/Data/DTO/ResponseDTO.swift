struct ResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    
    static func toResultCode(dto: ResponseDTO) -> String {
        let resultCode = dto.resultCode
        return resultCode
    }
}
