import XCTest
@testable import Learn_Connect

final class DownloadVideoHelperTests: XCTestCase {
    var downloadHelper: DownloadVideoHelper!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        downloadHelper = DownloadVideoHelper()
    }

    override func tearDown() {
        downloadHelper = nil
        mockSession = nil
        super.tearDown()
    }

    func testDownloadVideoSuccess() {
        // Test için bir URL ve videoID
        let testURL = URL(string: "https://example.com/test.mp4")!
        let videoID = "12345"

        let expectation = self.expectation(description: "Completion handler called")

        downloadHelper.onCompletion = { result in
            XCTAssertEqual(result, "success", "Completion handler should return 'success'")
            expectation.fulfill()
        }

        downloadHelper.downloadVideo(url: testURL, videoID: videoID) {
            // Completion block çağrılmalı
            expectation.fulfill()
        }

        // Simüle edilen indirme tamamlandı
        mockSession.simulateDownloadSuccess(for: testURL)

        wait(for: [expectation], timeout: 5.0)
    }

    func testProgressUpdate() {
        let testURL = URL(string: "https://example.com/test.mp4")!
        let videoID = "12345"

        downloadHelper.downloadVideo(url: testURL, videoID: videoID) {}

        // Simüle edilen ilerleme güncellemesi
        let totalBytesWritten: Int64 = 50
        let totalBytesExpectedToWrite: Int64 = 100

        downloadHelper.urlSession(mockSession, downloadTask: URLSessionDownloadTask(), didWriteData: totalBytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)

        XCTAssertEqual(downloadHelper.progress, 0.5, "Progress should be updated correctly")
    }
}
final class MockURLSession: URLSession {
    var mockDelegate: URLSessionDelegate? // Stored property olarak yeni bir delegate tanımı
    override var delegate: URLSessionDelegate? {
        return mockDelegate
    }

    func simulateDownloadSuccess(for url: URL) {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(url.lastPathComponent)
        try? Data("Mock data".utf8).write(to: tempURL)

        if let delegate = delegate as? URLSessionDownloadDelegate {
            delegate.urlSession(self, downloadTask: MockURLSessionDownloadTask(), didFinishDownloadingTo: tempURL)
        }
    }

    override func downloadTask(with url: URL) -> URLSessionDownloadTask {
        return MockURLSessionDownloadTask()
    }
}


final class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {
        // Mock DataTask için hiçbir şey yapılmaz.
    }
}

final class MockURLSessionDownloadTask: URLSessionDownloadTask {
    override func resume() {
        // Mock DownloadTask için hiçbir şey yapılmaz.
    }
}
