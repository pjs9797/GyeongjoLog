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

struct MonthlyStatistics: Equatable {
    let month: String
    var sentAmount: Int
    var receivedAmount: Int
    var transactionCount: Int
    var eventTypeAmounts: [String: Int]
}

struct PieChartDetail: Equatable {
    let eventType: String
    let percentage: Double
    let amount: Int
}
