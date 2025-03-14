import XCTest
@testable import AvatarQRLib

@available(macOS 11.0, iOS 14.0, *)
final class AvatarTests: XCTestCase {
    func testAvatarCreation() {
        // Create a default avatar
        let avatar = Avatar()
        
        // Test default values
        XCTAssertEqual(avatar.name, "My Avatar")
        XCTAssertEqual(avatar.hairStyle, .short)
        XCTAssertEqual(avatar.hairColor, .black)
        XCTAssertEqual(avatar.skinTone, .tan)
        XCTAssertEqual(avatar.eyeColor, .blue)
        XCTAssertEqual(avatar.facialFeature, .smile)
        XCTAssertEqual(avatar.accessory, .none)
        XCTAssertEqual(avatar.accessoryColor, .red)
        XCTAssertEqual(avatar.backgroundColor, .lightBlue)
    }
    
    func testAvatarEquality() {
        // Create two avatars with the same ID
        var avatar1 = Avatar()
        var avatar2 = Avatar()
        
        // They should not be equal initially (different IDs)
        XCTAssertNotEqual(avatar1, avatar2)
        
        // Make them have the same ID
        avatar2.id = avatar1.id
        
        // Now they should be equal
        XCTAssertEqual(avatar1, avatar2)
    }
    
    func testAvatarColorDisplay() {
        // Test that color display names are correct
        XCTAssertEqual(AvatarColor.red.displayName, "Red")
        XCTAssertEqual(AvatarColor.lightBlue.displayName, "Light Blue")
    }
    
    static var allTests = [
        ("testAvatarCreation", testAvatarCreation),
        ("testAvatarEquality", testAvatarEquality),
        ("testAvatarColorDisplay", testAvatarColorDisplay)
    ]
} 