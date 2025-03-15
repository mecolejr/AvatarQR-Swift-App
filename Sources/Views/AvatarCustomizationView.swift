import SwiftUI

@available(macOS 11.0, *)
struct AvatarCustomizationView: View {
    @ObservedObject var viewModel: AvatarViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedCategory: CustomizationCategory = .face
    @State private var showingSaveAlert = false
    @State private var avatarName = ""
    
    enum CustomizationCategory: String, CaseIterable {
        case face = "Face"
        case hair = "Hair"
        case glasses = "Glasses"
        case clothing = "Clothing"
        case accessory = "Accessory"
        case background = "Background"
        case color = "Color"
        
        var systemImageName: String {
            switch self {
            case .face: return "face.smiling"
            case .hair: return "person.crop.circle"
            case .glasses: return "eyeglasses"
            case .clothing: return "tshirt"
            case .accessory: return "crown"
            case .background: return "square.fill"
            case .color: return "paintpalette"
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 15) {
                    // Avatar preview section
                    AvatarPreviewSection(viewModel: viewModel, avatarName: $avatarName, showingSaveAlert: $showingSaveAlert, geometry: geometry)
                    
                    // Category selection
                    CategorySelectionView(selectedCategory: $selectedCategory, colorScheme: colorScheme)
                    
                    // Customization options based on selected category
                    CustomizationContentView(selectedCategory: selectedCategory, viewModel: viewModel, colorScheme: colorScheme)
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            avatarName = viewModel.avatar.name
        }
        .navigationTitle("Customize Avatar")
    }
}

// MARK: - Preview Section
@available(macOS 11.0, *)
struct AvatarPreviewSection: View {
    @ObservedObject var viewModel: AvatarViewModel
    @Binding var avatarName: String
    @Binding var showingSaveAlert: Bool
    let geometry: GeometryProxy
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            // Avatar name field
            HStack {
                Text("Avatar Name:")
                    .font(.headline)
                
                TextField("Enter name", text: $avatarName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: avatarName) { newValue in
                        var updatedAvatar = viewModel.avatar
                        updatedAvatar.name = newValue
                        viewModel.avatar = updatedAvatar
                    }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Avatar preview
            ZStack {
                if viewModel.avatar.backgroundStyle == .gradient {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    viewModel.avatar.gradientStartColor.color,
                                    viewModel.avatar.gradientEndColor.color
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: min(geometry.size.width * 0.5, 200), height: min(geometry.size.width * 0.5, 200))
                } else {
                    Circle()
                        .fill(viewModel.avatar.backgroundColor.color)
                        .frame(width: min(geometry.size.width * 0.5, 200), height: min(geometry.size.width * 0.5, 200))
                }
                
                AvatarPreviewView(avatar: viewModel.avatar, size: min(geometry.size.width * 0.4, 160))
            }
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.vertical, 20)
            
