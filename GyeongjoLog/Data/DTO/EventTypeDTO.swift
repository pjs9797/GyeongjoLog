struct EventTypeResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: [EventTypeDTO]
    
    static func toEventTypes(dto: EventTypeResponseDTO) -> [EventType] {
        return dto.data.map { EventTypeDTO in
            return EventType(name: EventTypeDTO.eventType, color: EventTypeDTO.color)
        }
    }
}

struct EventTypeDTO: Codable {
    let eventType: String
    let color: String
}
