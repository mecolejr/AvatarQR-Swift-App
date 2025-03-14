import XCTest
@testable import AvatarQRLib
import CoreImage

@available(macOS 11.0, iOS 14.0, *)
final class QRScannerServiceTests: XCTestCase {
    func testQRCodeGeneration() {
        // This test will verify that we can generate a QR code from a string
        let testString = "https://example.com"
        
        // Create a QR code image
        guard let qrCodeImage = generateQRCode(from: testString) else {
            XCTFail("Failed to generate QR code")
            return
        }
        
        // Verify the QR code image was created
        XCTAssertNotNil(qrCodeImage)
    }
    
    // Helper function to generate a QR code
    private func generateQRCode(from string: String) -> CGImage? {
        let data = string.data(using: .utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return cgImage
    }
    
    static var allTests = [
        ("testQRCodeGeneration", testQRCodeGeneration)
    ]
} 