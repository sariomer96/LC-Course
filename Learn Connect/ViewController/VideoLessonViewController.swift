import UIKit
import AVKit
import AVFoundation

class VideoLessonViewController: UIViewController {

    @IBOutlet weak var videoHeight: NSLayoutConstraint!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private var currentViewController: UIViewController?
    private var playerViewController: AVPlayerViewController?
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
            super.viewDidLoad()
        switchToSegment(index: 0, animated: false)
//        DatabaseManager.shared
     
        }
//    
    
    let videoURL = "https://uc5a4c65c7607710ae85e86abec6.dl.dropboxusercontent.com/cd/0/inline/Cf0EhHCvWT_pSRIXuBATC83WTwJy5-9RXb4pTxB2lBjPtGYdx-cXuPqREMoph4xCLUFhU6JsjAz_H8u6TnY6m32JyKax4oFkHt6vsRX8zSl6xIri05LydT1AvLJOnxsyPfxJdDIzoKSCh9SIYqrYhEmv/file#"
       private var player: AVPlayer?
       private var playerLayer: AVPlayerLayer?
 
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           self.setupVideoPlayer()
       }
       
   
       private func updatePlayerFrame() {
           self.playerLayer?.frame = self.videoView.bounds
       }
       
       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           self.updatePlayerFrame()
       }
       
    
   
    
    private func setupVideoPlayer() {
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

 

 
