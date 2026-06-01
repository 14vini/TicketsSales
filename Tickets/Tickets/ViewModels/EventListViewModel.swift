import Foundation
import Combine

final class EventListViewModel: ObservableObject {
    @Published var events: [EventResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiService = ApiService.shared

    func loadEvents() {
        isLoading = true
        errorMessage = nil

        apiService.fetchEvents { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false

                switch result {
                case .success(let events):
                    self.events = events
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func addNewEvent(name: String, date: Date, capacity: Int) {
        let request = CreateEventRequest(name: name, eventDate: date, maxCapacity: capacity)

        apiService.createEvent(request: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success:
                    self.loadEvents()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
