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
            VStack(spacing: 0) {
                // Avatar preview section
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
                
                // Category selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(CustomizationCategory.allCases, id: \.self) { category in
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
                
                // Customization options based on selected category
                ScrollView {
                    VStack {
                        switch selectedCategory {
                        case .face:
                            faceCustomizationView
                        case .hair:
                            hairCustomizationView
                        case .glasses:
                            glassesCustomizationView
                        case .clothing:
                            clothingCustomizationView
                        case .accessory:
                            accessoryCustomizationView
                        case .background:
                            backgroundCustomizationView
                        case .color:
                            colorCustomizationView
                        }
                    }
                    .padding(.bottom, 20)
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7))
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                )
                .padding(.horizontal, 15)
                .padding(.top, 15)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            avatarName = viewModel.avatar.name
        }
        .navigationTitle("Customize Avatar")
    }
    
    private var hairCustomizationView: some View {
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
                        Circle()
                            .fill(color.color)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.avatar.hairColor == color ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    var updatedAvatar = viewModel.avatar
                                    updatedAvatar.hairColor = color
                                    viewModel.avatar = updatedAvatar
                                }
                            }
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
    
    private var faceCustomizationView: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section header with icon
            HStack {
                Image(systemName: "face.smiling")
                    .foregroundColor(.blue)
                Text("Skin Tone")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Skin tone options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach([AvatarColor.tan, .brown, .black, .white, .yellow], id: \.self) { color in
                        VStack {
                            Circle()
                                .fill(color.color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(viewModel.avatar.skinTone == color ? Color.blue : Color.clear, lineWidth: 3)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.skinTone = color
                                        viewModel.avatar = updatedAvatar
                                    }
                                }
                            
                            Text(color.displayName)
                                .font(.caption)
                                .foregroundColor(viewModel.avatar.skinTone == color ? .blue : .primary)
                        }
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
                Image(systemName: "eye")
                    .foregroundColor(.blue)
                Text("Eye Color")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Eye color options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach([AvatarColor.blue, .green, .brown, .black, .gray], id: \.self) { color in
                        VStack {
                            Circle()
                                .fill(color.color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(viewModel.avatar.eyeColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.eyeColor = color
                                        viewModel.avatar = updatedAvatar
                                    }
                                }
                            
                            Text(color.displayName)
                                .font(.caption)
                                .foregroundColor(viewModel.avatar.eyeColor == color ? .blue : .primary)
                        }
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
                Image(systemName: "mouth")
                    .foregroundColor(.blue)
                Text("Facial Feature")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Facial feature options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(FacialFeature.allCases, id: \.self) { feature in
                        VStack {
                            if let imageName = feature.systemImageName {
                                Image(systemName: imageName)
                                    .font(.system(size: 30))
                                    .frame(width: 70, height: 70)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.avatar.facialFeature == feature ? 
                                                  Color.blue.opacity(0.2) : 
                                                  (colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7)))
                                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(viewModel.avatar.facialFeature == feature ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.facialFeature = feature
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7))
                                    .frame(width: 70, height: 70)
                                    .overlay(Text("None"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(viewModel.avatar.facialFeature == feature ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.facialFeature = feature
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                            }
                            
                            Text(feature.displayName)
                                .font(.caption)
                                .foregroundColor(viewModel.avatar.facialFeature == feature ? .blue : .primary)
                        }
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
    
    private var glassesCustomizationView: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section header with icon
            HStack {
                Image(systemName: "eyeglasses")
                    .foregroundColor(.blue)
                Text("Glasses Style")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Glasses style options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Glasses.allCases, id: \.self) { glasses in
                        VStack {
                            if let imageName = glasses.systemImageName {
                                Image(systemName: imageName)
                                    .font(.system(size: 30))
                                    .foregroundColor(viewModel.avatar.glassesColor.color)
                                    .frame(width: 70, height: 70)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.avatar.glasses == glasses ? 
                                                  Color.blue.opacity(0.2) : 
                                                  (colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7)))
                                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(viewModel.avatar.glasses == glasses ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.glasses = glasses
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7))
                                    .frame(width: 70, height: 70)
                                    .overlay(Text("None"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(viewModel.avatar.glasses == glasses ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.glasses = glasses
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                            }
                            
                            Text(glasses.displayName)
                                .font(.caption)
                                .foregroundColor(viewModel.avatar.glasses == glasses ? .blue : .primary)
                        }
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
            
            if viewModel.avatar.glasses != .none {
                // Section header with icon
                HStack {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.blue)
                    Text("Glasses Color")
                        .font(.headline)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Glasses color options
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(AvatarColor.allCases, id: \.self) { color in
                            VStack {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(viewModel.avatar.glassesColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.glassesColor = color
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                                
                                Text(color.displayName)
                                    .font(.caption)
                                    .foregroundColor(viewModel.avatar.glassesColor == color ? .blue : .primary)
                            }
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
        }
        .padding(.vertical, 10)
    }
    
    private var clothingCustomizationView: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section header with icon
            HStack {
                Image(systemName: "tshirt")
                    .foregroundColor(.blue)
                Text("Clothing Style")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Clothing style options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Clothing.allCases, id: \.self) { clothing in
                        VStack {
                            if let imageName = clothing.systemImageName {
                                Image(systemName: imageName)
                                    .font(.system(size: 30))
                                    .foregroundColor(viewModel.avatar.clothingColor.color)
                                    .frame(width: 70, height: 70)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.avatar.clothing == clothing ? 
                                                  Color.blue.opacity(0.2) : 
                                                  (colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7)))
                                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(viewModel.avatar.clothing == clothing ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.clothing = clothing
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7))
                                    .frame(width: 70, height: 70)
                                    .overlay(Text("None"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(viewModel.avatar.clothing == clothing ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.clothing = clothing
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                            }
                            
                            Text(clothing.displayName)
                                .font(.caption)
                                .foregroundColor(viewModel.avatar.clothing == clothing ? .blue : .primary)
                        }
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
            
            if viewModel.avatar.clothing != .none {
                // Section header with icon
                HStack {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.blue)
                    Text("Clothing Color")
                        .font(.headline)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Clothing color options
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(AvatarColor.allCases, id: \.self) { color in
                            VStack {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(viewModel.avatar.clothingColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.clothingColor = color
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                                
                                Text(color.displayName)
                                    .font(.caption)
                                    .foregroundColor(viewModel.avatar.clothingColor == color ? .blue : .primary)
                            }
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
        }
        .padding(.vertical, 10)
    }
    
    private var accessoryCustomizationView: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section header with icon
            HStack {
                Image(systemName: "crown")
                    .foregroundColor(.blue)
                Text("Accessory")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Accessory options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Accessory.allCases, id: \.self) { accessory in
                        VStack {
                            if let imageName = accessory.systemImageName {
                                Image(systemName: imageName)
                                    .font(.system(size: 30))
                                    .foregroundColor(viewModel.avatar.accessoryColor.color)
                                    .frame(width: 70, height: 70)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.avatar.accessory == accessory ? 
                                                  Color.blue.opacity(0.2) : 
                                                  (colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7)))
                                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(viewModel.avatar.accessory == accessory ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.accessory = accessory
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7))
                                    .frame(width: 70, height: 70)
                                    .overlay(Text("None"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(viewModel.avatar.accessory == accessory ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.accessory = accessory
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                            }
                            
                            Text(accessory.displayName)
                                .font(.caption)
                                .foregroundColor(viewModel.avatar.accessory == accessory ? .blue : .primary)
                        }
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
            
            if viewModel.avatar.accessory != .none {
                // Section header with icon
                HStack {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.blue)
                    Text("Accessory Color")
                        .font(.headline)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Accessory color options
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(AvatarColor.allCases, id: \.self) { color in
                            VStack {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(viewModel.avatar.accessoryColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            var updatedAvatar = viewModel.avatar
                                            updatedAvatar.accessoryColor = color
                                            viewModel.avatar = updatedAvatar
                                        }
                                    }
                                
                                Text(color.displayName)
                                    .font(.caption)
                                    .foregroundColor(viewModel.avatar.accessoryColor == color ? .blue : .primary)
                            }
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
        }
        .padding(.vertical, 10)
    }
    
    private var colorCustomizationView: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section header with icon
            HStack {
                Image(systemName: "circle.fill")
                    .foregroundColor(.blue)
                Text("Background Color")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Background color grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 15) {
                ForEach(AvatarColor.allCases, id: \.self) { color in
                    VStack {
                        Circle()
                            .fill(color.color)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.avatar.backgroundColor == color ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    var updatedAvatar = viewModel.avatar
                                    updatedAvatar.backgroundColor = color
                                    viewModel.avatar = updatedAvatar
                                }
                            }
                        
                        Text(color.displayName)
                            .font(.caption)
                            .foregroundColor(viewModel.avatar.backgroundColor == color ? .blue : .primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.7))
                    .padding(.horizontal, 10)
            )
            
            // Preview with selected background
            VStack {
                Text("Preview")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                Circle()
                    .fill(viewModel.avatar.backgroundColor.color)
                    .frame(width: 100, height: 100)
                    .overlay(
                        AvatarPreviewView(avatar: viewModel.avatar, size: 80)
                            .padding(10)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
        }
        .padding(.vertical, 10)
    }
    
    private var backgroundCustomizationView: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section header with icon
            HStack {
                Image(systemName: "square.fill")
                    .foregroundColor(.blue)
                Text("Background Style")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Background style options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(BackgroundStyle.allCases, id: \.self) { style in
                        VStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(style == .solid ? 
                                      viewModel.avatar.backgroundColor.color : 
                                      LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                      ))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(viewModel.avatar.backgroundStyle == style ? Color.blue : Color.clear, lineWidth: 2)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.backgroundStyle = style
                                        viewModel.avatar = updatedAvatar
                                    }
                                }
                            
                            Text(style.displayName)
                                .font(.caption)
                                .foregroundColor(viewModel.avatar.backgroundStyle == style ? .blue : .primary)
                        }
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
            
            if viewModel.avatar.backgroundStyle == .gradient {
                // Section header with icon
                HStack {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.blue)
                    Text("Gradient Colors")
                        .font(.headline)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Gradient color options
                VStack(alignment: .leading, spacing: 15) {
                    // Start color
                    HStack {
                        Text("Start Color")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(AvatarColor.allCases, id: \.self) { color in
                                VStack {
                                    Circle()
                                        .fill(color.color)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .stroke(viewModel.avatar.gradientStartColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                        )
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                var updatedAvatar = viewModel.avatar
                                                updatedAvatar.gradientStartColor = color
                                                viewModel.avatar = updatedAvatar
                                            }
                                        }
                                    
                                    Text(color.displayName)
                                        .font(.caption)
                                        .foregroundColor(viewModel.avatar.gradientStartColor == color ? .blue : .primary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // End color
                    HStack {
                        Text("End Color")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(AvatarColor.allCases, id: \.self) { color in
                                VStack {
                                    Circle()
                                        .fill(color.color)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .stroke(viewModel.avatar.gradientEndColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                        )
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                var updatedAvatar = viewModel.avatar
                                                updatedAvatar.gradientEndColor = color
                                                viewModel.avatar = updatedAvatar
                                            }
                                        }
                                    
                                    Text(color.displayName)
                                        .font(.caption)
                                        .foregroundColor(viewModel.avatar.gradientEndColor == color ? .blue : .primary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.7))
                        .padding(.horizontal, 10)
                )
                
                // Preview with gradient
                VStack {
                    Text("Preview")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
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
                        .frame(width: 100, height: 100)
                        .overlay(
                            AvatarPreviewView(avatar: viewModel.avatar, size: 80)
                                .padding(10)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
            }
        }
        .padding(.vertical, 10)
    }
} 