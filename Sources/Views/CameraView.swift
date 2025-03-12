import SwiftUI
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif

@available(macOS 11.0, iOS 14.0, *)
struct CameraView: View {
    @StateObject private var cameraService = CameraService()
    @ObservedObject var viewModel: AvatarViewModel
    
    // Use presentationMode for older versions, dismiss for newer versions
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isScanning = true
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if let frame = cameraService.frame {
                GeometryReader { geometry in
                    Image(decorative: frame, scale: 1.0, orientation: .up)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
            } else {
                Text("Camera initializing...")
                    .foregroundColor(.white)
            }
            
            VStack {
                Spacer()
                
                Text("Scan QR Code")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            // The CameraService initializer already calls checkPermission
            // No need to call setupCaptureSession as it's called in checkPermission
        }
        .onDisappear {
            cameraService.stop()
        }
        .onChange(of: cameraService.qrCodeValue) { newValue in
            if let qrValue = newValue, isScanning {
                isScanning = false
                handleQRCode(qrValue)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func handleQRCode(_ value: String) {
        if let data = value.data(using: .utf8),
           let avatar = try? JSONDecoder().decode(Avatar.self, from: data) {
            viewModel.avatar = avatar
            presentationMode.wrappedValue.dismiss()
        } else {
            alertMessage = "Invalid QR code. Please try again."
            showingAlert = true
            isScanning = true
        }
    }
}

#if canImport(UIKit)
@available(iOS 14.0, *)
struct CameraPreviewView: UIViewRepresentable {
    let cameraService: CameraService
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        cameraService.previewLayer.frame = view.bounds
        view.layer.addSublayer(cameraService.previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
#endif

@available(macOS 11.0, iOS 14.0, *)
struct ScannedAvatarView: View {
    let avatar: Avatar
    @Binding var isPresented: Bool
    let resumeScanning: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                AvatarPreviewView(avatar: avatar, size: 150)
                    .padding()
                
                Text(avatar.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Button(action: {
                    isPresented = false
                    resumeScanning()
                }) {
                    Text("Continue Scanning")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Scanned Avatar")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        isPresented = false
                        resumeScanning()
                    }
                }
            }
            #else
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Close") {
                        isPresented = false
                        resumeScanning()
                    }
                }
            }
            #endif
        }
    }
}

@available(macOS 11.0, iOS 14.0, *)
struct QRResultView: View {
    let qrCode: String
    @Binding var isPresented: Bool
    let resumeScanning: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "qrcode")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding()
                
                Text("Scanned QR Code")
                    .font(.headline)
                    .padding(.top)
                
                Text(qrCode)
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                Button(action: {
                    isPresented = false
                    resumeScanning()
                }) {
                    Text("Continue Scanning")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Scan Result")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        isPresented = false
                        resumeScanning()
                    }
                }
            }
            #else
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Close") {
                        isPresented = false
                        resumeScanning()
                    }
                }
            }
            #endif
        }
    }
} 