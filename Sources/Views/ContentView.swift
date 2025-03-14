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
                        // Fallback for older versions
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 200, height: 200)
                            .overlay(
                                Text("Avatar Preview")
                                    .foregroundColor(.gray)
                            )
                            .padding()
                    }
                    
                    Button(action: {
                        isShowingCamera = true
                    }) {
                        Text("Scan QR Code")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Button(action: {
                        isShowingAvatarCreation = true
                    }) {
                        Text("Create Avatar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Spacer()
                }
                .navigationTitle("AvatarQR")
                .sheet(isPresented: $isShowingCamera) {
                    if #available(macOS 11.0, iOS 14.0, *) {
                        CameraView(viewModel: avatarViewModel)
                    } else {
                        Text("Camera not available on this device")
                            .padding()
                    }
                }
                .sheet(isPresented: $isShowingAvatarCreation) {
                    if #available(macOS 11.0, iOS 14.0, *) {
                        AvatarCustomizationView(viewModel: avatarViewModel)
                    } else {
                        Text("Avatar creation not available on this device")
                            .padding()
                    }
                }
            }
            .tabItem {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Label("Home", systemImage: "house")
                } else {
                    Text("Home")
                }
            }
            .tag(0)
            
            // Saved Avatars Tab
            if #available(macOS 11.0, iOS 14.0, *) {
                SavedAvatarsView(viewModel: avatarViewModel)
                    .tabItem {
                        Label("Saved", systemImage: "person.3")
                    }
                    .tag(1)
            } else {
                Text("Saved Avatars not available on this device")
                    .tabItem {
                        Text("Saved")
                    }
                    .tag(1)
            }
            
            // Settings Tab
            NavigationView {
                settingsListView
                    .navigationTitle("Settings")
            }
            .tabItem {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Label("Settings", systemImage: "gear")
                } else {
                    Text("Settings")
                }
            }
            .tag(2)
        }
    }
    
    var settingsListView: some View {
        List {
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
                Text("AvatarQR allows you to create and share custom avatars using QR codes.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.vertical, 5)
            }
        }
        #if os(iOS)
        .listStyle(GroupedListStyle())
        #endif
    }
} 