//
//  SDUIComponentWrapper.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 24/02/26.
//
import Foundation

// 1. The Protocol all server components must conform to
protocol ServerComponent: Decodable {
    var id: UUID { get }
}

// 2. Concrete Models
struct HeroCardModel: ServerComponent {
    let id = UUID()
    let title: String
    let amount: String
    let actionID: String?
}

struct TransactionRowModel: ServerComponent {
    let id = UUID()
    let merchant: String
    let date: String
    let amount: String
}

struct UnknownModel: ServerComponent {
    let id = UUID()
}

// 3. The Wrapper (The Polymorphic Container)
// This is the magic struct that handles the "type" switching during decoding.
struct SDUIComponentWrapper: Decodable, Identifiable {
    let id = UUID()
    let component: any ServerComponent // Holds the type-erased model

    enum CodingKeys: String, CodingKey {
        case type, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        // Polymorphic Decoding Strategy
        // If we see a new type we don't know, we fallback to UnknownModel
        // instead of crashing the app. This is crucial for backward compatibility.
        switch type {
        case "hero_card":
            self.component = try container.decode(HeroCardModel.self, forKey: .data)
        case "transaction_row":
            self.component = try container.decode(TransactionRowModel.self, forKey: .data)
        default:
            // "Graceful Degradation"
            self.component = UnknownModel()
        }
    }
}

// 4. The Response Container
struct ScreenResponse: Decodable {
    let screenTitle: String
    let components: [SDUIComponentWrapper]
    
}

