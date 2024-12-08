import UIKit
import AVKit

class TestViewController: UIViewController {

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let videoView = UIView() // Video oynatıcı için bir UIView oluştur

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupVideoView()
        playVideo()
        
        
    }

    private func setupVideoView() {
        // Video görüntüsü için bir UIView ayarlayın
        videoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoView)
        
        // Video görünümüne kısıtlamalar ekleyin
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.topAnchor.constraint(equalTo: view.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func playVideo() {
        // Video URL'si
        
//        https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
        guard let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else {
            print("Geçersiz URL")
            return
        }
        
        // AVPlayer ve AVPlayerLayer oluştur
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        
        // playerLayer'ı videoView'e ekle
        guard let playerLayer = playerLayer else { return }
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer)
        
        // Videoyu oynat
        player?.play()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // playerLayer boyutlarını güncelle
        playerLayer?.frame = videoView.bounds
    }
}
