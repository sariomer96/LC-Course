import UIKit
import AVKit
import AVFoundation

class VideoLessonViewController: UIViewController {

    @IBOutlet weak var videoHeight: NSLayoutConstraint!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private var currentViewController: UIViewController?
    private var playerViewController: AVPlayerViewController?
       var downloadViewModel = DownloadViewModel()
    
   
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
            super.viewDidLoad()
        switchToSegment(index: 0, animated: false)
//        DatabaseManager.shared
 
  
        startDownloading()
   
//        print(downloadViewModel.progress * 100)
  
    }
//    
    
    
    let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
       private var player: AVPlayer?
       private var playerLayer: AVPlayerLayer?
 
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
//           self.setupVideoPlayer()
       }
       
   
    // İndirme işlemini başlat
        func startDownloading() {
         
            if let url = URL(string: videoURL) {
                downloadViewModel.downloadVideo(url: url, videoID: "12334")
                           }
           
        }
   
   
    
       private func updatePlayerFrame() {
           self.playerLayer?.frame = self.videoView.bounds
       }
       
       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           self.updatePlayerFrame()
       }
    
    func playVideo(from url: URL) {
           let player = AVPlayer(url: url)
           let playerViewController = AVPlayerViewController()
           playerViewController.player = player
           present(playerViewController, animated: true) {
               player.play()
           }
       }
    
    
   
    
    private func setupVideoPlayer(videoURL:String) {
        guard let url = URL(string: videoURL) else { return }
        
        self.player = AVPlayer(url: url)
        self.playerViewController = AVPlayerViewController()
        self.playerViewController?.player = self.player
        
        // Ekleniyor: videoView üzerine AVPlayerViewController'ı bindiriyoruz
        if let playerViewController = self.playerViewController {
            playerViewController.view.frame = videoView.bounds
            playerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.videoView.addSubview(playerViewController.view)
            self.addChild(playerViewController)
            playerViewController.didMove(toParent: self)
        }
    }

  
    
   
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switchToSegment(index: sender.selectedSegmentIndex, animated: true)

    }
    private func switchToSegment(index: Int, animated: Bool) {
          let selectedViewController: UIViewController
          switch index {
          case 0:
              selectedViewController = firstViewController
          case 1:
              selectedViewController = secondViewController
          default:
              return
          }
          
          // Aynı ViewController ise değişim yapma
          guard selectedViewController != currentViewController else { return }
          
          // Geçerli ViewController'ı kaldır
          if let currentVC = currentViewController {
              currentVC.willMove(toParent: nil)
              if animated {
                  UIView.transition(with: bottomView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                      currentVC.view.removeFromSuperview()
                  }) { _ in
                      currentVC.removeFromParent()
                  }
              } else {
                  currentVC.view.removeFromSuperview()
                  currentVC.removeFromParent()
              }
          }
          
          // Yeni ViewController'ı ekle
          addChild(selectedViewController)
          selectedViewController.view.frame = bottomView.bounds
          selectedViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          
          if animated {
              UIView.transition(with: bottomView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                  self.bottomView.addSubview(selectedViewController.view)
              }) { _ in
                  selectedViewController.didMove(toParent: self)
              }
          } else {
              bottomView.addSubview(selectedViewController.view)
              selectedViewController.didMove(toParent: self)
          }
          
          // Geçerli ViewController'ı güncelle
          currentViewController = selectedViewController
      }
    
    
    
    private lazy var firstViewController: UIViewController = {
           storyboard?.instantiateViewController(withIdentifier: "FirstSegmentViewController") as! FirstSegmentViewController
       }()
       
       private lazy var secondViewController: UIViewController = {
           storyboard?.instantiateViewController(withIdentifier: "SecondSegmentViewController") as! SecondSegmentViewController
       }()
   
}

 

 
