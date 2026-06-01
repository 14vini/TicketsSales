//
//  EventTicketCard.swift
//  Tickets
//
//  Created by Kaua on 31/05/26.
//

import SwiftUI

struct EventTicketCard: View {
    let event: EventResponse
    let style: TicketCardStyle

    private let metricColumns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.name)
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .lineLimit(2)
                        .minimumScaleFactor(0.78)
                        .foregroundColor(style.foreground)

                    if let subtitle = eventSubtitle {
                        Text(subtitle)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .lineLimit(2)
                            .foregroundColor(style.foreground.opacity(0.72))
                    }
                }

                Spacer(minLength: 8)

                if isAlmostSoldOut {
                    Text("Almost sold out")
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .foregroundColor(style.posterTextColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(style.metricBackgroundOpacity + 0.06))
                        )
                }
            }

            Divider().overlay(style.foreground.opacity(0.18))

            LazyVGrid(columns: metricColumns, spacing: 7) {
                ticketMetric("Date", value: event.eventDate.formatted(date: .abbreviated, time: .omitted))
                ticketMetric("Cap.", value: event.maxCapacity.formatted())
                ticketMetric("Sold", value: ticketsSoldText)
                ticketMetric("Left", value: remainingTicketsText)
            }

            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(style.poster)
                    .frame(height: 72)

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(eventStatus.uppercased())
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(style.posterTextColor)

                        Text(footerSummary)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                            .foregroundColor(style.posterTextColor.opacity(0.8))
                    }

                    Spacer()

                    Image(systemName: "ticket.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(style.posterTextColor.opacity(0.88))
                }
                .padding(12)
            }

            Text(event.id.uuidString.uppercased())
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundColor(style.foreground.opacity(0.42))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(style.background)
                .shadow(color: .black.opacity(0.14), radius: 14, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    private func ticketMetric(_ title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .tracking(0.4)
                .foregroundColor(style.foreground.opacity(0.55))

            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundColor(style.foreground)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 9)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(style.metricBackgroundOpacity))
        )
    }

    private var eventSubtitle: String? {
        if isAlmostSoldOut {
            return "This event is almost sold out"
        }

        if eventStatus == "Past" {
            return "This event date has already passed"
        }

        return nil
    }

    private var eventStatus: String {
        event.eventDate < .now ? "Past" : "Upcoming"
    }

    private var soldTickets: Int? {
        event.ticketsSold
    }

    private var remainingTickets: Int? {
        guard let soldTickets else { return nil }
        return max(event.maxCapacity - soldTickets, 0)
    }

    private var isAlmostSoldOut: Bool {
        guard let remainingTickets else { return false }
        guard event.maxCapacity > 0 else { return false }

        let threshold = Double(event.maxCapacity) * 0.10
        return Double(remainingTickets) <= threshold
    }

    private var ticketsSoldText: String {
        soldTickets?.formatted() ?? "--"
    }

    private var remainingTicketsText: String {
        remainingTickets?.formatted() ?? "--"
    }

    private var footerSummary: String {
        if let remainingTickets {
            if remainingTickets == 1 {
                return "1 ticket left"
            }

            return "\(remainingTickets.formatted()) tickets left"
        }

        return event.eventDate.formatted(date: .long, time: .omitted)
    }
}
