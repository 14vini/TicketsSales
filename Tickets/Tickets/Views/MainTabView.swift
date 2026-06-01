//
//  MainTabView.swift
//  Tickets
//
//  Created by Kaua on 31/05/26.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var eventVM = EventListViewModel()
    @StateObject private var salesVM = SalesViewModel()

    var body: some View {
        TabView {
            EventsView(viewModel: eventVM)
                .tabItem {
                    Label("Eventos", systemImage: "ticket")
                }

            SalesView(viewModel: salesVM, eventViewModel: eventVM)
                .tabItem {
                    Label("Vendas", systemImage: "chart.bar.doc.horizontal")
                }
        }
        .onAppear {
            eventVM.loadEvents()
            salesVM.loadOrders()
        }
    }
}
