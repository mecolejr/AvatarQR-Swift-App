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
    
    var displayName: String {
        switch self {
        case .bald: return "Bald"
        case .short: return "Short"
        case .long: return "Long"
        case .curly: return "Curly"
        }
    }
}

@available(macOS 11.0, iOS 14.0, *)
enum FacialFeature: String, CaseIterable, Codable {
    case none = "none"
    case smile = "face.smiling"
    case serious = "face.dashed"
    case glasses = "eyeglasses"
    case sunglasses = "sunglasses"
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .smile: return "Smile"
        case .serious: return "Serious"
        case .glasses: return "Glasses"
        case .sunglasses: return "Sunglasses"
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
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .hat: return "Hat"
        case .bowtie: return "Bowtie"
        case .necklace: return "Necklace"
        }
    }
    
    var systemImageName: String? {
        return self == .none ? nil : self.rawValue
    }
}

@available(macOS 10.15, iOS 13.0, *)
enum AvatarColor: String, CaseIterable, Codable {
    case red, blue, green, yellow, purple, orange, pink, brown, black, white, gray, tan, lightBlue
    
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
        }
    }
    
    var displayName: String {
        switch self {
        case .lightBlue: return "Light Blue"
        default: return rawValue.capitalized
        }
    }
} 