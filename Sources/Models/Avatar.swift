import SwiftUI
import Foundation

@available(macOS 11.0, iOS 14.0, *)
struct Avatar: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String = "My Avatar"
    var hairStyle: HairStyle = .short
    var hairColor: AvatarColor = .black
    var skinTone: AvatarColor = .tan
    var eyeColor: AvatarColor = .blue
    var facialFeature: FacialFeature = .smile
    var accessory: Accessory = .none
    var accessoryColor: AvatarColor = .red
    var glasses: Glasses = .none
    var glassesColor: AvatarColor = .black
    var clothing: Clothing = .tshirt
    var clothingColor: AvatarColor = .blue
    var backgroundColor: AvatarColor = .lightBlue
    var dateCreated: Date = Date()
    
    static func == (lhs: Avatar, rhs: Avatar) -> Bool {
        return lhs.id == rhs.id
    }
}

@available(macOS 11.0, iOS 14.0, *)
enum HairStyle: String, CaseIterable, Codable {
    case bald = "person.fill"
    case short = "person.crop.circle"
    case long = "person.crop.rectangle"
    case curly = "person.crop.square"
    case mohawk = "person.crop.circle.badge.plus"
    case ponytail = "person.crop.circle.badge.checkmark"
    
    var displayName: String {
        switch self {
        case .bald: return "Bald"
        case .short: return "Short"
        case .long: return "Long"
        case .curly: return "Curly"
        case .mohawk: return "Mohawk"
        case .ponytail: return "Ponytail"
        }
    }
}

@available(macOS 11.0, iOS 14.0, *)
enum FacialFeature: String, CaseIterable, Codable {
    case none = "none"
    case smile = "face.smiling"
    case serious = "face.dashed"
    case beard = "mustache"
    case mustache = "mustache.fill"
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .smile: return "Smile"
        case .serious: return "Serious"
        case .beard: return "Beard"
        case .mustache: return "Mustache"
        }
    }
    
    var systemImageName: String? {
        return self == .none ? nil : self.rawValue
    }
}

@available(macOS 11.0, iOS 14.0, *)
enum Glasses: String, CaseIterable, Codable {
    case none = "none"
    case regular = "eyeglasses"
    case sunglasses = "sunglasses"
    case roundGlasses = "circle"
    case squareGlasses = "square"
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .regular: return "Regular"
        case .sunglasses: return "Sunglasses"
        case .roundGlasses: return "Round"
        case .squareGlasses: return "Square"
        }
    }
    
    var systemImageName: String? {
        return self == .none ? nil : self.rawValue
    }
}

@available(macOS 11.0, iOS 14.0, *)
enum Clothing: String, CaseIterable, Codable {
    case none = "none"
    case tshirt = "tshirt"
    case suit = "person.crop.square.fill.and.at.rectangle"
    case dress = "person.crop.artframe"
    case hoodie = "person.crop.rectangle.stack"
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .tshirt: return "T-Shirt"
        case .suit: return "Suit"
        case .dress: return "Dress"
        case .hoodie: return "Hoodie"
        }
    }
    
    var systemImageName: String? {
        return self == .none ? nil : self.rawValue
    }
}

@available(macOS 11.0, iOS 14.0, *)
enum Accessory: String, CaseIterable, Codable {
    case none = "none"
    case hat = "rectangle.fill"
    case bowtie = "rectangle.on.rectangle"
    case necklace = "circle.fill"
    case crown = "crown"
    case headphones = "headphones"
    case scarf = "scribble"
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .hat: return "Hat"
        case .bowtie: return "Bowtie"
        case .necklace: return "Necklace"
        case .crown: return "Crown"
        case .headphones: return "Headphones"
        case .scarf: return "Scarf"
        }
    }
    
    var systemImageName: String? {
        return self == .none ? nil : self.rawValue
    }
}

@available(macOS 10.15, iOS 13.0, *)
enum AvatarColor: String, CaseIterable, Codable {
    case red, blue, green, yellow, purple, orange, pink, brown, black, white, gray, tan, lightBlue, teal, navy, maroon, lime, coral
    
    var color: Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .yellow: return .yellow
        case .purple: return .purple
        case .orange: return .orange
        case .pink: return .pink
        case .brown: 
            if #available(macOS 12.0, iOS 15.0, *) {
                return .brown
            } else {
                return Color(red: 0.6, green: 0.4, blue: 0.2)
            }
        case .black: return .black
        case .white: return .white
        case .gray: return .gray
        case .tan: return Color(red: 0.9, green: 0.8, blue: 0.6)
        case .lightBlue: return Color(red: 0.7, green: 0.9, blue: 1.0)
        case .teal: return Color(red: 0.0, green: 0.5, blue: 0.5)
        case .navy: return Color(red: 0.0, green: 0.0, blue: 0.5)
        case .maroon: return Color(red: 0.5, green: 0.0, blue: 0.0)
        case .lime: return Color(red: 0.5, green: 1.0, blue: 0.0)
        case .coral: return Color(red: 1.0, green: 0.5, blue: 0.3)
        }
    }
    
    var displayName: String {
        switch self {
        case .lightBlue: return "Light Blue"
        default: return rawValue.capitalized
        }
    }
} 