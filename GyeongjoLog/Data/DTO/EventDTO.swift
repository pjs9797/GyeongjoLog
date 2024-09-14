struct EventsResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: [EventDTO]
    
    static func toEvents(dto: EventsResponseDTO) -> [Event] {
        return dto.data.map { eventDTO in
            return Event(
                id: eventDTO.id,
                name: eventDTO.name,
                phoneNumber: eventDTO.phoneNumber,
                eventType: eventDTO.eventType,
                date: eventDTO.date,
                relationship: eventDTO.relationship,
                amount: eventDTO.amount,
                memo: eventDTO.memo
            )
        }
    }
}

struct EventResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: EventDTO
    
    static func toEvent(dto: EventResponseDTO) -> Event {
        let data = dto.data
        return Event(id: data.id, name: data.name, phoneNumber: data.phoneNumber, eventType: data.eventType, date: data.date, relationship: data.relationship, amount: data.amount, memo: data.memo)
    }
}

struct EventDTO: Codable {
    let id: String
    let name: String
    let phoneNumber: String
    let eventType: String
    let date: String
    let relationship: String
    let amount: Int
    let memo: String?
}
