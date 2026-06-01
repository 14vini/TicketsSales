//
//  EventsView.swift
//  Tickets
//
//  Created by Kaua on 31/05/26.
//

import SwiftUI

struct EventsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: EventListViewModel
    @State private var showAddSheet = false
    @State private var eventName = ""
    @State private var eventDate = Date()
    @State private var capacity = 100

    var body: some View {
        NavigationView {
            ZStack {
                eventsBackground.ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView("Buscando eventos...")
                        .tint(primaryTextColor)
                        .foregroundColor(primaryTextColor)
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Erro ao carregar eventos",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage)
                    )
                    .foregroundStyle(primaryTextColor, secondaryTextColor)
                } else if viewModel.events.isEmpty {
                    ContentUnavailableView(
                        "Nenhum Evento",
                        systemImage: "ticket.slash",
                        description: Text("Toque no botao + para criar o primeiro evento.")
                    )
                    .foregroundStyle(primaryTextColor, secondaryTextColor)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 26) {
                            heroSection

                            VStack(spacing: 16) {
                                ForEach(Array(viewModel.events.enumerated()), id: \.element.id) { index, event in
                                    EventTicketCard(
                                        event: event,
                                        style: TicketCardStyle.allCases[index % TicketCardStyle.allCases.count]
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 22)
                        .padding(.top, 12)
                        .padding(.bottom, 28)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddSheet = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(primaryTextColor)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                NavigationView {
                    Form {
                        Section("Detalhes do Evento") {
                            TextField("Nome do Evento", text: $eventName)
                            DatePicker("Data", selection: $eventDate, in: Date()...)
                            Stepper("Capacidade: \(capacity)", value: $capacity, in: 10...10000)
                        }
                    }
                    .navigationTitle("Novo Evento")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancelar") { showAddSheet = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Salvar") {
                                viewModel.addNewEvent(name: eventName, date: eventDate, capacity: capacity)
                                eventName = ""
                                showAddSheet = false
                            }
                            .disabled(eventName.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                    }
                }
            }
        }
    }

    private var heroSection: some View {
        HStack(spacing: 4) {
            Text("\(viewModel.events.count)")
            Text("Tickets")
                
        }
        .font(.system(size: 54, weight: .black, design: .rounded))
        .italic()
        .foregroundColor(primaryTextColor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var eventsBackground: some View {
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
        colorScheme == .dark ? .gray : Color.black.opacity(0.55)
    }
}