            // Save button
            Button(action: {
                if !avatarName.isEmpty {
                    viewModel.saveAvatar()
                    showingSaveAlert = true
                }
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save Avatar")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            .disabled(avatarName.isEmpty)
            .opacity(avatarName.isEmpty ? 0.6 : 1.0)
            .alert(isPresented: $showingSaveAlert) {
                Alert(
                    title: Text("Avatar Saved"),
                    message: Text("Your avatar has been saved successfully."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding(.bottom, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
        .padding(.horizontal, 15)
        .padding(.top, 15)
    }
}

// MARK: - Category Selection
@available(macOS 11.0, *)
struct CategorySelectionView: View {
    @Binding var selectedCategory: AvatarCustomizationView.CustomizationCategory
    var colorScheme: ColorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(AvatarCustomizationView.CustomizationCategory.allCases, id: \.self) { category in
                    VStack {
                        Image(systemName: category.systemImageName)
                            .font(.system(size: 20))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .frame(width: 50, height: 50)
                            .background(
                                Circle()
                                    .fill(selectedCategory == category ? Color.blue : (colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7)))
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Text(category.rawValue)
                            .font(.caption)
                            .foregroundColor(selectedCategory == category ? .blue : .primary)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
        .padding(.horizontal, 15)
        .padding(.top, 15)
    }
}

// MARK: - Customization Content
@available(macOS 11.0, *)
struct CustomizationContentView: View {
    var selectedCategory: AvatarCustomizationView.CustomizationCategory
    @ObservedObject var viewModel: AvatarViewModel
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            switch selectedCategory {
            case .face:
                FaceCustomizationView(viewModel: viewModel, colorScheme: colorScheme)
            case .hair:
                HairCustomizationView(viewModel: viewModel, colorScheme: colorScheme)
            case .glasses:
                GlassesCustomizationView(viewModel: viewModel, colorScheme: colorScheme)
            case .clothing:
                ClothingCustomizationView(viewModel: viewModel, colorScheme: colorScheme)
            case .accessory:
                AccessoryCustomizationView(viewModel: viewModel, colorScheme: colorScheme)
            case .background:
                BackgroundCustomizationView(viewModel: viewModel, colorScheme: colorScheme)
            case .color:
                ColorCustomizationView(viewModel: viewModel, colorScheme: colorScheme)
            }
        }
        .padding(.bottom, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
        .padding(.horizontal, 15)
        .padding(.top, 15)
    }
}

// MARK: - Hair Customization
@available(macOS 11.0, *)
struct HairCustomizationView: View {
    @ObservedObject var viewModel: AvatarViewModel
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section header with icon
            HStack {
                Image(systemName: "person.crop.circle")
                    .foregroundColor(.blue)
                Text("Hair Style")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Hair style options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(HairStyle.allCases, id: \.self) { style in
                        HairStyleOption(style: style, viewModel: viewModel, colorScheme: colorScheme)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.7))
                    .padding(.horizontal, 10)
            )
            
            // Section header with icon
            HStack {
                Image(systemName: "paintpalette")
                    .foregroundColor(.blue)
                Text("Hair Color")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Hair color options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(AvatarColor.allCases, id: \.self) { color in
                        ColorOption(color: color, 
                                   isSelected: viewModel.avatar.hairColor == color,
                                   action: {
                                       withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                           var updatedAvatar = viewModel.avatar
                                           updatedAvatar.hairColor = color
                                           viewModel.avatar = updatedAvatar
                                       }
                                   })
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.7))
                    .padding(.horizontal, 10)
            )
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Hair Style Option
@available(macOS 11.0, *)
struct HairStyleOption: View {
    var style: HairStyle
    @ObservedObject var viewModel: AvatarViewModel
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            Image(systemName: style.rawValue)
                .font(.system(size: 40))
                .foregroundColor(viewModel.avatar.hairColor.color)
                .frame(width: 70, height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(viewModel.avatar.hairStyle == style ? 
                              Color.blue.opacity(0.2) : 
                              (colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7)))
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(viewModel.avatar.hairStyle == style ? Color.blue : Color.clear, lineWidth: 2)
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        var updatedAvatar = viewModel.avatar
                        updatedAvatar.hairStyle = style
                        viewModel.avatar = updatedAvatar
                    }
                }
            
            Text(style.displayName)
                .font(.caption)
                .foregroundColor(viewModel.avatar.hairStyle == style ? .blue : .primary)
        }
    }
}

// MARK: - Color Option
@available(macOS 11.0, *)
struct ColorOption: View {
    var color: AvatarColor
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        VStack {
            Circle()
                .fill(color.color)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                .onTapGesture(perform: action)
            
            Text(color.displayName)
                .font(.caption)
                .foregroundColor(isSelected ? .blue : .primary)
        }
    }
}

// MARK: - Preview Provider
@available(macOS 11.0, *)
struct AvatarCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AvatarCustomizationView(viewModel: AvatarViewModel())
        }
    }
}

// MARK: - Face Customization
@available(macOS 11.0, *)
struct FaceCustomizationView: View {
    @ObservedObject var viewModel: AvatarViewModel
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Placeholder for the full implementation
            Text("Face Customization")
                .font(.headline)
                .padding()
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Glasses Customization
@available(macOS 11.0, *)
struct GlassesCustomizationView: View {
    @ObservedObject var viewModel: AvatarViewModel
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Placeholder for the full implementation
            Text("Glasses Customization")
                .font(.headline)
                .padding()
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Clothing Customization
@available(macOS 11.0, *)
struct ClothingCustomizationView: View {
    @ObservedObject var viewModel: AvatarViewModel
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Placeholder for the full implementation
            Text("Clothing Customization")
                .font(.headline)
                .padding()
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Accessory Customization
@available(macOS 11.0, *)
struct AccessoryCustomizationView: View {
    @ObservedObject var viewModel: AvatarViewModel
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Placeholder for the full implementation
            Text("Accessory Customization")
                .font(.headline)
                .padding()
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Background Customization
@available(macOS 11.0, *)
struct BackgroundCustomizationView: View {
    @ObservedObject var viewModel: AvatarViewModel
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Placeholder for the full implementation
            Text("Background Customization")
                .font(.headline)
                .padding()
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Color Customization
@available(macOS 11.0, *)
struct ColorCustomizationView: View {
    @ObservedObject var viewModel: AvatarViewModel
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Placeholder for the full implementation
            Text("Color Customization")
                .font(.headline)
                .padding()
        }
        .padding(.vertical, 10)
    }
} 