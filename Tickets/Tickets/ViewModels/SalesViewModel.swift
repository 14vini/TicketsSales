//
//  SalesViewModel.swift
//  Tickets
//
//  Created by Kaua on 31/05/26.
//

import Foundation
import Combine

class SalesViewModel: ObservableObject {
    @Published var orders: [OrderResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = ApiService.shared
    
    // Busca todas as ordens registradas no banco
    func loadOrders() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchOrders { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedOrders):
                    self.orders = fetchedOrders
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Cria uma nova intenção de compra
    func checkoutTicket(eventId: UUID, customerName: String, quantity: Int) {
        let request = CreateOrderRequest(eventId: eventId, customerName: customerName, ticketQuantity: quantity)
        
        apiService.createOrder(request: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.loadOrders() // Recarrega a lista para mostrar a nova ordem pendente
                case .failure(let error):
                    self.errorMessage = "Erro ao fechar pedido: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Aciona a rota que muda o status no banco de dados para Approved
    func approveTicketPayment(orderId: UUID) {
        apiService.approveOrder(id: orderId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Atualiza a lista local para refletir o status aprovado na tela
                    self.loadOrders()
                case .failure(let error):
                    self.errorMessage = "Erro ao aprovar pagamento: \(error.localizedDescription)"
                }
            }
        }
    }
}
