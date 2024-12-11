
final class MockLoginViewModel: LoginViewModel {
    var didCallLogin = false
    var shouldLoginSucceed = false

    override func login(email: String, password: String, success: @escaping (Bool) -> ()) {
        didCallLogin = true
        success(shouldLoginSucceed)
    }
}
