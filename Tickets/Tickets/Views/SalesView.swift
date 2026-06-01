//
//  SalesView.swift
//  Tickets
//
//  Created by Kaua on 31/05/26.
//

import SwiftUI

struct SalesView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: SalesViewModel
    @ObservedObject var eventViewModel: EventListViewModel
    @State private var showBuySheet = false
    @State private var selectedEventId: UUID?
    @State private var customerName = ""
    @State private var quantity = 1

    var body: some View {
        NavigationView {
            ZStack {
                sharedBackground.ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView("Carregando vendas...")
                } else if viewModel.orders.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma Venda",
                        systemImage: "cart.badge.minus",
                        description: Text("As compras aprovadas e pendentes vao aparecer aqui.")
                    )
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 18) {
                            Text("Sales")
                                .font(.system(size: 44, weight: .black, design: .rounded))
                                .foregroundColor(primaryTextColor)

                            Text("Painel rapido para aprovar pedidos e acompanhar reservas.")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundColor(secondaryTextColor)

                            ForEach(viewModel.orders) { order in
                                SalesCard(order: order) {
                                    viewModel.approveTicketPayment(orderId: order.id)
                                }
                            }
                        }
                        .padding(22)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if let firstEvent = eventViewModel.events.first {
                            selectedEventId = firstEvent.id
                        }
                        showBuySheet = true
                    }) {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .disabled(eventViewModel.events.isEmpty)
                }
            }
            .sheet(isPresented: $showBuySheet) {
                NavigationView {
                    Form {
                        Section("Comprador") {
                            TextField("Nome do Cliente", text: $customerName)
                            Stepper("Quantidade: \(quantity)", value: $quantity, in: 1...10)
                        }

                        Section("Selecione o Evento") {
                            Picker("Evento", selection: $selectedEventId) {
                                ForEach(eventViewModel.events) { event in
                                    Text(event.name).tag(Optional(event.id))
                                }
                            }
                        }
                    }
                    .navigationTitle("Nova Compra")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancelar") { showBuySheet = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Finalizar") {
                                if let eventId = selectedEventId {
                                    viewModel.checkoutTicket(
                                        eventId: eventId,
                                        customerName: customerName,
                                        quantity: quantity
                                    )
                                    customerName = ""
                                    quantity = 1
                                    showBuySheet = false
                                }
                            }
                            .disabled(customerName.trimmingCharacters(in: .whitespaces).isEmpty || selectedEventId == nil)
                        }
                    }
                }
            }
        }
    }

    private var sharedBackground: some View {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color.black, Color(red: 0.08, green: 0.08, blue: 0.10)]
                : [Color(red: 0.97, green: 0.98, blue: 1.0), Color.white],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black
    }

    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.55)
    }
}
