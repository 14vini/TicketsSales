//
//  TicketCardStyle.swift
//  Tickets
//
//  Created by Kaua on 31/05/26.
//

import SwiftUI

enum TicketCardStyle: CaseIterable {
    case rouge
    case blue
    case ivory
    case emerald

    var background: LinearGradient {
        switch self {
        case .rouge:
            return LinearGradient(
                colors: [Color(red: 0.73, green: 0.19, blue: 0.20), Color(red: 0.84, green: 0.38, blue: 0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .blue:
            return LinearGradient(
                colors: [Color(red: 0.14, green: 0.48, blue: 0.82), Color(red: 0.79, green: 0.87, blue: 0.95)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .ivory:
            return LinearGradient(
                colors: [Color(red: 0.96, green: 0.93, blue: 0.89), Color(red: 0.86, green: 0.88, blue: 0.93)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .emerald:
            return LinearGradient(
                colors: [Color(red: 0.14, green: 0.49, blue: 0.38), Color(red: 0.55, green: 0.76, blue: 0.51)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    var poster: LinearGradient {
        switch self {
        case .rouge:
            return LinearGradient(
                colors: [Color(red: 0.49, green: 0.12, blue: 0.10), Color(red: 0.88, green: 0.55, blue: 0.21)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .blue:
            return LinearGradient(
                colors: [Color(red: 0.12, green: 0.37, blue: 0.78), Color(red: 0.94, green: 0.96, blue: 0.99)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .ivory:
            return LinearGradient(
                colors: [Color(red: 0.83, green: 0.87, blue: 0.95), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
        case .emerald:
            return LinearGradient(
                colors: [Color(red: 0.10, green: 0.36, blue: 0.28), Color(red: 0.22, green: 0.59, blue: 0.42)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    var foreground: Color {
        switch self {
        case .blue, .ivory:
            return .black
        case .rouge, .emerald:
            return .white
        }
    }

    var posterTextColor: Color {
        switch self {
        case .ivory:
            return .black.opacity(0.7)
        default:
            return .white.opacity(0.92)
        }
    }

    var metricBackgroundOpacity: Double {
        switch self {
        case .ivory, .blue:
            return 0.22
        case .rouge, .emerald:
            return 0.10
        }
    }
}
