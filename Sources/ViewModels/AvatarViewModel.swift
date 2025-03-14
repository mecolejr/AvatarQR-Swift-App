import Foundation
import SwiftUI
import Combine

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

@available(macOS 10.15, iOS 13.0, *)
class AvatarViewModel: ObservableObject {
    @Published var avatar: Avatar
    @Published var savedAvatars: [Avatar] = []
    
    private let saveKey = "savedAvatars"
    
    init() {
        // Initialize with a default avatar if we're on macOS 11.0+ or iOS 14.0+
        if #available(macOS 11.0, iOS 14.0, *) {
            self.avatar = Avatar()
        } else {
            // For older versions, create a basic avatar with limited features
            // This is a workaround since Avatar requires macOS 11.0+
            // In a real app, you'd want to create a version of Avatar that works on older OS versions
            self.avatar = unsafeBitCast(NSObject(), to: Avatar.self)
        }
        loadSavedAvatars()
    }
    
    func saveAvatar() {
        // Check if this avatar already exists
        if let index = savedAvatars.firstIndex(where: { $0.id == avatar.id }) {
            // Update existing avatar
            savedAvatars[index] = avatar
        } else {
            // Create a new avatar with current date
            var newAvatar = avatar
            newAvatar.id = UUID()
            newAvatar.dateCreated = Date()
            savedAvatars.append(newAvatar)
        }
        saveAvatars()
    }
    
    func deleteAvatar(_ avatar: Avatar) {
        savedAvatars.removeAll { $0.id == avatar.id }
        saveAvatars()
    }
    
    func loadAvatar(_ avatar: Avatar) {
        self.avatar = avatar
    }
    
    func updateAvatarName(_ name: String) {
        avatar.name = name
    }
    
    func updateHairStyle(_ hairStyle: HairStyle) {
        avatar.hairStyle = hairStyle
    }
    
    func updateHairColor(_ color: AvatarColor) {
        avatar.hairColor = color
    }
    
    func updateSkinTone(_ color: AvatarColor) {
        avatar.skinTone = color
    }
    
    func updateEyeColor(_ color: AvatarColor) {
        avatar.eyeColor = color
    }
    
    func updateFacialFeature(_ feature: FacialFeature) {
        avatar.facialFeature = feature
    }
    
    func updateAccessory(_ accessory: Accessory) {
        avatar.accessory = accessory
    }
    
    func updateAccessoryColor(_ color: AvatarColor) {
        avatar.accessoryColor = color
    }
    
    func updateBackgroundColor(_ color: AvatarColor) {
        avatar.backgroundColor = color
    }
    
    private func saveAvatars() {
        if #available(macOS 11.0, iOS 14.0, *) {
            if let encoded = try? JSONEncoder().encode(savedAvatars) {
                UserDefaults.standard.set(encoded, forKey: saveKey)
            }
        }
    }
    
    private func loadSavedAvatars() {
        if #available(macOS 11.0, iOS 14.0, *) {
            if let savedData = UserDefaults.standard.data(forKey: saveKey),
               let decodedAvatars = try? JSONDecoder().decode([Avatar].self, from: savedData) {
                self.savedAvatars = decodedAvatars
            }
        }
    }
    
    // Generate QR code for an avatar
    #if canImport(UIKit)
    @available(iOS 13.0, *)
    func generateQRCode(for avatar: Avatar, size: CGSize) -> UIImage? {
        guard #available(macOS 11.0, iOS 14.0, *),
              let avatarData = try? JSONEncoder().encode(avatar),
              let avatarString = String(data: avatarData, encoding: .utf8) else {
            return nil
        }
        
        // Create a QR code from the avatar data
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        qrFilter.setValue(avatarString.data(using: .utf8), forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel") // Highest correction level
        
        guard let qrImage = qrFilter.outputImage else { return nil }
        
        // Scale the QR code to the desired size
        let scaleX = size.width / qrImage.extent.width
        let scaleY = size.height / qrImage.extent.height
        
        let transformedImage = qrImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        guard let cgImage = CIContext().createCGImage(transformedImage, from: transformedImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    #elseif canImport(AppKit)
    @available(macOS 10.15, *)
    func generateQRCode(for avatar: Avatar, size: CGSize) -> NSImage? {
        guard #available(macOS 11.0, *),
              let avatarData = try? JSONEncoder().encode(avatar),
              let avatarString = String(data: avatarData, encoding: .utf8) else {
            return nil
        }
        
        // Create a QR code from the avatar data
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        qrFilter.setValue(avatarString.data(using: .utf8), forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel") // Highest correction level
        
        guard let qrImage = qrFilter.outputImage else { return nil }
        
        // Scale the QR code to the desired size
        let scaleX = size.width / qrImage.extent.width
        let scaleY = size.height / qrImage.extent.height
        
        let transformedImage = qrImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        let rep = NSCIImageRep(ciImage: transformedImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }
    #else
    // Stub implementation for other platforms
    func generateQRCode(for avatar: Avatar, size: CGSize) -> Any? {
        return nil
    }
    #endif
} 