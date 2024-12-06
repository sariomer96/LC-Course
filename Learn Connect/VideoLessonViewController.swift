import UIKit

class VideoLessonViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private var currentViewController: UIViewController?
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
            super.viewDidLoad()
        switchToSegment(index: 0, animated: false)
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

 

