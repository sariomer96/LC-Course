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
    let userDefaults = UserDefaults.standard
    private var timeObserverToken: Any? // Gözlemci referansı
     var videoId = "aa"
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        switchToSegment(index: 0, animated: false)
        
        setupVideoPlayer(videoURL:videoURL)
        
        
        
        //        downloadViewModel.playVideoByFileName(fileName: "aga.mp4")
        //        downloadViewModel.onCompletion = { url in
        //              self.setupVideoPlayer(videoURL: "\(url)")
        //        }
        
         
    }
  
    
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
                downloadViewModel.downloadVideo(url: url, videoID: "aga")
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
    
    
    private func setupVideoPlayer(videoURL: String) {
        // Validate the video URL
        guard let url = URL(string: videoURL) else {
            print("Invalid video URL: \(videoURL)")
            return
        }

        // Initialize AVPlayer
        self.player = AVPlayer(url: url)
        guard let player = self.player else {
            print("Failed to initialize AVPlayer.")
            return
        }

        // Initialize AVPlayerViewController
        self.playerViewController = AVPlayerViewController()
        guard let playerViewController = self.playerViewController else {
            print("Failed to initialize AVPlayerViewController.")
            return
        }

        // Assign the AVPlayer to the AVPlayerViewController
        playerViewController.player = player
        let lastSavedTime = userDefaults.double(forKey: "\(videoId)_lastPosition")
        
        if lastSavedTime > 0 {
                 let seekTime = CMTime(seconds: lastSavedTime, preferredTimescale: 1)
            playerViewController.player!.seek(to: seekTime)
             }
        
        removePeriodicTimeObserver()
              
              // Yeni observer ekle
              addPeriodicTimeObserver()
        
        // Check if videoView is available and valid
        guard let videoView = self.videoView else {
            print("Video view is nil or not available.")
            return
        }

        // Add AVPlayerViewController's view to videoView
        playerViewController.view.frame = videoView.bounds
        playerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        videoView.addSubview(playerViewController.view)

        // Ensure that the playerViewController is added as a child view controller
        self.addChild(playerViewController)
        playerViewController.didMove(toParent: self)
 
    }
    
    func removePeriodicTimeObserver() {
         if let token = timeObserverToken {
             playerViewController?.player?.removeTimeObserver(token)
             timeObserverToken = nil
         }
     }
    
    func addPeriodicTimeObserver() {
         let interval = CMTime(seconds: 1, preferredTimescale: 1)
        player!.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
             guard let self = self else { return }
             let currentTime = CMTimeGetSeconds(time)
             self.userDefaults.set(currentTime, forKey: "\(self.videoId)_lastPosition")
         }
     }
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
          
         if let currentTime = player?.currentTime() {
             let seconds = CMTimeGetSeconds(currentTime)
             userDefaults.set(seconds, forKey: "\(self.videoId)_lastPosition")
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

 

 
