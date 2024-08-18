import Foundation

struct IndividualStatistics: Equatable {
    let name: String
    let phoneNumber: String
    let relationship: String
    let totalInteractions: Int
    let totalAmount: Int
    let totalReceivedAmount: Int
    let totalSentAmount: Int
    let eventDetails: [EventDetail]
}

struct EventDetail: Equatable {
    let name: String
    let date: String
    let eventType: String
    let amount: Int
}

struct PersonKey: Hashable {
    let name: String
    let phoneNumber: String
}
