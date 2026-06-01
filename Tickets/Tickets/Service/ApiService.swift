//
//  ApiService.swift
//  Tickets
//
//  Created by Kaua on 31/05/26.
//

import Foundation
import Alamofire

final class ApiService {
    static let shared = ApiService()
    private let baseURL = {
        #if targetEnvironment(simulator)
        return "http://localhost:5055/api"
        #else
        return "http://192.168.3.95:5055/api"
        #endif
    }()
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()

        let formatterWithFractionalSeconds = ISO8601DateFormatter()
        formatterWithFractionalSeconds.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let formatterWithoutFractionalSeconds = ISO8601DateFormatter()
        formatterWithoutFractionalSeconds.formatOptions = [.withInternetDateTime]

        let dotNetFormatterWithFractionalSeconds = DateFormatter()
        dotNetFormatterWithFractionalSeconds.locale = Locale(identifier: "en_US_POSIX")
        dotNetFormatterWithFractionalSeconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"

        let dotNetFormatterWithoutFractionalSeconds = DateFormatter()
        dotNetFormatterWithoutFractionalSeconds.locale = Locale(identifier: "en_US_POSIX")
        dotNetFormatterWithoutFractionalSeconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)

            if let date =
                formatterWithFractionalSeconds.date(from: value) ??
                formatterWithoutFractionalSeconds.date(from: value) ??
                dotNetFormatterWithFractionalSeconds.date(from: value) ??
                dotNetFormatterWithoutFractionalSeconds.date(from: value)
            {
                return date
            }

            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Data invalida: \(value)")
        }
        return decoder
    }()
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    private init() {}
    
    func fetchEvents(completion: @escaping (Result<[EventResponse], Error>) -> Void) {
        AF.request("\(baseURL)/events", method: .get)
            .validate()
            .responseData { [jsonDecoder] response in
                let statusCode = response.response?.statusCode ?? -1
                print("[ApiService] GET /events status:", statusCode)

                if let data = response.data, let rawBody = String(data: data, encoding: .utf8) {
                    print("[ApiService] GET /events raw body:", rawBody)
                }

                if let error = response.error {
                    print("[ApiService] GET /events request error:", error)
                    completion(.failure(error))
                    return
                }

                guard let data = response.data else {
                    completion(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                    return
                }

                do {
                    let events = try jsonDecoder.decode([EventResponse].self, from: data)
                    print("[ApiService] GET /events decoded count:", events.count)
                    completion(.success(events))
                } catch {
                    print("[ApiService] GET /events decode error:", error)
                    completion(.failure(error))
                }
            }
    }
    
    func createEvent(request: CreateEventRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        AF.request(
            "\(baseURL)/events",
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder(encoder: jsonEncoder)
        )
        .validate()
        .response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchOrders(completion: @escaping (Result<[OrderResponse], Error>) -> Void) {
        AF.request("\(baseURL)/sales", method: .get)
            .validate()
            .responseDecodable(of: [OrderResponse].self, decoder: jsonDecoder) { response in
                switch response.result {
                case .success(let orders):
                    completion(.success(orders))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func createOrder(request: CreateOrderRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        AF.request(
            "\(baseURL)/sales",
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder(encoder: jsonEncoder)
        )
        .validate()
        .response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func approveOrder(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        AF.request("\(baseURL)/sales/\(id.uuidString.lowercased())/approve", method: .post)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
