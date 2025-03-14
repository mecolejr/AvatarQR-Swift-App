import XCTest
@testable import AvatarQRLib

@available(macOS 10.15, iOS 13.0, *)
final class AvatarViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "savedAvatars")
    }
    
    func testAvatarViewModelInitialization() {
        let viewModel = AvatarViewModel()
        
        // Test that the view model initializes with a default avatar
        XCTAssertNotNil(viewModel.avatar)
        
        // Test that saved avatars array starts empty
        XCTAssertEqual(viewModel.savedAvatars.count, 0)
    }
    
    func testSaveAvatar() {
        let viewModel = AvatarViewModel()
        
        // Save the default avatar
        viewModel.saveAvatar()
        
        // Test that the avatar was saved
        XCTAssertEqual(viewModel.savedAvatars.count, 1)
        
        // Test that the saved avatar has the same properties as the current avatar
        if let savedAvatar = viewModel.savedAvatars.first {
            XCTAssertEqual(savedAvatar.name, viewModel.avatar.name)
            XCTAssertEqual(savedAvatar.hairStyle, viewModel.avatar.hairStyle)
            XCTAssertEqual(savedAvatar.hairColor, viewModel.avatar.hairColor)
        } else {
            XCTFail("No avatar was saved")
        }
    }
    
    func testDeleteAvatar() {
        let viewModel = AvatarViewModel()
        
        // Save the default avatar
        viewModel.saveAvatar()
        
        // Make sure we have one avatar
        XCTAssertEqual(viewModel.savedAvatars.count, 1)
        
        // Delete the avatar
        if let savedAvatar = viewModel.savedAvatars.first {
            viewModel.deleteAvatar(savedAvatar)
            
            // Test that the avatar was deleted
            XCTAssertEqual(viewModel.savedAvatars.count, 0)
        } else {
            XCTFail("No avatar was saved")
        }
    }
    
    static var allTests = [
        ("testAvatarViewModelInitialization", testAvatarViewModelInitialization),
        ("testSaveAvatar", testSaveAvatar),
        ("testDeleteAvatar", testDeleteAvatar)
    ]
} 