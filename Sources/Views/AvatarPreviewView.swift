import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
struct AvatarPreviewView: View {
    let avatar: Avatar
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Background
            Circle()
                .fill(avatar.backgroundColor.color)
                .frame(width: size, height: size)
            
            // Base
            Circle()
                .fill(avatar.skinTone.color)
                .frame(width: size * 0.8, height: size * 0.8)
            
            // Hair
            if avatar.hairStyle != .bald {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(avatar.hairColor.color)
                        .frame(width: size * 0.5, height: size * 0.5)
                        .offset(y: -size * 0.1)
                } else {
                    // Fallback for older versions
                    Circle()
                        .fill(avatar.hairColor.color)
                        .frame(width: size * 0.5, height: size * 0.3)
                        .offset(y: -size * 0.25)
                }
            }
            
            // Eyes
            HStack(spacing: size * 0.15) {
                Circle()
                    .fill(avatar.eyeColor.color)
                    .frame(width: size * 0.1, height: size * 0.1)
                
                Circle()
                    .fill(avatar.eyeColor.color)
                    .frame(width: size * 0.1, height: size * 0.1)
            }
            
            // Facial Feature
            if let featureImage = avatar.facialFeature.systemImageName {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Image(systemName: featureImage)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .frame(width: size * 0.3, height: size * 0.3)
                        .offset(y: size * 0.1)
                } else {
                    // Fallback for older versions - simple mouth
                    if avatar.facialFeature == .smile {
                        Capsule()
                            .fill(Color.black)
                            .frame(width: size * 0.3, height: size * 0.05)
                            .offset(y: size * 0.1)
                    } else if avatar.facialFeature == .glasses || avatar.facialFeature == .sunglasses {
                        ZStack {
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: size * 0.15, height: size * 0.15)
                                .offset(x: -size * 0.1)
                            
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: size * 0.15, height: size * 0.15)
                                .offset(x: size * 0.1)
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: size * 0.05, height: 2)
                        }
                        .offset(y: -size * 0.05)
                    }
                }
            }
            
            // Accessory
            if let accessoryImage = avatar.accessory.systemImageName {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Image(systemName: accessoryImage)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(avatar.accessoryColor.color)
                        .frame(width: size * 0.4, height: size * 0.4)
                        .offset(y: size * 0.25)
                } else {
                    // Fallback for older versions
                    if avatar.accessory == .hat {
                        Rectangle()
                            .fill(avatar.accessoryColor.color)
                            .frame(width: size * 0.6, height: size * 0.2)
                            .offset(y: -size * 0.35)
                    } else if avatar.accessory == .necklace {
                        Circle()
                            .stroke(avatar.accessoryColor.color, lineWidth: 3)
                            .frame(width: size * 0.3, height: size * 0.3)
                            .offset(y: size * 0.25)
                    }
                }
            }
        }
    }
} 