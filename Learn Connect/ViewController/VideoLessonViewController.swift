import UIKit
import AVKit
import AVFoundation

class VideoLessonViewController: UIViewController {

    @IBOutlet weak var videoHeight: NSLayoutConstraint!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomView: UIView!

    private var currentViewController: UIViewController?
    private var playerViewController: AVPlayerViewController?
    private var player: AVPlayer?
    private var timeObserverToken: Any?

    var downloadViewModel = DownloadVideoHelper()
    var videoLessonViewModel = VideoLessonViewModel()
    let userDefaults = UserDefaults.standard
    var videoUrl:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        switchToSegment(index: 0, animated: false)
 
        downloadViewModel.onCompletion = { url in
            self.videoUrl = url
            print("ZAAAA")
            let u = url!
            print("\(u) AFADGADHAH ")
            self.setupVideoPlayer(videoURL: u)
            print("\(self.videoUrl) AAAAAAA")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
          print("afds")
        if videoLessonViewModel.isDownloaded == true {
            print("trueee")
            let id = videoLessonViewModel.myCourse?.videoId
            
            let strId = String(id!)
           let url =  DownloadVideoHelper().playVideoByFileName(fileName: "\(strId).mp4" )
              setupVideoPlayer(videoURL: url)
             
        }else {
            if let videoUrl = videoLessonViewModel.myCourse?.videoUrl {
                setupVideoPlayer(videoURL: videoUrl)
            }

        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePlayerFrame()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentTime = player?.currentTime() {
            let seconds = CMTimeGetSeconds(currentTime)
            userDefaults.set(seconds, forKey: "\(videoLessonViewModel.myCourse?.videoId!)_lastPosition")
        }
    }

    private func updatePlayerFrame() {
        playerViewController?.view.frame = videoView.bounds
    }

    private func setupVideoPlayer(videoURL: String) {
        removePeriodicTimeObserver()
        player = nil

        guard let url = URL(string: videoURL) else {
            print("Invalid video URL: \(videoURL)")
            return
        }

        player = AVPlayer(url: url)
        guard let player = player else { return }

        playerViewController = AVPlayerViewController()
        guard let playerViewController = playerViewController else { return }
        playerViewController.player = player

        let lastSavedTime = userDefaults.double(forKey: "\(videoLessonViewModel.myCourse?.videoId!)_lastPosition")
        if lastSavedTime > 0 {
            let seekTime = CMTime(seconds: lastSavedTime, preferredTimescale: 1)
            player.seek(to: seekTime)
        }

        addPeriodicTimeObserver()

        guard let videoView = videoView else { return }
        playerViewController.view.frame = videoView.bounds
        videoView.addSubview(playerViewController.view)
        self.addChild(playerViewController)
        playerViewController.didMove(toParent: self)
    }

    private func removePeriodicTimeObserver() {
        if let token = timeObserverToken, let player = player {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }

    private func addPeriodicTimeObserver() {
        guard let player = player else { return }
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            let currentTime = CMTimeGetSeconds(time)
            self.userDefaults.set(currentTime, forKey: "\(videoLessonViewModel.myCourse?.videoId!)_lastPosition")
        }
    }

    func startDownloadingVideoAndImage() {
        guard let course = videoLessonViewModel.myCourse,
              let videoUrlString = course.videoUrl,
              let videoUrl = URL(string: videoUrlString),
              let imageUrlString = course.imageUrl else {
            print("Geçersiz video veya resim URL'si")
            return
        }

        let group = DispatchGroup()
        showToast(message: "İndiriliyor...")

        let videoId = String(course.videoId ?? 0)
        var downloadedImage: UIImage?

        group.enter()
        downloadViewModel.downloadVideo(url: videoUrl, videoID: videoId) {
            group.leave()
        }

        group.enter()
        downloadImage(with: imageUrlString) { image in
            downloadedImage = image
            group.leave()
        }

        group.notify(queue: .main) {
            guard let userId = UserProfile.shared.user?.id, let image = downloadedImage else {
                print("Video veya resim kaydedilemedi.")
                return
            }

            DatabaseManager.shared.insertToDownloadsTable(userId: String(userId),
                                                          videoId: videoId,
                                                          title: course.title ?? "Başlık Yok",
                                                          image: image)

            self.showToast(message: "İndirme tamamlandı!")
        }
    }

    func downloadImage(with urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
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

        guard selectedViewController != currentViewController else { return }

        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        addChild(selectedViewController)
        selectedViewController.view.frame = bottomView.bounds
        bottomView.addSubview(selectedViewController.view)
        selectedViewController.didMove(toParent: self)

        currentViewController = selectedViewController
    }

    private lazy var firstViewController: VideoPlayListViewController = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoPlayListViewController") as! VideoPlayListViewController
        vc.videoPlayListViewModel.setMyCourse(myCourse: videoLessonViewModel.myCourse!)
        vc.delegate = self
        return vc
    }()

    private lazy var secondViewController: UIViewController = {
        storyboard?.instantiateViewController(withIdentifier: "SecondSegmentViewController") as! SecondSegmentViewController
    }()
}

extension VideoLessonViewController: VideoPlayListDelegate {
    func didSelectVideo(at index: Int) {
        startPlayingVideo(at: index)
    }

    func startPlayingVideo(at index: Int) {
        guard let course = videoLessonViewModel.myCourse,
              let videoURL = course.videoUrl else { return }

        setupVideoPlayer(videoURL: videoURL)
    }
}
