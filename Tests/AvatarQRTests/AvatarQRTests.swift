import XCTest
@testable import AvatarQRLib

@available(macOS 11.0, iOS 14.0, *)
final class AvatarQRTests: XCTestCase {
    func testAvatarCreation() {
        // Test that an avatar can be created with default values
        let avatar = Avatar()
        XCTAssertEqual(avatar.name, "My Avatar")
        XCTAssertEqual(avatar.skinTone, .tan)
        XCTAssertEqual(avatar.hairStyle, .short)
        XCTAssertEqual(avatar.hairColor, .black)
        XCTAssertEqual(avatar.eyeColor, .blue)
        XCTAssertEqual(avatar.facialFeature, .smile)
        XCTAssertEqual(avatar.accessory, .none)
        XCTAssertEqual(avatar.accessoryColor, .red)
        XCTAssertEqual(avatar.backgroundColor, .lightBlue)
    }
    
    func testAvatarCustomization() {
        // Test that an avatar can be customized
        var avatar = Avatar()
        avatar.name = "Custom Avatar"
        avatar.skinTone = .tan
        avatar.hairStyle = .long
        avatar.hairColor = .red
        avatar.eyeColor = .blue
        avatar.facialFeature = .glasses
        avatar.accessory = .hat
        avatar.accessoryColor = .purple
        avatar.backgroundColor = .purple
        
        XCTAssertEqual(avatar.name, "Custom Avatar")
        XCTAssertEqual(avatar.skinTone, .tan)
        XCTAssertEqual(avatar.hairStyle, .long)
        XCTAssertEqual(avatar.hairColor, .red)
        XCTAssertEqual(avatar.eyeColor, .blue)
        XCTAssertEqual(avatar.facialFeature, .glasses)
        XCTAssertEqual(avatar.accessory, .hat)
        XCTAssertEqual(avatar.accessoryColor, .purple)
        XCTAssertEqual(avatar.backgroundColor, .purple)
    }
    
    static var allTests = [
        ("testAvatarCreation", testAvatarCreation),
        ("testAvatarCustomization", testAvatarCustomization),
    ]
} 