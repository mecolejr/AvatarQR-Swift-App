//
//  SwiftUIView.swift
//  AvatarQR
//
//  Created by Mj • on 3/14/25.
//

import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
struct SwiftUIView: View {
    @StateObject private var viewModel = AvatarViewModel()
    @State private var showingSavedAvatars = false
    @State private var showingQRCode = false
    @State private var qrCodeImage: Image?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Avatar preview
                    ZStack {
                        Circle()
                            .fill(viewModel.avatar.backgroundColor.color)
                            .frame(width: 200, height: 200)
                        
                        // Hair style
                        Image(systemName: viewModel.avatar.hairStyle.rawValue)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(viewModel.avatar.hairColor.color)
                            .frame(width: 120, height: 120)
                        
                        // Display facial feature if available
                        if let featureImage = viewModel.avatar.facialFeature.systemImageName {
                            Image(systemName: featureImage)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.black)
                                .frame(width: 80, height: 80)
                        }
                        
                        // Display accessory if available
                        if let accessoryImage = viewModel.avatar.accessory.systemImageName {
                            Image(systemName: accessoryImage)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(viewModel.avatar.accessoryColor.color)
                                .frame(width: 60, height: 60)
                                .offset(y: -80) // Position at the top
                        }
                    }
                    .padding()
                    
                    // Avatar name
                    TextField("Avatar Name", text: Binding(
                        get: { self.viewModel.avatar.name },
                        set: { self.viewModel.updateAvatarName($0) }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    
                    // Customization sections
                    Group {
                        // Hair Style
                        Section(header: Text("Hair Style").font(.headline).padding(.top)) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(HairStyle.allCases, id: \.self) { style in
                                        VStack {
                                            Image(systemName: style.rawValue)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(viewModel.avatar.hairColor.color)
                                                .padding(8)
                                                .background(
                                                    Circle()
                                                        .fill(viewModel.avatar.hairStyle == style ? Color.blue.opacity(0.2) : Color.clear)
                                                )
                                                .overlay(
                                                    Circle()
                                                        .stroke(viewModel.avatar.hairStyle == style ? Color.blue : Color.clear, lineWidth: 2)
                                                )
                                            Text(style.displayName)
                                                .font(.caption)
                                        }
                                        .onTapGesture {
                                            viewModel.updateHairStyle(style)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Hair Color
                        Section(header: Text("Hair Color").font(.headline).padding(.top)) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach([AvatarColor.black, .brown, .red, .yellow, .gray, .white], id: \.self) { color in
                                        Circle()
                                            .fill(color.color)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Circle()
                                                    .stroke(viewModel.avatar.hairColor == color ? Color.blue : Color.clear, lineWidth: 2)
                                            )
                                            .onTapGesture {
                                                viewModel.updateHairColor(color)
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Facial Features
                        Section(header: Text("Facial Features").font(.headline).padding(.top)) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(FacialFeature.allCases, id: \.self) { feature in
                                        VStack {
                                            if let imageName = feature.systemImageName {
                                                Image(systemName: imageName)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40, height: 40)
                                                    .padding(8)
                                                    .background(
                                                        Circle()
                                                            .fill(viewModel.avatar.facialFeature == feature ? Color.blue.opacity(0.2) : Color.clear)
                                                    )
                                                    .overlay(
                                                        Circle()
                                                            .stroke(viewModel.avatar.facialFeature == feature ? Color.blue : Color.clear, lineWidth: 2)
                                                    )
                                            } else {
                                                Circle()
                                                    .fill(Color.gray.opacity(0.2))
                                                    .frame(width: 40, height: 40)
                                                    .padding(8)
                                            }
                                            Text(feature.displayName)
                                                .font(.caption)
                                        }
                                        .onTapGesture {
                                            viewModel.updateFacialFeature(feature)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Background Color
                        Section(header: Text("Background Color").font(.headline).padding(.top)) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach([AvatarColor.lightBlue, .blue, .green, .red, .purple, .orange, .pink], id: \.self) { color in
                                        Circle()
                                            .fill(color.color)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Circle()
                                                    .stroke(viewModel.avatar.backgroundColor == color ? Color.blue : Color.clear, lineWidth: 2)
                                            )
                                            .onTapGesture {
                                                viewModel.updateBackgroundColor(color)
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Action buttons
                    HStack(spacing: 20) {
                        // Save button
                        Button(action: {
                            viewModel.saveAvatar()
                        }) {
                            Text("Save Avatar")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        // View Saved button
                        Button(action: {
                            showingSavedAvatars = true
                        }) {
                            Text("View Saved")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Generate QR Code button
                    Button(action: {
                        generateQRCode()
                    }) {
                        HStack {
                            Image(systemName: "qrcode")
                                .font(.title2)
                            Text("Generate QR Code")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Create Avatar")
            .sheet(isPresented: $showingSavedAvatars) {
                savedAvatarsView
            }
            .sheet(isPresented: $showingQRCode) {
                qrCodeView
            }
        }
    }
    
    // View for displaying saved avatars
    var savedAvatarsView: some View {
        NavigationView {
            List {
                if viewModel.savedAvatars.isEmpty {
                    Text("No saved avatars yet")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(viewModel.savedAvatars) { avatar in
                        HStack {
                            // Avatar preview circle
                            Circle()
                                .fill(avatar.backgroundColor.color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: avatar.facialFeature.systemImageName ?? "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.black)
                                        .frame(width: 30, height: 30)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(avatar.name)
                                    .font(.headline)
                                Text("Created: \(formattedDate(avatar.dateCreated))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.loadAvatar(avatar)
                                showingSavedAvatars = false
                            }) {
                                Text("Load")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.deleteAvatar(viewModel.savedAvatars[index])
                        }
                    }
                }
            }
            .navigationTitle("Saved Avatars")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingSavedAvatars = false
                    }
                }
                #else
                ToolbarItem(placement: .automatic) {
                    Button("Done") {
                        showingSavedAvatars = false
                    }
                }
                #endif
            }
        }
    }
    
    // View for displaying QR code
    var qrCodeView: some View {
        NavigationView {
            VStack(spacing: 30) {
                if let qrImage = qrCodeImage {
                    qrImage
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    Text("Generating QR Code...")
                }
                
                Text("Scan this QR code to share your avatar")
                    .font(.headline)
                
                Text(viewModel.avatar.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                #if os(iOS)
                Button(action: {
                    // Share QR code functionality would go here
                    // This would use UIActivityViewController on iOS
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share QR Code")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                #endif
                
                Button(action: {
                    showingQRCode = false
                }) {
                    Text("Close")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Avatar QR Code")
            .onAppear {
                if qrCodeImage == nil {
                    generateQRCode()
                }
            }
        }
    }
    
    // Helper function to format dates
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    // Function to generate QR code
    func generateQRCode() {
        #if os(iOS)
        if let uiImage = viewModel.generateQRCode(for: viewModel.avatar, size: CGSize(width: 250, height: 250)) {
            qrCodeImage = Image(uiImage: uiImage)
            showingQRCode = true
        }
        #elseif os(macOS)
        if let nsImage = viewModel.generateQRCode(for: viewModel.avatar, size: CGSize(width: 250, height: 250)) {
            qrCodeImage = Image(nsImage: nsImage)
            showingQRCode = true
        }
        #endif
    }
}

#Preview {
    if #available(macOS 11.0, iOS 14.0, *) {
        SwiftUIView()
    } else {
        Text("Requires iOS 14.0+ or macOS 11.0+")
    }
}
