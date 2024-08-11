import Foundation

struct Event: Equatable {
    let id: String
    let name: String
    let phoneNumber: String
    let eventType: String
    let date: String
    let relationship: String
    let amount: Double
    let memo: String?
}

struct MyEvent: Equatable {
    let eventType: String
    let date: String
    let eventCnt: Int
    let idList: [String]
}

struct EventSummary: Equatable {
    let id: String
    let eventType: String
    let name: String
    let date: String
    let amount: Double
}

struct EventKey: Hashable {
    let eventType: String
    let date: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(eventType)
        hasher.combine(date)
    }

    static func == (lhs: EventKey, rhs: EventKey) -> Bool {
        return lhs.eventType == rhs.eventType && lhs.date == rhs.date
    }
}

struct EventType: Equatable {
    let name: String
    let color: String
}
