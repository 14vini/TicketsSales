//
//  TicketModel.swift
//  Tickets
//
//  Created by Kaua on 31/05/26.
//

import Foundation

// MARK: - Enums
// Enums sem valores associados já são implicitamente Sendable, mas é bom deixar explícito
nonisolated enum OrderStatus: String, Codable, Sendable {
    case pending = "Pending"
    case approved = "Approved"
    case canceled = "Canceled"
}

// MARK: - Event Models
// Adicione ", Sendable" aqui
nonisolated struct EventResponse: Codable, Identifiable, Sendable {
    let id: UUID
    let name: String
    let eventDate: Date
    let maxCapacity: Int
    let ticketsSold: Int?
}

nonisolated struct CreateEventRequest: Encodable, Sendable {
    let name: String
    let eventDate: Date
    let maxCapacity: Int
}

// MARK: - Sales Models
// Adicione ", Sendable" aqui
nonisolated struct OrderResponse: Codable, Identifiable, Sendable {
    let id: UUID
    let eventId: UUID
    let customerName: String
    let ticketQuantity: Int
    let status: OrderStatus
}

nonisolated struct CreateOrderRequest: Encodable, Sendable {
    let eventId: UUID
    let customerName: String
    let ticketQuantity: Int
}
