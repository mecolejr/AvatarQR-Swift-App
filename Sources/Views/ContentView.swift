import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
struct ContentView: View {
    @ObservedObject private var avatarViewModel: AvatarViewModel
    @State private var selectedTab = 0
    @State private var isShowingCamera = false
    @State private var isShowingAvatarCreation = false
    
    init() {
        let viewModel = AvatarViewModel()
        self._avatarViewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                VStack {
                    Spacer()
                    
                    if #available(macOS 11.0, iOS 14.0, *) {
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                            .padding()
                    } else {
                        // Fallback for older versions
                        ZStack {
                            Rectangle()
                                .stroke(Color.blue, lineWidth: 3)
                                .frame(width: 100, height: 100)
                            
                            Rectangle()
                                .stroke(Color.blue, lineWidth: 3)
                                .frame(width: 70, height: 70)
                            
                            Text("QR")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                    
                    if #available(macOS 11.0, iOS 14.0, *) {
                        AvatarPreviewView(avatar: avatarViewModel.avatar, size: 200)
                            .padding()
                    } else {
                        // Simple circle for older versions
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 200, height: 200)
                            .padding()
                    }
                    
                    Text("Scan a QR code to load an avatar")
                        .font(.headline)
                        .padding()
                    
                    Button(action: {
                        isShowingCamera = true
                    }) {
                        Text("Scan QR Code")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("")
                .sheet(isPresented: $isShowingCamera) {
                    if #available(macOS 11.0, iOS 14.0, *) {
                        CameraView(viewModel: avatarViewModel)
                    } else {
                        // Fallback for older versions
                        VStack {
                            Text("Camera Access")
                                .font(.headline)
                                .padding()
                            
                            Text("Camera access requires macOS 11.0 or iOS 14.0 or newer.")
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Button("Close") {
                                isShowingCamera = false
                            }
                            .padding()
                        }
                    }
                }
            }
            .tabItem {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                } else {
                    Text("Scan")
                }
            }
            .tag(0)
            
            // Saved Avatars Tab
            NavigationView {
                if #available(macOS 10.15, iOS 13.0, *) {
                    SavedAvatarsView(viewModel: avatarViewModel)
                        .toolbar {
                            #if os(iOS)
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    isShowingAvatarCreation = true
                                }) {
                                    if #available(macOS 11.0, iOS 14.0, *) {
                                        Image(systemName: "plus")
                                    } else {
                                        Text("+")
                                            .font(.title)
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                            #else
                            ToolbarItem(placement: .automatic) {
                                Button(action: {
                                    isShowingAvatarCreation = true
                                }) {
                                    if #available(macOS 11.0, iOS 14.0, *) {
                                        Image(systemName: "plus")
                                    } else {
                                        Text("+")
                                            .font(.title)
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                            #endif
                        }
                        .navigationTitle("Saved Avatars")
                } else {
                    Text("Saved Avatars")
                        .font(.headline)
                }
            }
            .tabItem {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Label("Avatars", systemImage: "person.crop.circle")
                } else {
                    Text("Avatars")
                }
            }
            .tag(1)
            
            // Profile Tab
            NavigationView {
                VStack {
                    Text("Profile Settings")
                        .font(.headline)
                        .padding()
                    
                    Spacer()
                }
                .navigationTitle("Profile")
            }
            .tabItem {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Label("Profile", systemImage: "person")
                } else {
                    Text("Profile")
                }
            }
            .tag(2)
        }
        .sheet(isPresented: $isShowingAvatarCreation) {
            NavigationView {
                if #available(macOS 11.0, iOS 14.0, *) {
                    AvatarCustomizationView(viewModel: avatarViewModel)
                        .navigationTitle("Create Avatar")
                        #if os(iOS)
                        .navigationBarTitleDisplayMode(.inline)
                        #endif
                } else {
                    // Fallback for older versions
                    VStack {
                        Text("Avatar Customization")
                            .font(.headline)
                            .padding()
                        
                        Text("Avatar customization requires macOS 11.0 or iOS 14.0 or newer.")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Close") {
                            isShowingAvatarCreation = false
                        }
                        .padding()
                    }
                }
            }
        }
    }
} 