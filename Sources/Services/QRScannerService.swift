import Foundation
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif
import Vision
import CoreImage
import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
class QRScannerService {
    static func scanQRCode(from image: CGImage, completion: @escaping (String?) -> Void) {
        let request = VNDetectBarcodesRequest { request, error in
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let results = request.results as? [VNBarcodeObservation], !results.isEmpty else {
                // Try legacy method if Vision framework doesn't find anything
                let legacyResult = scanQRCodeLegacy(from: image)
                completion(legacyResult)
                return
            }
            
            if let payloadString = results.first?.payloadStringValue {
                completion(payloadString)
            } else {
                completion(nil)
            }
        }
        
        request.symbologies = [.qr]
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Error scanning QR code: \(error)")
            // Try legacy method if Vision framework fails
            let legacyResult = scanQRCodeLegacy(from: image)
            completion(legacyResult)
        }
    }
    
    #if canImport(UIKit)
    static func generateQRCode(from string: String, size: CGSize) -> UIImage? {
        guard let data = string.data(using: .utf8) else { return nil }
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            
            guard let outputImage = filter.outputImage else { return nil }
            
            let scaleX = size.width / outputImage.extent.width
            let scaleY = size.height / outputImage.extent.height
            
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, scaleY: scaleY))
            
            if let cgImage = CIContext().createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return nil
    }
    #elseif canImport(AppKit)
    static func generateQRCode(from string: String, size: CGSize) -> NSImage? {
        guard let data = string.data(using: .utf8) else { return nil }
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            
            guard let outputImage = filter.outputImage else { return nil }
            
            let scaleX = size.width / outputImage.extent.width
            let scaleY = size.height / outputImage.extent.height
            
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            
            let rep = NSCIImageRep(ciImage: scaledImage)
            let nsImage = NSImage(size: rep.size)
            nsImage.addRepresentation(rep)
            return nsImage
        }
        
        return nil
    }
    #endif
    
    // Alternative implementation for older macOS versions using CIFilter
    static func scanQRCodeLegacy(from cgImage: CGImage) -> String? {
        let ciImage = CIImage(cgImage: cgImage)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        guard let features = detector?.features(in: ciImage) as? [CIQRCodeFeature], !features.isEmpty else {
            return nil
        }
        
        return features.first?.messageString
    }
} 