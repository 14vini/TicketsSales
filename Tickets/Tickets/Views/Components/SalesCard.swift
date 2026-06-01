//
//  SalesCard.swift
//  Tickets
//
//  Created by Kaua on 31/05/26.
//

import SwiftUI

struct SalesCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let order: OrderResponse
    let onApprove: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(order.customerName)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(primaryTextColor)

                    Text("\(order.ticketQuantity) ingresso\(order.ticketQuantity > 1 ? "s" : "")")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(secondaryTextColor)
                }

                Spacer()

                if order.status == .pending {
                    Button("Aprovar", action: onApprove)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.black))
                } else {
                    Text(order.status.rawValue)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.green.opacity(0.12)))
                }
            }

            HStack {
                Label(order.eventId.uuidString.prefix(6), systemImage: "ticket.fill")
                Spacer()
                Label("Pedido ativo", systemImage: "waveform.path.ecg")
            }
            .font(.system(size: 13, weight: .medium, design: .rounded))
            .foregroundColor(secondaryTextColor)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(cardBackgroundColor)
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.24 : 0.06), radius: 20, y: 8)
        )
    }

    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : .white
    }

    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black
    }

    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.62) : Color.black.opacity(0.52)
    }
}
