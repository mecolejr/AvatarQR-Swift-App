import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
struct SavedAvatarsView: View {
    @ObservedObject var viewModel: AvatarViewModel
    @State private var selectedAvatar: Avatar? = nil
    @State private var isShowingQRCode = false
    
    var body: some View {
        if viewModel.savedAvatars.isEmpty {
            VStack {
                Spacer()
                Text("No saved avatars")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text("Create an avatar to see it here")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                Spacer()
            }
        } else {
            List {
                ForEach(viewModel.savedAvatars) { avatar in
                    HStack {
                        AvatarPreviewView(avatar: avatar, size: 60)
                            .padding(.vertical, 5)
                        
                        VStack(alignment: .leading) {
                            Text(avatar.name)
                                .font(.headline)
                            Text("Created: \(formattedDate(avatar.dateCreated))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            selectedAvatar = avatar
                            isShowingQRCode = true
                        }) {
                            if #available(macOS 11.0, iOS 14.0, *) {
                                Image(systemName: "qrcode")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            } else {
                                Text("QR")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.blue, lineWidth: 1)
                                    )
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button(action: {
                            viewModel.deleteAvatar(avatar)
                        }) {
                            if #available(macOS 11.0, iOS 14.0, *) {
                                Label("Delete", systemImage: "trash")
                            } else {
                                Text("Delete")
                            }
                        }
                        
                        Button(action: {
                            viewModel.avatar = avatar
                        }) {
                            if #available(macOS 11.0, iOS 14.0, *) {
                                Label("Set as Current", systemImage: "person.fill.checkmark")
                            } else {
                                Text("Set as Current")
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.deleteAvatar(viewModel.savedAvatars[index])
                    }
                }
            }
            .listStyle(InsetListStyle())
            .sheet(isPresented: $isShowingQRCode, onDismiss: {
                selectedAvatar = nil
            }) {
                if let avatar = selectedAvatar, #available(macOS 11.0, iOS 14.0, *) {
                    AvatarQRCodeView(avatar: avatar, viewModel: viewModel)
                } else {
                    // Fallback for older versions
                    VStack {
                        Text("QR Code Generation")
                            .font(.headline)
                            .padding()
                        
                        Text("QR code generation requires macOS 11.0 or iOS 14.0 or newer.")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Close") {
                            isShowingQRCode = false
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

@available(macOS 11.0, iOS 14.0, *)
struct AvatarQRCodeView: View {
    let avatar: Avatar
    let viewModel: AvatarViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var qrImage: Image?
    @State private var isGeneratingQR = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(avatar.name)
                    .font(.title)
                    .padding(.top)
                
                AvatarPreviewView(avatar: avatar, size: 120)
                    .padding()
                
                if let qrImage = qrImage {
                    qrImage
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .frame(width: 200, height: 200)
                        .padding()
                }
                
                #if canImport(UIKit)
                if #available(iOS 14.0, *) {
                    Button(action: {
                        if let qrCodeImage = viewModel.generateQRCode(for: avatar, size: CGSize(width: 300, height: 300)) {
                            let activityVC = UIActivityViewController(activityItems: [qrCodeImage], applicationActivities: nil)
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootViewController = windowScene.windows.first?.rootViewController {
                                rootViewController.present(activityVC, animated: true)
                            }
                        }
                    }) {
                        Label("Share QR Code", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                #endif
                
                #if canImport(AppKit)
                if #available(macOS 11.0, *) {
                    Button(action: {
                        if let qrCodeImage = viewModel.generateQRCode(for: avatar, size: CGSize(width: 300, height: 300)) {
                            // Save to desktop or share via macOS sharing services
                            let savePanel = NSSavePanel()
                            savePanel.allowedContentTypes = [.png]
                            savePanel.nameFieldStringValue = "\(avatar.name)_QRCode.png"
                            
                            if savePanel.runModal() == .OK, let url = savePanel.url {
                                if let tiffData = qrCodeImage.tiffRepresentation,
                                   let bitmapImage = NSBitmapImageRep(data: tiffData),
                                   let pngData = bitmapImage.representation(using: .png, properties: [:]) {
                                    try? pngData.write(to: url)
                                }
                            }
                        }
                    }) {
                        Label("Save QR Code", systemImage: "square.and.arrow.down")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                #endif
                
                Spacer()
            }
            .navigationTitle("QR Code")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            #else
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            #endif
            .onAppear {
                #if canImport(UIKit)
                if let qrCodeImage = viewModel.generateQRCode(for: avatar, size: CGSize(width: 300, height: 300)) {
                    self.qrImage = Image(uiImage: qrCodeImage)
                }
                isGeneratingQR = false
                #elseif canImport(AppKit)
                if let qrCodeImage = viewModel.generateQRCode(for: avatar, size: CGSize(width: 300, height: 300)) {
                    self.qrImage = Image(nsImage: qrCodeImage)
                }
                isGeneratingQR = false
                #endif
            }
        }
    }
} 