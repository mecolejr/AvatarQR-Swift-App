import SwiftUI

@available(macOS 11.0, *)
struct AvatarCustomizationView: View {
    @ObservedObject var viewModel: AvatarViewModel
    @State private var avatarName: String = ""
    @State private var selectedCategory: CustomizationCategory = .hair
    @Environment(\.presentationMode) private var presentationMode
    
    enum CustomizationCategory: String, CaseIterable {
        case hair = "Hair"
        case face = "Face"
        case glasses = "Glasses"
        case clothing = "Clothing"
        case accessory = "Accessory"
        case color = "Color"
    }
    
    var body: some View {
        VStack {
            // Avatar preview
            AvatarPreviewView(avatar: viewModel.avatar, size: 150)
                .padding()
            
            // Name field
            TextField("Avatar Name", text: $avatarName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onAppear {
                    avatarName = viewModel.avatar.name
                }
                .onChange(of: avatarName) { newValue in
                    var updatedAvatar = viewModel.avatar
                    updatedAvatar.name = newValue
                    viewModel.avatar = updatedAvatar
                }
            
            // Category selector
            Picker("Category", selection: $selectedCategory) {
                ForEach(CustomizationCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Customization options
            ScrollView {
                switch selectedCategory {
                case .hair:
                    hairCustomizationView
                case .face:
                    faceCustomizationView
                case .glasses:
                    glassesCustomizationView
                case .clothing:
                    clothingCustomizationView
                case .accessory:
                    accessoryCustomizationView
                case .color:
                    colorCustomizationView
                }
            }
            
            Spacer()
        }
        .navigationTitle("Customize Avatar")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    viewModel.saveAvatar()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private var hairCustomizationView: some View {
        VStack(alignment: .leading) {
            Text("Hair Style")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(HairStyle.allCases, id: \.self) { style in
                        VStack {
                            Image(systemName: style.rawValue)
                                .font(.system(size: 40))
                                .foregroundColor(viewModel.avatar.hairColor.color)
                                .frame(width: 60, height: 60)
                                .background(viewModel.avatar.hairStyle == style ? Color.blue.opacity(0.3) : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    var updatedAvatar = viewModel.avatar
                                    updatedAvatar.hairStyle = style
                                    viewModel.avatar = updatedAvatar
                                }
                            
                            Text(style.displayName)
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
            
            Text("Hair Color")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(AvatarColor.allCases, id: \.self) { color in
                        Circle()
                            .fill(color.color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.avatar.hairColor == color ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                var updatedAvatar = viewModel.avatar
                                updatedAvatar.hairColor = color
                                viewModel.avatar = updatedAvatar
                            }
                    }
                }
                .padding()
            }
        }
    }
    
    private var faceCustomizationView: some View {
        VStack(alignment: .leading) {
            Text("Skin Tone")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach([AvatarColor.tan, .brown, .black, .white, .yellow], id: \.self) { color in
                        Circle()
                            .fill(color.color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.avatar.skinTone == color ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                var updatedAvatar = viewModel.avatar
                                updatedAvatar.skinTone = color
                                viewModel.avatar = updatedAvatar
                            }
                    }
                }
                .padding()
            }
            
            Text("Eye Color")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach([AvatarColor.blue, .green, .brown, .black, .gray], id: \.self) { color in
                        Circle()
                            .fill(color.color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.avatar.eyeColor == color ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                var updatedAvatar = viewModel.avatar
                                updatedAvatar.eyeColor = color
                                viewModel.avatar = updatedAvatar
                            }
                    }
                }
                .padding()
            }
            
            Text("Facial Feature")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(FacialFeature.allCases, id: \.self) { feature in
                        VStack {
                            if let imageName = feature.systemImageName {
                                Image(systemName: imageName)
                                    .font(.system(size: 30))
                                    .frame(width: 50, height: 50)
                                    .background(viewModel.avatar.facialFeature == feature ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.facialFeature = feature
                                        viewModel.avatar = updatedAvatar
                                    }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                                    .overlay(Text("None"))
                                    .onTapGesture {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.facialFeature = feature
                                        viewModel.avatar = updatedAvatar
                                    }
                            }
                            
                            Text(feature.displayName)
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private var glassesCustomizationView: some View {
        VStack(alignment: .leading) {
            Text("Glasses Style")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Glasses.allCases, id: \.self) { glasses in
                        VStack {
                            if let imageName = glasses.systemImageName {
                                Image(systemName: imageName)
                                    .font(.system(size: 30))
                                    .foregroundColor(viewModel.avatar.glassesColor.color)
                                    .frame(width: 50, height: 50)
                                    .background(viewModel.avatar.glasses == glasses ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.glasses = glasses
                                        viewModel.avatar = updatedAvatar
                                    }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                                    .overlay(Text("None"))
                                    .onTapGesture {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.glasses = glasses
                                        viewModel.avatar = updatedAvatar
                                    }
                            }
                            
                            Text(glasses.displayName)
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
            
            if viewModel.avatar.glasses != .none {
                Text("Glasses Color")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(AvatarColor.allCases, id: \.self) { color in
                            Circle()
                                .fill(color.color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(viewModel.avatar.glassesColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    var updatedAvatar = viewModel.avatar
                                    updatedAvatar.glassesColor = color
                                    viewModel.avatar = updatedAvatar
                                }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var clothingCustomizationView: some View {
        VStack(alignment: .leading) {
            Text("Clothing Style")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Clothing.allCases, id: \.self) { clothing in
                        VStack {
                            if let imageName = clothing.systemImageName {
                                Image(systemName: imageName)
                                    .font(.system(size: 30))
                                    .foregroundColor(viewModel.avatar.clothingColor.color)
                                    .frame(width: 50, height: 50)
                                    .background(viewModel.avatar.clothing == clothing ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.clothing = clothing
                                        viewModel.avatar = updatedAvatar
                                    }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                                    .overlay(Text("None"))
                                    .onTapGesture {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.clothing = clothing
                                        viewModel.avatar = updatedAvatar
                                    }
                            }
                            
                            Text(clothing.displayName)
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
            
            if viewModel.avatar.clothing != .none {
                Text("Clothing Color")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(AvatarColor.allCases, id: \.self) { color in
                            Circle()
                                .fill(color.color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(viewModel.avatar.clothingColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    var updatedAvatar = viewModel.avatar
                                    updatedAvatar.clothingColor = color
                                    viewModel.avatar = updatedAvatar
                                }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var accessoryCustomizationView: some View {
        VStack(alignment: .leading) {
            Text("Accessory")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Accessory.allCases, id: \.self) { accessory in
                        VStack {
                            if let imageName = accessory.systemImageName {
                                Image(systemName: imageName)
                                    .font(.system(size: 30))
                                    .foregroundColor(viewModel.avatar.accessoryColor.color)
                                    .frame(width: 50, height: 50)
                                    .background(viewModel.avatar.accessory == accessory ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.accessory = accessory
                                        viewModel.avatar = updatedAvatar
                                    }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                                    .overlay(Text("None"))
                                    .onTapGesture {
                                        var updatedAvatar = viewModel.avatar
                                        updatedAvatar.accessory = accessory
                                        viewModel.avatar = updatedAvatar
                                    }
                            }
                            
                            Text(accessory.displayName)
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
            
            if viewModel.avatar.accessory != .none {
                Text("Accessory Color")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(AvatarColor.allCases, id: \.self) { color in
                            Circle()
                                .fill(color.color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(viewModel.avatar.accessoryColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    var updatedAvatar = viewModel.avatar
                                    updatedAvatar.accessoryColor = color
                                    viewModel.avatar = updatedAvatar
                                }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var colorCustomizationView: some View {
        VStack(alignment: .leading) {
            Text("Background Color")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(AvatarColor.allCases, id: \.self) { color in
                        Circle()
                            .fill(color.color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.avatar.backgroundColor == color ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                var updatedAvatar = viewModel.avatar
                                updatedAvatar.backgroundColor = color
                                viewModel.avatar = updatedAvatar
                            }
                    }
                }
                .padding()
            }
        }
    }
} 