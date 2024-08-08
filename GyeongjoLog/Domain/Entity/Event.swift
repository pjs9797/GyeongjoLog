import Foundation

struct Event: Equatable {
    let id: String
    let name: String
    let phoneNumber: String
    let eventType: String
    let date: Date
    let relationship: String
    let amount: Double
    let memo: String?
}

struct MyEvent: Equatable {
    let eventType: String
    let date: Date
    let eventCnt: Int
    let idList: [String]
}

struct EventSummary: Equatable {
    let id: String
    let eventType: String
    let name: String
    let date: Date
    let amount: Double
}

struct EventKey: Hashable {
    let eventType: String
    let date: Date

    func hash(into hasher: inout Hasher) {
        hasher.combine(eventType)
        hasher.combine(date)
    }

    static func == (lhs: EventKey, rhs: EventKey) -> Bool {
        return lhs.eventType == rhs.eventType && lhs.date == rhs.date
    }
}
