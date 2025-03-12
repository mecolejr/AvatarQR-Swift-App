import SwiftUI

extension Image {
    init(cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation, label: Text) {
        self.init(cgImage, scale: scale, orientation: orientation, label: label)
    }
}

#if canImport(UIKit)
import UIKit

extension UIImage {
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, scale: 1.0, orientation: .up)
    }
}
#endif 