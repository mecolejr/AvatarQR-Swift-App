import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
struct MainView: View {
    @StateObject private var viewModel = AvatarViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                VStack(spacing: 25) {
                    // App logo/title
                    VStack {
                        Text("AvatarQR")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Text("Create and share custom avatars")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 30)
                    
                    // Current avatar preview
                    VStack {
                        Text("Your Current Avatar")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        AvatarPreviewView(avatar: viewModel.avatar, size: 180)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.gray.opacity(0.1))
                            )
                    }
                    
                    // Action buttons
                    VStack(spacing: 15) {
                        NavigationLink(destination: SwiftUIView()) {
                            HStack {
                                Image(systemName: "person.fill.viewfinder")
                                    .font(.title2)
                                Text("Customize Avatar")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: CameraView(viewModel: viewModel)) {
                            HStack {
                                Image(systemName: "qrcode.viewfinder")
                                    .font(.title2)
                                Text("Scan QR Code")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Generate QR code for current avatar
                            selectedTab = 2 // Switch to QR tab
                        }) {
                            HStack {
                                Image(systemName: "qrcode")
                                    .font(.title2)
                                Text("Generate QR Code")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Home")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            // Gallery Tab
            NavigationView {
                SavedAvatarsView(viewModel: viewModel)
                    .navigationTitle("My Avatars")
            }
            .tabItem {
                Label("Gallery", systemImage: "person.3.fill")
            }
            .tag(1)
            
            // QR Code Tab
            NavigationView {
                QRCodeGeneratorView(viewModel: viewModel)
                    .navigationTitle("QR Code")
            }
            .tabItem {
                Label("QR Code", systemImage: "qrcode")
            }
            .tag(2)
            
            // Settings Tab
            NavigationView {
                SettingsView()
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(3)
        }
    }
}

@available(macOS 11.0, iOS 14.0, *)
struct QRCodeGeneratorView: View {
    @ObservedObject var viewModel: AvatarViewModel
    @State private var qrCodeImage: Image?
    @State private var isGenerating = false
    
    var body: some View {
        VStack(spacing: 25) {
            // Avatar preview
            AvatarPreviewView(avatar: viewModel.avatar, size: 120)
                .padding()
            
            Text(viewModel.avatar.name)
                .font(.title2)
                .fontWeight(.bold)
            
            // QR Code display
            VStack {
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
                } else if isGenerating {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    Text("Generating QR Code...")
                } else {
                    Image(systemName: "qrcode")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(width: 200, height: 200)
                        .padding()
                }
            }
            .padding()
            
            // Generate button
            Button(action: {
                generateQRCode()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Generate QR Code")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .disabled(isGenerating)
            
            #if os(iOS)
            // Share button (iOS only)
            if qrCodeImage != nil {
                Button(action: {
                    // Share functionality would go here
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share QR Code")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                }
            }
            #endif
            
            Spacer()
        }
        .padding()
        .onAppear {
            generateQRCode()
        }
    }
    
    func generateQRCode() {
        isGenerating = true
        
        #if os(iOS)
        if let uiImage = viewModel.generateQRCode(for: viewModel.avatar, size: CGSize(width: 250, height: 250)) {
            qrCodeImage = Image(uiImage: uiImage)
        }
        #elseif os(macOS)
        if let nsImage = viewModel.generateQRCode(for: viewModel.avatar, size: CGSize(width: 250, height: 250)) {
            qrCodeImage = Image(nsImage: nsImage)
        }
        #endif
        
        isGenerating = false
    }
}

@available(macOS 11.0, iOS 14.0, *)
struct SettingsView: View {
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("User Settings")) {
                TextField("Your Name", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Section(header: Text("Preferences")) {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                Toggle("Dark Mode", isOn: $darkModeEnabled)
            }
            
            Section(header: Text("App Info")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text("1")
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("About")) {
                Text("AvatarQR allows you to create and share custom avatars using QR codes. Create your unique avatar, customize it to your liking, and share it with friends!")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.vertical, 5)
            }
        }
    }
}

#Preview {
    if #available(macOS 11.0, iOS 14.0, *) {
        MainView()
    } else {
        Text("Requires iOS 14.0+ or macOS 11.0+")
    }
} 