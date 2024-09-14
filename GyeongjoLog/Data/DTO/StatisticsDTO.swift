struct IndividualStatisticsResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: [IndividualStatisticsDTO]
    
    static func toIndividualStatistics(dto: IndividualStatisticsResponseDTO) -> [IndividualStatistics] {
        return dto.data.map { statisticsDTO in
            return IndividualStatistics(
                name: statisticsDTO.name,
                phoneNumber: statisticsDTO.phoneNumber,
                relationship: statisticsDTO.relationship,
                totalInteractions: statisticsDTO.totalInteractions,
                totalAmount: statisticsDTO.totalAmount,
                totalReceivedAmount: statisticsDTO.totalReceivedAmount,
                totalSentAmount: statisticsDTO.totalSentAmount,
                eventDetails: statisticsDTO.eventDetails.map { eventDetailDTO in
                    EventDetail(
                        name: eventDetailDTO.name,
                        date: eventDetailDTO.date,
                        eventType: eventDetailDTO.eventType,
                        amount: eventDetailDTO.amount
                    )
                }
            )
        }
    }
}

struct IndividualStatisticsDTO: Codable {
    let name: String;
    let phoneNumber: String
    let relationship: String
    let totalInteractions: Int
    let totalAmount: Int
    let totalReceivedAmount: Int
    let totalSentAmount: Int
    let eventDetails: [EventDetailDTO]
}

struct EventDetailDTO: Codable {
    let name: String
    let date: String
    let eventType: String
    let amount: Int
}

struct MonthlyStatisticsReponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: [MonthlyStatisticsDTO]
    
    static func toMonthlyStatistics(dto: MonthlyStatisticsReponseDTO) -> [MonthlyStatistics] {
        return dto.data.map { statisticsDTO in
            return MonthlyStatistics(
                month: statisticsDTO.month,
                sentAmount: statisticsDTO.sentAmount,
                receivedAmount: statisticsDTO.receivedAmount,
                transactionCount: statisticsDTO.transactionCount,
                eventTypeAmounts: statisticsDTO.eventTypeAmounts
            )
        }
    }
}

struct MonthlyStatisticsDTO: Codable {
    let month: String
    let sentAmount: Int
    let receivedAmount: Int
    let transactionCount: Int
    let eventTypeAmounts: [String: Int]
}
