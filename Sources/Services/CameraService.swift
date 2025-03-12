import Foundation
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif
import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
class CameraService: NSObject, ObservableObject {
    @Published var authorizationStatus: AVAuthorizationStatus = .notDetermined
    @Published var error: CameraError?
    @Published var frame: CGImage?
    @Published var qrCodeValue: String?
    
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    
    // Use conditional compilation for macOS 13.0+ features
    #if os(iOS)
    let metadataOutput = AVCaptureMetadataOutput()
    #endif
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let sessionQueue = DispatchQueue(label: "com.avatarqr.sessionQueue")
    private let metadataQueue = DispatchQueue(label: "com.avatarqr.metadataQueue")
    
    enum CameraError: Error {
        case cameraUnavailable
        case cannotAddInput
        case cannotAddOutput
        case createCaptureInput(Error)
    }
    
    override init() {
        super.init()
        checkPermission()
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.authorizationStatus = .authorized
            self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.authorizationStatus = granted ? .authorized : .denied
                    if granted {
                        self?.setupCaptureSession()
                    }
                }
            }
        default:
            self.authorizationStatus = .denied
        }
    }
    
    func setupCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            self.error = .cameraUnavailable
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                self.error = .cannotAddInput
                return
            }
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
                videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
            } else {
                self.error = .cannotAddOutput
                return
            }
            
            // Handle QR code scanning differently based on platform
            #if os(iOS)
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: metadataQueue)
                metadataOutput.metadataObjectTypes = [.qr]
            }
            #elseif os(macOS)
            if #available(macOS 13.0, *) {
                let metadataOutput = AVCaptureMetadataOutput()
                if captureSession.canAddOutput(metadataOutput) {
                    captureSession.addOutput(metadataOutput)
                    metadataOutput.setMetadataObjectsDelegate(self, queue: metadataQueue)
                    metadataOutput.metadataObjectTypes = [.qr]
                }
            }
            #endif
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            
            sessionQueue.async { [weak self] in
                self?.captureSession.startRunning()
            }
        } catch {
            self.error = .createCaptureInput(error)
            return
        }
    }
    
    func stop() {
        sessionQueue.async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
}

@available(macOS 11.0, iOS 14.0, *)
extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.frame = cgImage
        }
    }
}

// Only implement the delegate method for macOS 13.0 or newer
#if os(macOS)
@available(macOS 13.0, iOS 14.0, *)
extension CameraService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            DispatchQueue.main.async { [weak self] in
                self?.qrCodeValue = stringValue
            }
        }
    }
}
#else
@available(macOS 11.0, iOS 14.0, *)
extension CameraService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            DispatchQueue.main.async { [weak self] in
                self?.qrCodeValue = stringValue
            }
        }
    }
}
#endif 