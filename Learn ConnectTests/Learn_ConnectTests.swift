//
import XCTest
 
import Foundation

@testable import Learn_Connect

final class MockDatabaseManager: DatabaseManager {
    var shouldLoginSucceed = false
    var providedEmail: String?
    var providedPassword: String?

    override init() {
        super.init()  
    }

    override func loginUser(email: String, password: String, isSuccess: @escaping (Bool) -> ()) {
        providedEmail = email
        providedPassword = password
        isSuccess(shouldLoginSucceed)
    }
}

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockDatabaseManager: MockDatabaseManager!

    override func setUp() {
        super.setUp()
        mockDatabaseManager = MockDatabaseManager()
        viewModel = LoginViewModel()
    }

    override func tearDown() {
        viewModel = nil
        mockDatabaseManager = nil
        super.tearDown()
    }

    func testLogin_Successful() {
        // Mock başarıyı döndürecek şekilde ayarlanır
        mockDatabaseManager.shouldLoginSucceed = true

        let email = "test@example.com"
        let password = "hashedPassword"

        // Giriş başarılı mı kontrol et
        let expectation = self.expectation(description: "Login should succeed")
        viewModel.login(email: email, password: password) { isSuccess in
            XCTAssertTrue(isSuccess, "Login should succeed with correct credentials")
            XCTAssertEqual(self.mockDatabaseManager.providedEmail, email, "Email should be passed correctly")
            XCTAssertEqual(self.mockDatabaseManager.providedPassword, password, "Password should be passed correctly")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testLogin_Failure() {
        // Mock başarısızlığı döndürecek şekilde ayarlanır
        mockDatabaseManager.shouldLoginSucceed = false

        let email = "wrong@example.com"
        let password = "wrongPassword"

        // Giriş başarısız mı kontrol et
        let expectation = self.expectation(description: "Login should fail")
        viewModel.login(email: email, password: password) { isSuccess in
            XCTAssertFalse(isSuccess, "Login should fail with incorrect credentials")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

final class LoginViewControllerTests: XCTestCase {
    var viewController: LoginViewController!
    var mockViewModel: MockLoginViewModel!

    override func setUp() {
        super.setUp()
        // Storyboard üzerinden ViewController oluştur
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        mockViewModel = MockLoginViewModel()
        viewController.loadViewIfNeeded()
    }

    func testLoginClicked_Success() {
        mockViewModel.shouldLoginSucceed = true
        viewController.emailTF.text = "test@example.com"
        viewController.passwordTF.text = "password"

        viewController.loginClicked(self)

        XCTAssertTrue(mockViewModel.didCallLogin, "Login method should be called")
    }

    func testLoginClicked_Failure() {
        mockViewModel.shouldLoginSucceed = false
        viewController.emailTF.text = "wrong@example.com"
        viewController.passwordTF.text = "wrongPassword"

        viewController.loginClicked(self)

        XCTAssertTrue(mockViewModel.didCallLogin, "Login method should be called")
    }
}
