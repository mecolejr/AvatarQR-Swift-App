import SwiftUI
import AvatarQRLib

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
        if #available(iOS 14.0, *) {
            TabView(selection: $selectedTab) {
                // Home Tab
                NavigationView {
                    VStack {
                        Spacer()
                        
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                            .padding()
                        
                        AvatarPreviewView(avatar: avatarViewModel.avatar, size: 200)
                            .padding()
                        
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
                        CameraView(viewModel: avatarViewModel)
                    }
                }
                .tabItem {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
                .tag(0)
                
                // Saved Avatars Tab
                NavigationView {
                    SavedAvatarsView(viewModel: avatarViewModel)
                        .toolbar {
                            #if os(iOS)
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    isShowingAvatarCreation = true
                                }) {
                                    Image(systemName: "plus")
                                }
                            }
                            #endif
                        }
                        .navigationTitle("Saved Avatars")
                }
                .tabItem {
                    Label("Avatars", systemImage: "person.crop.circle")
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
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
            }
            .sheet(isPresented: $isShowingAvatarCreation) {
                NavigationView {
                    AvatarCustomizationView(viewModel: avatarViewModel)
                        .navigationTitle("Create Avatar")
                        #if os(iOS)
                        .navigationBarTitleDisplayMode(.inline)
                        #endif
                }
            }
        } else {
            // Fallback for iOS versions earlier than 14.0
            NavigationView {
                VStack {
                    Text("AvatarQR")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("This app requires iOS 14.0 or later for full functionality.")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                }
            }
        }
    }
} 