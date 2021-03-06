//
//  HomeController.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/7/20.
//

import UIKit
import iCarousel

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, iCarouselDataSource {
    
    
    // --------------- OUTLETS & VARIABLES ---------------
    
    // object for songs
    struct songInfo {
        var Title:String?
        var Artist:String?
        var id:String?
        var BPM:String?
        var imageURL:String?
        var artistImage:UIImage?
    }

    
    // home page
    @IBOutlet weak var navBar: UILabel!
    @IBOutlet weak var featured: UILabel!
    @IBOutlet weak var first_recomm: UILabel!
    @IBOutlet weak var second_recomm: UILabel!
    @IBOutlet weak var third_recomm: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topLogo: UIImageView!
    @IBOutlet weak var topSplitBar: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    let featCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .coverFlow
        return view
    }()
    var users_name: String?
    var users_email: String?
    var users_password_count:Int?
    
    
    // for recommended panels (in home page)
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var moderateLabel: UILabel!
    @IBOutlet weak var slowLabel: UILabel!
    @IBOutlet weak var upbeatLabel: UILabel!
    @IBOutlet weak var upbeat_slide: UICollectionView!
    @IBOutlet weak var upbeat_pageCtrl: UIPageControl!
    @IBOutlet weak var slow_slide: UICollectionView!
    @IBOutlet weak var slow_pageCtrl: UIPageControl!
    @IBOutlet weak var moderate_slide: UICollectionView!
    @IBOutlet weak var moderate_pageCtrl: UIPageControl!
    @IBOutlet weak var recommendedTable: UITableView!
    @IBOutlet weak var upbeatButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var moderateButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var recSongDetails: UIView!
    @IBOutlet weak var recSongImage: UIImageView!
    @IBOutlet weak var recSongTitle: UILabel!
    @IBOutlet weak var recSongArtist: UILabel!
    @IBOutlet weak var recSongBPM: UILabel!
    @IBOutlet weak var recSongCancelButton: UIButton!
    @IBOutlet weak var recommendedView: UIView!
    @IBOutlet weak var recLoading: UIActivityIndicatorView!
    @IBOutlet weak var spotifyButton: UIButton!
    @IBOutlet weak var appleMusicButton: UIButton!
    @IBOutlet weak var selectedPlaylistLabel: UILabel!
    // for details dismissal
    @IBOutlet weak var temporaryView: UIView!
    @IBOutlet weak var tempRecDetailCancel: UIButton!
    var timer: Timer?
    var currentIndex = 0
    var currentIndex_upbeat = 0
    var slowRandBPMs = [Int](repeating: 0, count: 30)
    var slowPacedList = [songInfo?]()
    var moderateRandBPMs = [Int](repeating: 0, count: 30)
    var moderateList = [songInfo?]()
    var upbeatRandBPMs = [Int](repeating: 0, count: 30)
    var upbeatList = [songInfo?]()
    var selectedRange:String = ""
    var recommendedTableCount:Int = 0
    var recommendedList = [songInfo?]()
    var getSongFromWhere:String = ""
    var onRecommended:Bool = false
    
    
    // search page
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var songTable: UITableView!
    var songListCount:Int = 0
    var songList = [songInfo?]()
    @IBOutlet weak var songDetailsView: UIView!
    @IBOutlet weak var songDetailTitle: UILabel!
    @IBOutlet weak var songDetailArtist: UILabel!
    @IBOutlet weak var songDetailBPM: UILabel!
    @IBOutlet weak var songDetailImage: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    // for details dismissal
    @IBOutlet weak var tempColorBlock: UIView!
    @IBOutlet weak var tempSearchView: UIView!
    @IBOutlet weak var tempSearchDetailCancel: UIButton!
    
    
    // saved page
    @IBOutlet weak var savedView: UIView!
    @IBOutlet weak var savedTable: UITableView!
    @IBOutlet weak var savedIcon: UIImageView!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var noSongsLabel: UILabel!
    @IBOutlet weak var savedDetailsView: UIView!
    @IBOutlet weak var savedSongImg: UIImageView!
    @IBOutlet weak var savedTitle: UILabel!
    @IBOutlet weak var savedArtist: UILabel!
    @IBOutlet weak var savedBPM: UILabel!
    @IBOutlet weak var tempSavedView: UIView!
    
    
    // heartRate page
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var musicIcon: UIImageView!
    @IBOutlet weak var leftWaveIcon: UIImageView!
    @IBOutlet weak var rightWaveIcon: UIImageView!
    @IBOutlet weak var heartRateButton: UIButton!
    @IBOutlet weak var heartRateView: UIView!
    @IBOutlet weak var BPMtable: UITableView!
    @IBOutlet weak var tempBPMview: UIView!
    @IBOutlet weak var BPMdetailsView: UIView!
    @IBOutlet weak var BPMimage: UIImageView!
    @IBOutlet weak var BPMtitle: UILabel!
    @IBOutlet weak var BPMartist: UILabel!
    @IBOutlet weak var BPMlabel: UILabel!
    @IBOutlet weak var suggestedLoading: UIActivityIndicatorView!
    @IBOutlet weak var heartRateLabel: UILabel!
    var BPMtableCount:Int = 0
    var firstBPMcalculation:Bool = true
    
    
    // profile page
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var editProfilePicButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var editUsernameField: UITextField!
    @IBOutlet weak var editNameField: UITextField!
    @IBOutlet weak var editEmailField: UITextField!
    @IBOutlet weak var editPasswordField: UITextField!
    @IBOutlet weak var editConfirmField: UITextField!
    @IBOutlet weak var editErrorMessage: UILabel!
    var didChangePic:Bool = false
    var choseFromLibrary:Bool = false
    
    
    // image data for each recommended panel
    var slowImages = [UIImage(named:"antidote_travis_scott_66bpm") ,
                      UIImage(named:"congratulations_mac_miller_57bpm") ,
                      UIImage(named:"perfect_ed_sheeran_63bpm") ,
                      UIImage(named:"sign_of_the_times_harry_styles_60bpm") ,
                      UIImage(named:"something_just_like_this_chainsmokers_51bpm") ,
                      UIImage(named:"xanny_billie_eilish_50bpm") ]
    
    var moderateImages = [UIImage(named:"ariana-7-rings_70bpm") ,
                          UIImage(named:"humble_kendrick_lamar_76bpm") ,
                          UIImage(named:"lonely_justin_bieber_79bpm") ,
                          UIImage(named:"redbone_childish_gambino_81bpm") ,
                          UIImage(named:"watermelon_sugar_harry_styles_95bpm") ,
                          UIImage(named:"you-need-to-calm-down_taylor-swift_85bpm") ]
    
    var fastImages = [UIImage(named:"bad_and_boujee_migos_129bpm") ,
                      UIImage(named:"blinding_lights_weeknd_172bpm") ,
                      UIImage(named:"dangerous-woman_ariana-grande_136bpm") ,
                      UIImage(named:"dont_start_now_dua_lipa_123bpm") ,
                      UIImage(named:"laugh_now_cry_later_drake_133bpm") ,
                      UIImage(named:"power_kanye_west_152bpm") ,
                      UIImage(named:"thunder_imagine_dragons_166bpm") ]

    var featImages = [UIImage(named: "juice-wrld-ellie-goulding") ,
                      UIImage(named: "mac_miller") ,
                      UIImage(named: "khalid") ,
                      UIImage(named: "lana") ,
                      UIImage(named: "billie") ,
                      UIImage(named: "alicia_keys") ]
    
    
    
    
    
    // --------------- VIEW DID LOAD ---------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // welcome username label
        welcomeLabel.text = "Hi, \(users_name!)"
        welcomeLabel.textColor = .lightGray
        
        // navigation menu bar
        navBar.backgroundColor = .lightGray
        navBar.text = ""
        
        // featured panel attributes
        featured.layer.borderColor = UIColor.lightGray.cgColor
        featured.layer.borderWidth = 1.0
        featured.layer.cornerRadius = 5
        scrollView.addSubview(featCarousel)
        featCarousel.dataSource = self
        featCarousel.layer.cornerRadius = 5
        featCarousel.frame = CGRect(x: 7, y: 80, width: self.view.frame.width/1.05, height: 225)
        featCarousel.bounceDistance = 0.25
        featCarousel.currentItemIndex = 2
   
        
        // recommended table
        recommendedTable.delegate = self
        recommendedTable.dataSource = self
        recommendedTable.rowHeight = 65
        self.recommendedTable.tableFooterView = UIView()
        recommendedLabel.textColor = .lightGray
        moderateLabel.textColor = .lightGray
        slowLabel.textColor = .lightGray
        upbeatLabel.textColor = .lightGray
        recLoading.color = .lightGray
        recLoading.startAnimating()
        tempColorBlock.layer.cornerRadius = 5
        recSongImage.layer.cornerRadius = 5
        recSongDetails.layer.cornerRadius = 5
        recSongDetails.layer.shadowColor = UIColor.black.cgColor
        recSongDetails.layer.shadowOpacity = 1
        recSongDetails.layer.shadowOffset = .zero
        recSongDetails.layer.shadowRadius = 10
        recSongDetails.layer.shadowPath = UIBezierPath(rect: recSongDetails.bounds).cgPath
        recSongDetails.layer.shouldRasterize = true
        
        // upbeat panel attributes
        first_recomm.layer.borderColor = UIColor.lightGray.cgColor
        first_recomm.layer.borderWidth = 1.0
        first_recomm.layer.cornerRadius = 5
        upbeat_slide.layer.cornerRadius = 5
        upbeat_slide.delegate = self
        upbeat_slide.dataSource = self
        upbeat_pageCtrl.numberOfPages = fastImages.count
        var fastBPMsgenerated:[Int] = []
        // fill upbeat BPM's array with random #'s [161, 220]
        for i in 0...29 {
            upbeatRandBPMs[i] = Int.random(in: 161...220)
            while (fastBPMsgenerated.contains(upbeatRandBPMs[i])) {
                upbeatRandBPMs[i] = Int.random(in: 161...220)
            }
            fastBPMsgenerated.append(upbeatRandBPMs[i])
        }
        
        // slow-paced panel attributes
        second_recomm.layer.borderColor = UIColor.lightGray.cgColor
        second_recomm.layer.borderWidth = 1.0
        second_recomm.layer.cornerRadius = 5
        slow_slide.layer.cornerRadius = 5
        slow_slide.delegate = self
        slow_slide.dataSource = self
        slow_pageCtrl.numberOfPages = slowImages.count
        var slowBPMsgenerated:[Int] = []
        // fill slow BPM's array with random #'s [40, 100]
        for i in 0...29 {
            slowRandBPMs[i] = Int.random(in: 40...100)
            while (slowBPMsgenerated.contains(slowRandBPMs[i])) {
                slowRandBPMs[i] = Int.random(in: 40...100)
            }
            slowBPMsgenerated.append(slowRandBPMs[i])
        }
        
        // moderate panel attributes
        third_recomm.layer.borderColor = UIColor.lightGray.cgColor
        third_recomm.layer.borderWidth = 1.0
        third_recomm.layer.cornerRadius = 5
        moderate_slide.layer.cornerRadius = 5
        moderate_slide.delegate = self
        moderate_slide.dataSource = self
        moderate_pageCtrl.numberOfPages = moderateImages.count
        var modBPMsgenerated:[Int] = []
        // fill moderate BPM's array with random #'s [101, 160]
        for i in 0...29 {
            moderateRandBPMs[i] = Int.random(in: 101...160)
            while (modBPMsgenerated.contains(moderateRandBPMs[i])) {
                moderateRandBPMs[i] = Int.random(in: 101...160)
            }
            modBPMsgenerated.append(moderateRandBPMs[i])
        }
        
        startTimer() // begins auto scroll on each recommended panel
        
        
        // search page
        searchField.attributedPlaceholder = NSAttributedString(string: "Search for a song", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchField.layer.cornerRadius = 10
        searchField.delegate = self
        songTable.delegate = self
        songTable.dataSource = self
        songTable.rowHeight = 65
        self.songTable.tableFooterView = UIView()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        searchView.addGestureRecognizer(tap)
        songDetailsView.layer.cornerRadius = 5
        songDetailsView.layer.shadowColor = UIColor.black.cgColor
        songDetailsView.layer.shadowOpacity = 1
        songDetailsView.layer.shadowOffset = .zero
        songDetailsView.layer.shadowRadius = 10
        songDetailsView.layer.shadowPath = UIBezierPath(rect: songDetailsView.bounds).cgPath
        songDetailsView.layer.shouldRasterize = true
        songDetailImage.layer.cornerRadius = 5
        loading.color = .lightGray
        
        
        // heart rate page
        BPMtable.delegate = self
        BPMtable.dataSource = self
        BPMtable.rowHeight = 65
        self.BPMtable.tableFooterView = UIView()
        BPMdetailsView.layer.cornerRadius = 5
        BPMdetailsView.layer.shadowColor = UIColor.black.cgColor
        BPMdetailsView.layer.shadowOpacity = 1
        BPMdetailsView.layer.shadowOffset = .zero
        BPMdetailsView.layer.shadowRadius = 10
        BPMdetailsView.layer.shadowPath = UIBezierPath(rect: BPMdetailsView.bounds).cgPath
        BPMdetailsView.layer.shouldRasterize = true
        BPMimage.layer.cornerRadius = 5
        suggestedLoading.color = .lightGray
        

        // saved page
        savedTable.delegate = self
        savedTable.dataSource = self
        savedTable.rowHeight = 65
        self.savedTable.tableFooterView = UIView()
        let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
            item?.username == users_name
        })
        // show no songs label if no songs saved
        if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) != nil && ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! != 0  {
            self.noSongsLabel.isHidden = true
            self.savedTable.isHidden = false
        }
        else if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) == nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! == 0{
            self.noSongsLabel.isHidden = false
            self.savedView.bringSubviewToFront(noSongsLabel)
            self.savedTable.isHidden = true
        }
        savedSongImg.layer.cornerRadius = 5
        savedDetailsView.layer.cornerRadius = 5
        savedDetailsView.layer.shadowColor = UIColor.black.cgColor
        savedDetailsView.layer.shadowOpacity = 1
        savedDetailsView.layer.shadowOffset = .zero
        savedDetailsView.layer.shadowRadius = 10
        savedDetailsView.layer.shadowPath = UIBezierPath(rect: savedDetailsView.bounds).cgPath
        savedDetailsView.layer.shouldRasterize = true
        
        
        // profile page
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        // username/email/password Label
        // get user index
        let tempIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
            item?.username == users_name
        })!
        usernameLabel.textColor = .lightGray
        usernameLabel.text = "\(users_name!)"
        emailLabel.textColor = .lightGray
        emailLabel.text?.append("   \(users_email!)")
        nameLabel.textColor = .lightGray
        // check if user has a name
        if (UIApplication.shared.delegate as! AppDelegate).userData[tempIndex]!.name != nil && (UIApplication.shared.delegate as! AppDelegate).userData[tempIndex]!.name != "" {
            nameLabel.text = "Name:   \((UIApplication.shared.delegate as! AppDelegate).userData[tempIndex]!.name!)"
        }
        // check if user has a profile picture
        if (UIApplication.shared.delegate as! AppDelegate).userData[tempIndex]!.profilePic != nil {
            profilePic.image = (UIApplication.shared.delegate as! AppDelegate).userData[tempIndex]!.profilePic!
        }
        else {
            profilePic.image = UIImage(named: "general_profile")
        }
        passwordLabel.textColor = .lightGray
        passwordLabel.text?.append("   ")
        for _ in 0...users_password_count!-1 {
            passwordLabel.text?.append("*")
        }
        
        // profile action buttons and text fields
        deleteAccountButton.layer.cornerRadius = 5
        logOutButton.layer.cornerRadius = 5
        editUsernameField.isHidden = true
        editNameField.isHidden = true
        editEmailField.isHidden = true
        editPasswordField.isHidden = true
        editConfirmField.isHidden = true
        editProfilePicButton.isHidden = true
        editProfileButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        profileView.addGestureRecognizer(tap)
        editUsernameField.addTarget(self, action: #selector(self.changeEditButton(_:)), for: UIControl.Event.editingChanged)
        editNameField.addTarget(self, action: #selector(self.changeEditButton(_:)), for: UIControl.Event.editingChanged)
        editEmailField.addTarget(self, action: #selector(self.changeEditButton(_:)), for: UIControl.Event.editingChanged)
        editPasswordField.addTarget(self, action: #selector(self.changeEditButton(_:)), for: UIControl.Event.editingChanged)
        editConfirmField.addTarget(self, action: #selector(self.changeEditButton(_:)), for: UIControl.Event.editingChanged)
        
    }   // end viewDidLoad()
    
    
    
    
    
    // --------------- OVERRIDE FUNCTIONS ---------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   // end didReceiveMemoryWarning()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }   // end viewDidLayoutSubviews()
    
    
    
    
    
    // --------------- KEYBOARD DISMISSAL ---------------
    
    // when user taps outside of keyboard, dismiss keyboard
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        searchView.endEditing(true)
        profileView.endEditing(true)
        self.songTable.isHidden = false
    }
    
    
    // keyboard dismissal on "return" tapped (search page)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        searchSongs();
        loading.isHidden = false
        loading.startAnimating()
        //songTable.isHidden = false
        return true;
    }   // end textFieldShouldReturn()
    
    
    // searches for songs through api
    func searchSongs() {
        // API for song search
        getData()
    } // end searchSongs function

    
    
    
    
    // --------------- RECOMMENDED PANELS (ANIMATIONS) ---------------
    
    // functions for panels' image auto-scrolls
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 4.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }   // end startTimer()
    
    // moves auto scroll to next image in each recommended panel
    @objc func moveToNextIndex() {
        if currentIndex < slowImages.count - 1 {
            currentIndex += 1
        }
        else {
            currentIndex = 0
        }
        if currentIndex_upbeat < fastImages.count - 1 {
            currentIndex_upbeat += 1
        }
        else {
            currentIndex_upbeat = 0
        }
        
        // slow panel control
        slow_slide.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        slow_pageCtrl.currentPage = currentIndex
        
        //upbeat panel control
        upbeat_slide.scrollToItem(at: IndexPath(item: currentIndex_upbeat, section: 0), at: .centeredHorizontally, animated: true)
        upbeat_pageCtrl.currentPage = currentIndex_upbeat
        
        // moderate panel control
        moderate_slide.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        moderate_pageCtrl.currentPage = currentIndex
        
    }   // end moveToNextIndex()
    
    
    
    
    
    // --------------- RECOMMENDED PANELS (ACTIONS) ---------------
    
    // user taps upbeat panel
    @IBAction func upbeatClicked(_ sender: Any) {
        selectedRange = "upbeat"
        getUpbeatSongs()
        self.recommendedView.isHidden = false
        recommendedTable.isHidden = true
        // bring recommended table to front
        scrollView.isHidden = true
        backButton.isHidden = false
        onRecommended = true
        topSplitBar.isHidden = true
        topLogo.isHidden = true
        selectedPlaylistLabel.text = "Upbeat Playlist"
        selectedPlaylistLabel.isHidden = false
        recLoading.isHidden = false
        recLoading.startAnimating()
        self.recLoading.alpha = 1.0
    } // end upbeatClicked
    
    
    // user taps slow-paced panel
    @IBAction func slowClicked(_ sender: UIButton) {
        selectedRange = "slow"
        getSlowSongs()
        self.recommendedView.isHidden = false
        recommendedTable.isHidden = true
        // bring recommended table to front
        scrollView.isHidden = true
        backButton.isHidden = false
        onRecommended = true
        topSplitBar.isHidden = true
        topLogo.isHidden = true
        selectedPlaylistLabel.text = "Slow-Paced Playlist"
        selectedPlaylistLabel.isHidden = false
        recLoading.isHidden = false
        recLoading.startAnimating()
        self.recLoading.alpha = 1.0
    } // end slowClicked
    
    
    // user taps moderate panel
    @IBAction func moderateClicked(_ sender: Any) {
        selectedRange = "moderate"
        getModerateSongs()
        self.recommendedView.isHidden = false
        recommendedTable.isHidden = true
        // bring recommended table to front
        scrollView.isHidden = true
        backButton.isHidden = false
        onRecommended = true
        topSplitBar.isHidden = true
        topLogo.isHidden = true
        selectedPlaylistLabel.text = "Moderate Playlist"
        selectedPlaylistLabel.isHidden = false
        recLoading.isHidden = false
        recLoading.startAnimating()
        self.recLoading.alpha = 1.0
    } // end moderateClicked
    
    
    // cancel recommended song details view
    @IBAction func cancelRecDetails(_ sender: Any) {
        recSongDetails.isHidden = true
        temporaryView.isHidden = true
        self.viewSlideCancel(view: recSongDetails)
        recommendedTable.alpha = 1.0
    } // end cancelRecDetails
    
    
    
    // slide back to home screen (out of recommended table)
    @IBAction func backButtonClicked(_ sender: Any) {
        
        scrollView.isHidden = false
        viewSlideInFromLeft(view: scrollView)
        recommendedView.isHidden = true
        backButton.isHidden = true
        topLogo.isHidden = false
        selectedPlaylistLabel.isHidden = true
        topSplitBar.isHidden = false
        onRecommended = false
        
    } // end backButtonClicked
    
    
    
    
    
    // --------------- RETRIEVE SONG DATA FROM API ---------------
    
    // session manager for URLSession
    static let sessionManager: URLSession = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30 // seconds
            configuration.timeoutIntervalForResource = 30 // seconds
            return URLSession(configuration: configuration)
    }()
    
    
    // api function to begin getting song data
    var songIDs:[String] = []
    var imageURLs:[String] = []
    private func getData() {
        let song = self.searchField.text    // get user search input
        
        // text manipulation for proper API lookup
        let searchReplace1 = song?.replacingOccurrences(of: " ", with: "+")
        let searchReplace2 = searchReplace1?.replacingOccurrences(of: "’", with: "")
        let searchReplace3 = searchReplace2?.replacingOccurrences(of: ",", with: "")
        let searchReplace4 = searchReplace3?.replacingOccurrences(of: "-", with: "+")
        let songToSearch = searchReplace4?.replacingOccurrences(of: ".", with: "")
        
        let link = "https://api.getsongbpm.com/search/?api_key=c42bacc54624edfd4f3d4365f8025bab&type=song&lookup=\(songToSearch!)"
        
        guard let url = URL(string: link) else { print("found nil"); return }
        
        // first data grab
        let task = HomeController.sessionManager.dataTask(with: url, completionHandler:{ data, response, error in
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            
            // get data
            var result:Response1?
            do {
                result = try JSONDecoder().decode(Response1.self, from: data)
                DispatchQueue.main.async {
                    self.songListCount = (result?.search?.count)!
                    self.songTable.reloadData()
                 }
                
            }
            catch {
                // error
                print("Failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }

            // remove all info from songList, songIDs and imageURLS for fresh search results
            self.songList.removeAll()
            self.songIDs.removeAll()
            self.imageURLs.removeAll()
            
            // if there are results for song
            if json.search?.count != nil {
                self.songListCount = json.search!.count
            
                // for every song in json result, store song info
                for i in 0...(self.songListCount-1) {
                    var newSong:songInfo! = songInfo()
                    newSong.Title = json.search![i].title!
                    newSong.Artist = json.search![i].artist!.name!
                    
                    // getting image url
                    var imageCode = ""
                    if (json.search![i].artist!.img != nil) {
                        imageCode = json.search![i].artist!.img!
                    }
                    else {
                        imageCode = ""
                    }
                    newSong.imageURL = imageCode
                    
                    newSong.id = json.search![i].id!
                    newSong.BPM = ""
                    self.songList.append(newSong)
                    self.songIDs.append(json.search![i].id!)
                    if (json.search![i].artist!.img != nil) {
                        self.imageURLs.append(json.search![i].artist!.img!)
                    }
                } // end for
            } // end if
            
            self.getSongFromWhere = "search"
            
            // get the bpm's of the songs from search results
            self.getSongBPM(ids: self.songIDs)
            
            // get the images of the songs from search results
            self.getArtistImage(images: self.imageURLs)
                        
        }) // end task
        
        task.resume()
        
    }   // end getData()
    
    
    // get bpm of song from api
    func getSongBPM(ids:[String]) {

        for i in 0...(ids.count-1) {
        
            // url for song details api
            let url2 = "https://api.getsongbpm.com/song/?api_key=c42bacc54624edfd4f3d4365f8025bab&id=\(ids[i])"

            
            // task for bpm data grab
            let task2 = HomeController.sessionManager.dataTask(with: URL(string: url2)!, completionHandler:{ data, response, error in
                guard let data = data, error == nil else {
                    print("Something went wrong")
                    return
                }
                
                // try to get data from api
                var result:FinalResponse?
                do {
                    result = try JSONDecoder().decode(FinalResponse.self, from: data)
                }
                catch {
                    // error
                    print("Failed to convert \(error.localizedDescription)")
                }
                
                guard let json = result else {
                    return
                }
                
                DispatchQueue.main.async{
                    
                    // if the song has a BPM in the json result
                    if json.song!.tempo != nil {
                        
                        if let index = self.songList.firstIndex(where: {$0?.id == self.songIDs[i]}) {
                            self.songList[index]?.BPM = json.song!.tempo!
                        }
                    }
                    // if there is no BPM listed for the song in the json result
                    else {
                        
                        if let index = self.songList.firstIndex(where: {$0?.id == self.songIDs[i]}) {
                            self.songList[index]?.id = "Unavailable"
                        }
                    }
                    
                    self.songTable.reloadData()

                } // end dispatch queue
            }) // end of task2

            task2.resume()
            
        }// end for loop

    } //end getSongBPM function
    
    
    // get the image of artist to show in song details from api
    func getArtistImage(images:[String]) {
        
        // for every image that was obtained from previous data grab
        for i in 0...(images.count-1) {
            
            // url for image urls
            let url3 = images[i]
                        
            // task for image data grab
            let task3 = HomeController.sessionManager.dataTask(with: URL(string: url3)!, completionHandler:{ data, response, error in
                guard let data = data, let downloadedImg = UIImage(data: data), error == nil else {
                    print("Something went wrong")
                    return
                }
                
                // try to get data from api
                DispatchQueue.main.async{

                    // get artist images for search results
                    if (self.getSongFromWhere == "search") {
                        if let index = self.songList.firstIndex(where: {$0?.imageURL == self.imageURLs[i]}) {
                            self.songList[index]?.artistImage = downloadedImg
                        }

                        self.songTable.reloadData()
                        
                        let topIndex = IndexPath(row: 0, section: 0)
                        self.songTable.scrollToRow(at: topIndex, at: .top, animated: false)
                    }
                    
                    // get artist images for heart rate results
                    else if (self.getSongFromWhere == "heart rate") {
                        if let index = self.suggestedList.firstIndex(where: {$0?.imageURL == self.suggestedImgURLs[i]}) {
                            self.suggestedList[index]?.artistImage = downloadedImg
                        }

                        self.BPMtable.reloadData()
                        
                        let topIndex = IndexPath(row: 0, section: 0)
                        self.BPMtable.scrollToRow(at: topIndex, at: .top, animated: false)
                    }
                    
                    // get images for slow paced results
                    else if (self.getSongFromWhere == "slow") {
                        if let index = self.slowPacedList.firstIndex(where: {$0?.imageURL == self.slowImgURLs[i]}) {
                            self.slowPacedList[index]?.artistImage = downloadedImg
                        }

                        self.recommendedTable.reloadData()
                        
                        let topIndex = IndexPath(row: 0, section: 0)
                        self.recommendedTable.scrollToRow(at: topIndex, at: .top, animated: false)
                    }
                    
                    // get images for upbeat results
                    else if (self.getSongFromWhere == "upbeat") {
                        if let index = self.upbeatList.firstIndex(where: {$0?.imageURL == self.upbeatImgURLs[i]}) {
                            self.upbeatList[index]?.artistImage = downloadedImg
                        }

                        self.recommendedTable.reloadData()
                        
                        let topIndex = IndexPath(row: 0, section: 0)
                        self.recommendedTable.scrollToRow(at: topIndex, at: .top, animated: false)
                    }
                    
                    // get images for moderate results
                    else if (self.getSongFromWhere == "moderate") {
                        if let index = self.moderateList.firstIndex(where: {$0?.imageURL == self.moderateImgURLs[i]}) {
                            self.moderateList[index]?.artistImage = downloadedImg
                        }

                        self.recommendedTable.reloadData()
                        
                        let topIndex = IndexPath(row: 0, section: 0)
                        self.recommendedTable.scrollToRow(at: topIndex, at: .top, animated: false)
                    }
                } // end dispatch queue
            }) // end of task3

            task3.resume()
            
        } // end for loop
        
    } // end of getArtistImage
    
    
    
    
    // -------------- HEART RATE SONGS SUGGESTION FUNCTIONS ---------------
    
    var suggestedList = [songInfo?]()
    var suggestedSongIDs:[String] = []
    var suggestedImgURLs:[String] = []
    
    func getSuggestedSongs() {
        self.suggestedList.removeAll()
        self.suggestedSongIDs.removeAll()
        self.suggestedImgURLs.removeAll()
        
        var sumOfBPMs = 0
        var avgBPM = 0
        
        // get the sum of all the heart rate calculations
        for i in ((UIApplication.shared.delegate as! AppDelegate).collectedBPM) {
            sumOfBPMs += i
        }
        
        avgBPM = Int(sumOfBPMs/25)
        
        let suggestedURL = "https://api.getsongbpm.com/tempo/?api_key=c42bacc54624edfd4f3d4365f8025bab&bpm=\(avgBPM)"
                    
        // task for slow song data grab
        let bpmTask = HomeController.sessionManager.dataTask(with: URL(string: suggestedURL)!, completionHandler:{ data, response, error in
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            
            
             // get data
             var result:Response2?
             do {
                 result = try JSONDecoder().decode(Response2.self, from: data)
             }
             catch {
                 print("Failed to convert \(error.localizedDescription)")
             }
             
             guard let json = result else {
                 return
             }
            
            self.suggestedList.removeAll()
            self.suggestedSongIDs.removeAll()
            self.suggestedImgURLs.removeAll()

             
             if json.tempo?.count != nil {
                for i in 0...self.BPMtableCount-1 {

                     var newSong:songInfo! = songInfo()
                     newSong.Title = json.tempo![i].song_title!
                     newSong.Artist = json.tempo![i].artist!.name!
                     
                     // getting image url
                     var imageCode = ""
                     if (json.tempo![i].album!.img != nil) {
                         imageCode = json.tempo![i].album!.img!
                     }
                     else {
                         imageCode = ""
                     }
                     newSong.imageURL = imageCode
                     
                     newSong.id = json.tempo![i].song_id!
                     newSong.BPM = json.tempo![i].tempo!
                     self.suggestedList.append(newSong)

                     self.suggestedSongIDs.append(json.tempo![i].song_id!)
                     if (json.tempo![i].album!.img != nil) {
                         self.suggestedImgURLs.append(json.tempo![i].album!.img!)
                     }
                }
                DispatchQueue.main.async {
                    self.BPMtable.beginUpdates()
                    self.BPMtable.endUpdates()
                    self.BPMtable.isHidden = false
                }
            }
             else {
                print("Suggested songs JSON returned nil")
             }
            

            
            if (self.suggestedList.count == 30 && self.suggestedSongIDs.count == 30) {
                print("\n\n\nEND TASKING\n\n\n")
                print("suggestedList count total: \(self.suggestedList.count)")
                print("SUM OF BPMs CALCULATED: \(sumOfBPMs)")
                print("AVERAGE BPM CALCULATED: \(avgBPM)")
                
                self.getSongFromWhere = "heart rate"
                
                // get the images of the songs from search results
                self.getArtistImage(images: self.suggestedImgURLs)
                
                //self.BPMtable.isHidden = false
                //self.suggestedLoading.isHidden = true
                DispatchQueue.main.async {
                    self.suggestedLoading.alpha = 0.0
                }
            }
            
        }) // end of task4

        bpmTask.resume()


        DispatchQueue.main.async {
            self.BPMtableCount = 30
            self.BPMtable.reloadData()
         }
    } // end getSuggestedSongs()
    
    
    
    
    
    // -------------- RECOMMENDED PANELS FUNCTIONS ---------------
    
    
    var slowSongIDs:[String] = []
    var slowImgURLs:[String] = []
    // get songs for slow paced recommendations
    func getSlowSongs() {
        
        // remove all lists for recommended table
        self.upbeatList.removeAll()
        self.upbeatSongIDs.removeAll()
        self.upbeatImgURLs.removeAll()
        self.slowPacedList.removeAll()
        self.slowSongIDs.removeAll()
        self.slowImgURLs.removeAll()
        self.moderateList.removeAll()
        self.moderateSongIDs.removeAll()
        self.moderateImgURLs.removeAll()
                
        for i in 0...slowRandBPMs.count-1 {
                        
            let slowURL = "https://api.getsongbpm.com/tempo/?api_key=c42bacc54624edfd4f3d4365f8025bab&bpm=\(slowRandBPMs[i])"
                        
            // task for slow song data grab
            let task4 = HomeController.sessionManager.dataTask(with: URL(string: slowURL)!, completionHandler:{ data, response, error in
                guard let data = data, error == nil else {
                    print("Something went wrong")
                    return
                }
                     
                
                 // get data
                 var result:Response2?
                 do {
                     result = try JSONDecoder().decode(Response2.self, from: data)
                 }
                 catch {
                     print("Failed to convert \(error.localizedDescription)")
                 }
                 
                 guard let json = result else {
                     return
                 }

                 
                 if json.tempo?.count != nil {
                    
                    var randomSong:Int = 0
                    if (json.tempo!.count > 10) {
                        randomSong = Int.random(in: 0...10)
                    }
                    else {
                        randomSong = Int.random(in: 0..<json.tempo!.count)
                    }
                 
                     var newSong:songInfo! = songInfo()
                     newSong.Title = json.tempo![randomSong].song_title!
                     newSong.Artist = json.tempo![randomSong].artist!.name!
                     
                     // getting image url
                     var imageCode = ""
                     if (json.tempo![randomSong].album!.img != nil) {
                         imageCode = json.tempo![randomSong].album!.img!
                     }
                     else {
                         imageCode = ""
                     }
                     newSong.imageURL = imageCode
                     
                     newSong.id = json.tempo![randomSong].song_id!
                     newSong.BPM = json.tempo![randomSong].tempo!
                     self.slowPacedList.append(newSong)

                     self.slowSongIDs.append(json.tempo![randomSong].song_id!)
                     if (json.tempo![randomSong].album!.img != nil) {
                         self.slowImgURLs.append(json.tempo![randomSong].album!.img!)
                     }
                    
                    DispatchQueue.main.async {
                        self.recommendedTable.beginUpdates()
                        self.recommendedTable.endUpdates()
                    }
                    
                }
                 else {
                    print("Slow songs JSON returned nil")
                 }
                
                print("slowPacedList count total: \(self.slowPacedList.count)")

                
                if (self.slowPacedList.count == 30 && self.slowSongIDs.count == 30) {
                    print("\n\n\nEND TASKING\n\n\n")
                    
                    self.getSongFromWhere = "slow"
                    
                    // get the images of the songs from search results
                    self.getArtistImage(images: self.slowImgURLs)
                    
                    DispatchQueue.main.async {
                        self.recommendedTable.beginUpdates()
                        self.recommendedTable.endUpdates()
                        self.recommendedTable.isHidden = false
                        self.recLoading.isHidden = true
                        self.recLoading.alpha = 0.0
                    }
                }
                
            }) // end of task4

            task4.resume()
        } // end for
                
        DispatchQueue.main.async {
            self.recommendedTableCount = 30
            self.recommendedTable.reloadData()
         }
        
    } // end getSlowSongs
    
    
    var upbeatSongIDs:[String] = []
    var upbeatImgURLs:[String] = []
    // get songs for slow paced recommendations
    func getUpbeatSongs() {
        
        self.upbeatList.removeAll()
        self.upbeatSongIDs.removeAll()
        self.upbeatImgURLs.removeAll()
        self.slowPacedList.removeAll()
        self.slowSongIDs.removeAll()
        self.slowImgURLs.removeAll()
        self.moderateList.removeAll()
        self.moderateSongIDs.removeAll()
        self.moderateImgURLs.removeAll()
                
        for i in 0...upbeatRandBPMs.count-1 {
                        
            let upbeatURL = "https://api.getsongbpm.com/tempo/?api_key=c42bacc54624edfd4f3d4365f8025bab&bpm=\(upbeatRandBPMs[i])"
                        
            // task for slow song data grab
            let task5 = HomeController.sessionManager.dataTask(with: URL(string: upbeatURL)!, completionHandler:{ data, response, error in
                guard let data = data, error == nil else {
                    print("Something went wrong")
                    return
                }
                     
                
                 // get data
                 var result:Response2?
                 do {
                     result = try JSONDecoder().decode(Response2.self, from: data)
                 }
                 catch {
                     print("Failed to convert \(error.localizedDescription)")
                 }
                 
                 guard let json = result else {
                     return
                 }

                 
                 if json.tempo?.count != nil {
                    
                    var randomSong:Int = 0
                    if (json.tempo!.count > 10) {
                        randomSong = Int.random(in: 0...10)
                    }
                    else {
                        randomSong = Int.random(in: 0..<json.tempo!.count)
                    }
                 
                     var newSong:songInfo! = songInfo()
                     newSong.Title = json.tempo![randomSong].song_title!
                     newSong.Artist = json.tempo![randomSong].artist!.name!
                     
                     // getting image url
                     var imageCode = ""
                     if (json.tempo![randomSong].album!.img != nil) {
                         imageCode = json.tempo![randomSong].album!.img!
                     }
                     else {
                         imageCode = ""
                     }
                     newSong.imageURL = imageCode
                     
                     newSong.id = json.tempo![randomSong].song_id!
                     newSong.BPM = json.tempo![randomSong].tempo!
                     self.upbeatList.append(newSong)

                     self.upbeatSongIDs.append(json.tempo![randomSong].song_id!)
                     if (json.tempo![randomSong].album!.img != nil) {
                         self.upbeatImgURLs.append(json.tempo![randomSong].album!.img!)
                     }
                    
                    DispatchQueue.main.async {
                        self.recommendedTable.beginUpdates()
                        self.recommendedTable.endUpdates()
                    }
                }
                 else {
                    print("Upbeat songs JSON returned nil")
                 }
                
                print("upbeatList count total: \(self.upbeatList.count)")
                
                if (self.upbeatList.count == 30 && self.upbeatSongIDs.count == 30) {
                    print("\n\n\nEND TASKING\n\n\n")
                    
                    self.getSongFromWhere = "upbeat"
                    
                    // get the images of the songs from search results
                    self.getArtistImage(images: self.upbeatImgURLs)
                    
                    DispatchQueue.main.async {
                        self.recommendedTable.beginUpdates()
                        self.recommendedTable.endUpdates()
                        self.recommendedTable.isHidden = false
                        self.recLoading.isHidden = true
                        self.recLoading.alpha = 0.0
                    }
                }
                
            }) // end of task5

            task5.resume()
        } // end for
                
        DispatchQueue.main.async {
            self.recommendedTableCount = 30
            self.recommendedTable.reloadData()
         }
        
    } // end getUpbeatSongs
    
    
    var moderateSongIDs:[String] = []
    var moderateImgURLs:[String] = []
    // get songs for slow paced recommendations
    func getModerateSongs() {
        
        self.upbeatList.removeAll()
        self.upbeatSongIDs.removeAll()
        self.upbeatImgURLs.removeAll()
        self.slowPacedList.removeAll()
        self.slowSongIDs.removeAll()
        self.slowImgURLs.removeAll()
        self.moderateList.removeAll()
        self.moderateSongIDs.removeAll()
        self.moderateImgURLs.removeAll()
                
        for i in 0...moderateRandBPMs.count-1 {
                        
            let moderateURL = "https://api.getsongbpm.com/tempo/?api_key=c42bacc54624edfd4f3d4365f8025bab&bpm=\(moderateRandBPMs[i])"
                        
            // task for moderate song data grab
            let task6 = HomeController.sessionManager.dataTask(with: URL(string: moderateURL)!, completionHandler:{ data, response, error in
                guard let data = data, error == nil else {
                    print("Something went wrong")
                    return
                }
                     
                
                 // get data
                 var result:Response2?
                 do {
                     result = try JSONDecoder().decode(Response2.self, from: data)
                 }
                 catch {
                     print("Failed to convert \(error.localizedDescription)")
                 }
                 
                 guard let json = result else {
                     return
                 }

                 
                 if json.tempo?.count != nil {
                    
                    var randomSong:Int = 0
                    if (json.tempo!.count > 10) {
                        randomSong = Int.random(in: 0...10)
                    }
                    else {
                        randomSong = Int.random(in: 0..<json.tempo!.count)
                    }
                 
                     var newSong:songInfo! = songInfo()
                     newSong.Title = json.tempo![randomSong].song_title!
                     newSong.Artist = json.tempo![randomSong].artist!.name!
                     
                     // getting image url
                     var imageCode = ""
                     if (json.tempo![randomSong].album!.img != nil) {
                         imageCode = json.tempo![randomSong].album!.img!
                     }
                     else {
                         imageCode = ""
                     }
                     newSong.imageURL = imageCode
                     
                     newSong.id = json.tempo![randomSong].song_id!
                     newSong.BPM = json.tempo![randomSong].tempo!
                     self.moderateList.append(newSong)
                     self.moderateSongIDs.append(json.tempo![randomSong].song_id!)
                     if (json.tempo![randomSong].album!.img != nil) {
                         self.moderateImgURLs.append(json.tempo![randomSong].album!.img!)
                     }
                    
                    DispatchQueue.main.async {
                        self.recommendedTable.beginUpdates()
                        self.recommendedTable.endUpdates()
                    }
                }
                 else {
                    print("Moderate songs JSON returned nil")
                 }
                
                print("moderateList count total: \(self.moderateList.count)")
                
                if (self.moderateList.count == 30 && self.moderateSongIDs.count == 30) {
                    print("\n\n\nEND TASKING\n\n\n")
                    
                    self.getSongFromWhere = "moderate"
                    
                    // get the images of the songs from search results
                    self.getArtistImage(images: self.moderateImgURLs)
                    
                    DispatchQueue.main.async {
                        self.recommendedTable.beginUpdates()
                        self.recommendedTable.endUpdates()
                        self.recommendedTable.isHidden = false
                        self.recLoading.isHidden = true
                        self.recLoading.alpha = 0.0
                    }
                }
                
            }) // end of task6

            task6.resume()
        } // end for
                
        DispatchQueue.main.async {
            self.recommendedTableCount = 30
            self.recommendedTable.reloadData()
         }
        
    } // end getModerateSongs


    
    
    
    
    // -------------- NAVIGATION BUTTONS ---------------
    
    // action for home nav button clicked
    @IBAction func homeClicked(_ sender: Any) {
        // hide/show pages
        searchView.isHidden = true
        savedView.isHidden = true
        heartRateView.isHidden = true
        if (!onRecommended) {
            scrollView.isHidden = false
            topLogo.isHidden = false
            topSplitBar.isHidden = false
            backButton.isHidden = true
            recommendedView.isHidden = true
            selectedPlaylistLabel.isHidden = true
        }
        else {
            recommendedView.isHidden = false
            backButton.isHidden = false
            topLogo.isHidden = true
            selectedPlaylistLabel.isHidden = false
            if (selectedRange == "slow") {
                selectedPlaylistLabel.text = "Slow-Paced Playlist"
            }
            else if (selectedRange == "upbeat"){
                selectedPlaylistLabel.text = "Upbeat Playlist"
            }
            else if (selectedRange == "moderate") {
                selectedPlaylistLabel.text = "Moderate Playlist"
            }
        }
        profileView.isHidden = true
        
        // tints of other icons
        homeIcon.tintColor = UIColor(red: 25/255, green: 197/255, blue: 255/255, alpha: 1.0)
        searchIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        savedIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        profileIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        
        // tints of heartRate icon
        heartIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        musicIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        leftWaveIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        rightWaveIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    }   // end homeClicked()
    
    
    // action for search nav button clicked
    @IBAction func searchClicked(_ sender: Any) {
        // hide/show pages
        searchView.isHidden = false
        savedView.isHidden = true
        heartRateView.isHidden = true
        scrollView.isHidden = true
        topLogo.isHidden = true
        topSplitBar.isHidden = true
        profileView.isHidden = true
        backButton.isHidden = true
        recommendedView.isHidden = true
        selectedPlaylistLabel.isHidden = true
        
        // tints of other icons
        searchIcon.tintColor = UIColor(red: 25/255, green: 197/255, blue: 255/255, alpha: 1.0)
        homeIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        savedIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        profileIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        
        // tints of heartRate icon
        heartIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        musicIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        leftWaveIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        rightWaveIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    }   // end searchClicked()
    
    
    // action for heartRate nav button clicked
    @IBAction func heartRateClicked(_ sender: Any) {
        // hide/show pages
        savedView.isHidden = true
        searchView.isHidden = true
        heartRateView.isHidden = false
        scrollView.isHidden = true
        topLogo.isHidden = false
        topSplitBar.isHidden = true
        profileView.isHidden = true
        backButton.isHidden = true
        recommendedView.isHidden = true
        selectedPlaylistLabel.isHidden = true
        
        backButton.isHidden = true
        recommendedView.isHidden = true
        
        self.heartRateLabel.text = "Heart rate not found!"
        
        
        //tints of heartRate Icon
        heartIcon.tintColor = UIColor(red: 25/255, green: 197/255, blue: 255/255, alpha: 1.0)
        musicIcon.tintColor = UIColor(red: 25/255, green: 197/255, blue: 255/255, alpha: 1.0)
        leftWaveIcon.tintColor = UIColor(red: 25/255, green: 197/255, blue: 255/255, alpha: 1.0)
        rightWaveIcon.tintColor = UIColor(red: 25/255, green: 197/255, blue: 255/255, alpha: 1.0)
        
        // tints of other icons
        savedIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        homeIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        searchIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        profileIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        
        
        // show heart rate detector
        // Register Xib
        let pulseVC = PulseViewController()

        // Present VC "Modally" style
        self.present(pulseVC, animated: true, completion: nil)

        
        if !firstBPMcalculation {
            self.BPMtable.beginUpdates()
            self.BPMtable.endUpdates()
            self.BPMtable.isHidden = false
        }
        else {
            self.BPMtable.isHidden = true
        }
        
        self.suggestedLoading.isHidden = false
        self.suggestedLoading.startAnimating()
        
        pulseVC.onDoneBlock = { result in
            print("Passed count of BPMarray: \(((UIApplication.shared.delegate as! AppDelegate).collectedBPM).count)")
            if ((UIApplication.shared.delegate as! AppDelegate).collectedBPM).count == 25 {
                self.heartRateLabel.text = "Finding songs..."
                self.BPMtable.beginUpdates()
                self.BPMtable.endUpdates()
                self.getSuggestedSongs()
                self.firstBPMcalculation = false
            }
            else {
                self.heartRateLabel.text = "Not enough data! Try again!"
            }
        }
        
        
    }   // end heartRateClicked()
    
    
    // action for saved nav button clicked
    @IBAction func savedClicked(_ sender: Any) {
        // hide/show pages
        savedView.isHidden = false
        searchView.isHidden = true
        heartRateView.isHidden = true
        scrollView.isHidden = true
        topLogo.isHidden = true
        topSplitBar.isHidden = true
        profileView.isHidden = true
        backButton.isHidden = true
        recommendedView.isHidden = true
        selectedPlaylistLabel.isHidden = false
        
        selectedPlaylistLabel.text = "Saved Songs"
        
        let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
            item?.username == users_name
        })

        if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) != nil && ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! != 0  {
            self.noSongsLabel.isHidden = true
            self.savedTable.isHidden = false
        }
        else if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) == nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! == 0{
            print("empty")
            self.noSongsLabel.isHidden = false
            self.savedView.bringSubviewToFront(noSongsLabel)
            self.savedTable.isHidden = true
        }

        // tints of other icons
        savedIcon.tintColor = UIColor(red: 25/255, green: 197/255, blue: 255/255, alpha: 1.0)
        homeIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        searchIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        profileIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        
        // tints of heartRate icon
        heartIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        musicIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        leftWaveIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        rightWaveIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    }   // end savedClicked()
    
    
    // action for profile nav button clicked
    @IBAction func profileClicked(_ sender: Any) {
        // tints of other icons
        profileIcon.tintColor = UIColor(red: 25/255, green: 197/255, blue: 255/255, alpha: 1.0)
        homeIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        savedIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        searchIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        
        // tints of heartRate icon
        heartIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        musicIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        leftWaveIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        rightWaveIcon.tintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        
        // hide/show pages
        savedView.isHidden = true
        searchView.isHidden = true
        heartRateView.isHidden = true
        scrollView.isHidden = true
        topLogo.isHidden = false
        topSplitBar.isHidden = false
        profileView.isHidden = false
        backButton.isHidden = true
        recommendedView.isHidden = true
        selectedPlaylistLabel.isHidden = true
        
                
    }   // end profileClicked()
    
    
    
    
    
    // -------------- SONG DETAIL ACTIONS ---------------
    
    // hides the song detail panel from view
    @IBAction func exitSongDetail(_ sender: Any) {
        
        songDetailsView.isHidden = true
        tempSearchView.isHidden = true
        self.viewSlideCancel(view: songDetailsView)
        searchField.alpha = 1.0
        songTable.alpha = 1.0
        
    } // end exitSongDetail function
    
    
    // cancels song details in search
    @IBAction func searchDetailDismissal(_ sender: Any) {
        songDetailsView.isHidden = true
        tempSearchView.isHidden = true
        self.viewSlideCancel(view: songDetailsView)
        searchField.alpha = 1.0
        songTable.alpha = 1.0
    } // end searchDetailDismissal function
    
    
    // cancels song details in recommended songs
    @IBAction func recDetailDismissal(_ sender: Any) {
        recSongDetails.isHidden = true
        temporaryView.isHidden = true
        self.viewSlideCancel(view: recSongDetails)
        recommendedTable.alpha = 1.0
    } // end recDetailDismissal function
    
    
    // cancels song details in saved songs
    @IBAction func exitSavedDetail(_ sender: Any) {
        savedDetailsView.isHidden = true
        tempSavedView.isHidden = true
        self.viewSlideCancel(view: savedDetailsView)
        savedTable.alpha = 1.0
    } // end savedDetailDismissal
    
    
    // cancels the saved song details when user taps outside of details box
    @IBAction func cancelSavedDetail(_ sender: Any) {
        savedDetailsView.isHidden = true
        tempSavedView.isHidden = true
        self.viewSlideCancel(view: savedDetailsView)
        savedTable.alpha = 1.0
    } // end cancelSavedDetail
    
    
    @IBAction func cancelBPMdetail(_ sender: Any) {
        BPMdetailsView.isHidden = true
        tempBPMview.isHidden = true
        self.viewSlideCancel(view: BPMdetailsView)
        BPMtable.alpha = 1.0
    } // end cancelBPMdetail
    
    
    @IBAction func exitBPMdetail(_ sender: Any) {
        BPMdetailsView.isHidden = true
        tempBPMview.isHidden = true
        self.viewSlideCancel(view: BPMdetailsView)
        BPMtable.alpha = 1.0
    } // end exitBPMdetail
    
    
    
    
    
    // -------------- EXTERNAL SONG-LISTENING MEDIA BUTTONS ---------------
    
    // links to spotify app if downloaded, if not downloaded, link to apple store for spotify
    @IBAction func goToSpotify(_ sender: Any) {
        
        let spotifyUrl = URL(string: "https://www.spotify.com/us/")
        
        if UIApplication.shared.canOpenURL(spotifyUrl! as URL) {
            UIApplication.shared.open(spotifyUrl!)
        }
        else {
            print("Spotify not installed")
            if let url = URL(string: "https://apps.apple.com/us/app/spotify-music-and-podcasts/id324684580") {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
               }
        }
        
    } // end goToSpotify
    
    
    // links to apple music app if downloaded, if not downloaded, link to apple store for apple music
    @IBAction func goToAppleMusic(_ sender: Any) {
        
        let appleMusicURL = URL(string: "https://music.apple.com/us/browse")
        
        if UIApplication.shared.canOpenURL(appleMusicURL! as URL) {
            UIApplication.shared.open(appleMusicURL!)
        }
        else {
            print("Apple Music not installed")
            if let url = URL(string: "https://apps.apple.com/us/app/apple-music/id1108187390") {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
               }
        }
        
    } // end goToAppleMusic
    
    
    
    
    
    // -------------- ACCOUNT ACTION BUTTONS ---------------
    
    // enables profile editing
    @IBAction func startEditProfile(_ sender: Any) {
        
        editUsernameField.layer.borderWidth = 0.0
        editNameField.layer.borderWidth = 0.0
        editEmailField.layer.borderWidth = 0.0
        editPasswordField.layer.borderWidth = 0.0
        editConfirmField.layer.borderWidth = 0.0
        
        let buttonTitle = (sender as AnyObject).title(for: .normal)
        
        // user is in edit mode
        if (buttonTitle != "Save" && buttonTitle != "Cancel") {
            editUsernameField.text = ""
            editNameField.text = ""
            editEmailField.text = ""
            editPasswordField.text = ""
            editConfirmField.text = ""
            
            // get user index
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })!
            
            // get placeholders for text fields
            editUsernameField.placeholder = users_name
            if (((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]?.name != nil && ((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]?.name != "") {
                editNameField.placeholder = ((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]?.name!
            }
            editEmailField.placeholder = ((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]?.email!
            
            editUsernameField.isHidden = false
            editNameField.isHidden = false
            editEmailField.isHidden = false
            editPasswordField.isHidden = false
            editConfirmField.isHidden = false
            editProfilePicButton.isHidden = false
            editProfileButton.setImage(nil, for: .normal)
            deleteAccountButton.alpha = 0.7
            deleteAccountButton.isEnabled = false
            logOutButton.alpha = 0.7
            logOutButton.isEnabled = false
            
            // if user made no edits
            if (editUsernameField.text == "" && editNameField.text == "" && editEmailField.text == "" && editPasswordField.text == "" && editConfirmField.text == "") {
                
                editProfileButton.setTitle("Cancel", for: .normal)
                editProfileButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                editProfileButton.setTitleColor(UIColor.systemBlue, for: .normal)
            }
            
        }
        // user is in view mode
        else {
            deleteAccountButton.alpha = 1.0
            deleteAccountButton.isEnabled = true
            logOutButton.alpha = 1.0
            logOutButton.isEnabled = true
            
            editUsernameField.isHidden = true
            editNameField.isHidden = true
            editEmailField.isHidden = true
            editPasswordField.isHidden = true
            editConfirmField.isHidden = true
            editProfilePicButton.isHidden = true
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)
            let originalSymbol = UIImage(systemName: "square.and.pencil", withConfiguration: largeConfig)
            editProfileButton.setImage(originalSymbol, for: .normal)
            editProfileButton.setTitle(nil, for: .normal)
            
            // get user index
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })!

            // update username
            if editUsernameField.text != "" {
                users_name = editUsernameField.text!
                ((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]?.username = editUsernameField.text!
                welcomeLabel.text = "Hi, \(((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]!.username!)"
                usernameLabel.text = ((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]!.username!
            }
            
            // update name
            if editNameField.text != "" {
                nameLabel.text = "Name:   \(editNameField.text!)"
                ((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]?.name = editNameField.text!
            }
            
            // update email
            if editEmailField.text != "" {
                users_email = editEmailField.text!
                ((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]?.email = editEmailField.text!
                emailLabel.text = "Email:   \(users_email!)"
            }
            
            // update password
            if editPasswordField.text != "" && editConfirmField.text != "" {
                users_password_count = editPasswordField.text?.count
                ((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]?.password = editPasswordField.text!
                passwordLabel.text = "Password:"
                passwordLabel.text?.append("   ")
                for _ in 0...users_password_count!-1 {
                    passwordLabel.text?.append("*")
                }
            }
            
        }
        
    } // end startEditProfile
    
    
    // user can change profile picture from camera or photo library
    @IBAction func changePicture(_ sender: Any) {
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        let titleAttrString = NSMutableAttributedString(string: "Edit Profile Picture", attributes: titleFont)
        
        let editAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        editAlert.setValue(titleAttrString, forKey:"attributedTitle")

        let photoLibraryAction = UIAlertAction(title: "Choose From Photo Library", style: .default) { (action: UIAlertAction) in
            let image = UIImagePickerController()
            image.delegate = self
            
            image.sourceType = .photoLibrary
            image.allowsEditing = true
            
            self.present(image, animated: true)
            
            self.choseFromLibrary = true
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let image = UIImagePickerController()
                image.delegate = self
                image.sourceType = .camera
                image.allowsEditing = true
                self.present(image, animated: true)
                self.choseFromLibrary = false
            }
        }
        
        let deleteAction = UIAlertAction(title: "Delete Profile Picture", style: .destructive) { (action: UIAlertAction) in
            self.profilePic.image = UIImage(named: "general_profile")
            self.didChangePic = true
            self.choseFromLibrary = false
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.didChangePic = false
            self.choseFromLibrary = false
        })

        editAlert.addAction(photoLibraryAction)
        editAlert.addAction(cameraAction)
        editAlert.addAction(deleteAction)
        editAlert.addAction(cancelAction)
        self.present(editAlert, animated: true, completion: nil)

    } // end changePicture
    
    
    // saves image to library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print("Error saving picture")
        }
    }
    
    
    // if user tries to log out, confirm logout and segue to login screen
    @IBAction func logoutTapped(_ sender: Any) {
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let titleAttrString = NSMutableAttributedString(string: "Are you sure you want to logout?", attributes: titleFont)
        let msgFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let msgAttrString = NSMutableAttributedString(string: "Once you log out, you are required to log in again to access your account.", attributes: msgFont)

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.setValue(titleAttrString, forKey:"attributedTitle")
        alert.setValue(msgAttrString, forKey: "attributedMessage")

        alert.addAction(UIAlertAction(title: "Log Out", style: .default, handler: segueToLogin))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    } // end logoutTapped
    
    
    // if user tries to delete account, confirm delete, delete from database, and segue to login screen
    @IBAction func deleteAccountTapped(_ sender: Any) {
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let titleAttrString = NSMutableAttributedString(string: "Are you sure you want to delete your account?", attributes: titleFont)
        let msgFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let msgAttrString = NSMutableAttributedString(string: "This action cannot be undone and everything saved will be lost.", attributes: msgFont)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.setValue(titleAttrString, forKey:"attributedTitle")
        alert.setValue(msgAttrString, forKey: "attributedMessage")

        alert.addAction(UIAlertAction(title: "Delete Account", style: .destructive, handler: deleteAccount))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    } // end deleteAccountTapped
    
    
    // delete account permanently
    func deleteAccount(action: UIAlertAction) {
        // go to login screen first
        self.performSegue(withIdentifier: "toLoginScreen", sender: self)
        
        // delete the account from database
        if let index = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
            item?.username == usernameLabel.text
        }) {
            
            ((UIApplication.shared.delegate as! AppDelegate).userData).remove(at: index)
        }

    } //end deleteAccount
    
    
    // function to handle segue back to the login screen
    func segueToLogin(action: UIAlertAction) {
        self.performSegue(withIdentifier: "toLoginScreen", sender: self)
    } // end segueToLogin
    
    
    
    
    
    // -------------------- ANIMATIONS ----------------------
    
    // slide from top animation for forgot password
    func viewSlideInFromTop(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        view.layer.add(transition, forKey: kCATransition)
    }   // end viewSlideInFromTop()
    
    
    // slide to bottom animation for cancel create account
    func viewSlideCancel(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        view.layer.add(transition, forKey: kCATransition)
    }   // end viewSlideCancel()
    
    
    // slide to right animation for going back to home page
    func viewSlideInFromLeft(view: UIScrollView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.layer.add(transition, forKey: kCATransition)
    }   // end viewSlideCancel()
    
    
    
    
    
    // --------------- DATA SOURCE/DELEGATES ---------------
    
    // hide table when user starts typing in search
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchField {
            self.songTable.isHidden = true
        }
    }   // didBeginEditing (text field -> search page)
    
    
    // for live text change
    @objc func changeEditButton(_ textField : UITextField) {
        var usernameTaken:Bool = false
        var currentUsername:Bool = false
        var emailTaken:Bool = false
        var currentEmail:Bool = false
        var currentName:Bool = false
        var currentPassword:Bool = false
        // get user index
        let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
            item?.username == users_name
        })!
        
        if editUsernameField.text == "" && editNameField.text == "" && editEmailField.text == "" && editPasswordField.text == "" && editConfirmField.text == "" {
            
            editProfileButton.setTitle("Cancel", for: .normal)
            editProfileButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            editProfileButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        else {
            editProfileButton.setTitle("Save", for: .normal)
            editProfileButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            editProfileButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        
        switch (textField) {
        case editUsernameField:
            // if current username
            if (users_name == editUsernameField.text!) {
                currentUsername = true
            }
            
            // if not current username but username is in use
            for user in (UIApplication.shared.delegate as! AppDelegate).userData {
                if (user?.username)?.lowercased() == (editUsernameField.text)?.lowercased() && !currentUsername {
                    usernameTaken = true
                }
            }
            
            // if username is original
            if editUsernameField.text != "" && !usernameTaken && !currentUsername {
                editProfileButton.alpha = 1.0
                editErrorMessage.isHidden = true
                editUsernameField.layer.borderWidth = 0.0
                usernameTaken = false
                currentUsername = false
                editProfileButton.isEnabled = true
            }
            else if usernameTaken {
                editErrorMessage.isHidden = false
                editErrorMessage.text = "That username is taken"
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editUsernameField.layer.borderWidth = 1.0
                editUsernameField.layer.cornerRadius = 5.0
                editUsernameField.layer.borderColor = UIColor.red.cgColor
            }
            else if currentUsername {
                editErrorMessage.isHidden = false
                editErrorMessage.text = "Try a username that is not your current username"
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editUsernameField.layer.borderWidth = 1.0
                editUsernameField.layer.cornerRadius = 5.0
                editUsernameField.layer.borderColor = UIColor.red.cgColor
            }
            else if editUsernameField.text == "" {
                editProfileButton.alpha = 1.0
                editErrorMessage.isHidden = true
                editUsernameField.layer.borderWidth = 0.0
                usernameTaken = false
                currentUsername = false
                editProfileButton.isEnabled = true
            }

            
        case editNameField:
            break
        
        case editEmailField:
            // if current email
            if (((UIApplication.shared.delegate as! AppDelegate).userData)[userIndex]?.email == editEmailField.text!) {
                currentEmail = true
            }
            
            for user in (UIApplication.shared.delegate as! AppDelegate).userData {
                if (user?.email)?.lowercased() == (editEmailField.text)?.lowercased() && !currentEmail {
                    emailTaken = true
                }
            }
            
            if emailTaken {
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editErrorMessage.text = "That email address is already in use"
                editErrorMessage.isHidden = false
                editEmailField.layer.borderWidth = 1.0
                editEmailField.layer.cornerRadius = 5.0
                editEmailField.layer.borderColor = UIColor.red.cgColor
            }
            else if currentEmail {
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editErrorMessage.text = "Try an email that is not your current email"
                editErrorMessage.isHidden = false
                editEmailField.layer.borderWidth = 1.0
                editEmailField.layer.cornerRadius = 5.0
                editEmailField.layer.borderColor = UIColor.red.cgColor
            }
            // if email is original
            else if editEmailField.text != "" && editEmailField.text!.contains("@") && (editEmailField.text!.suffix(4) == ".com" || editEmailField.text!.suffix(4) == ".net" || editEmailField.text!.suffix(4) == ".org" || editEmailField.text!.suffix(4) == ".edu" || editEmailField.text!.suffix(4) == ".gov" && !emailTaken && !currentEmail) {
                editProfileButton.alpha = 1.0
                editProfileButton.isEnabled = true
                editErrorMessage.isHidden = true
                editEmailField.layer.borderWidth = 0.0
                emailTaken = false
                currentEmail = false
            }
            else if editEmailField.text == "" {
                editProfileButton.alpha = 1.0
                editProfileButton.isEnabled = true
                editErrorMessage.isHidden = true
                editEmailField.layer.borderWidth = 0.0
                emailTaken = false
                currentEmail = false
            }
            else {
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editErrorMessage.text = "Please enter a valid email address"
                editErrorMessage.isHidden = false
                editEmailField.layer.borderWidth = 1.0
                editEmailField.layer.cornerRadius = 5.0
                editEmailField.layer.borderColor = UIColor.red.cgColor
            }
 
        case editPasswordField:
            //if current password
            if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex]?.password! == editPasswordField.text!) {
                currentPassword = true
            }
            
            // if password is original and matches the confirmed password
            if editPasswordField.text == editConfirmField.text && editPasswordField.text!.count >= 8 && editConfirmField.text!.count >= 8 && !currentPassword{
                editProfileButton.alpha = 1.0
                editProfileButton.isEnabled = true
                editErrorMessage.isHidden = true
                editConfirmField.layer.borderWidth = 0.0
                editPasswordField.layer.borderWidth = 0.0
                currentPassword = false
            }
            else if editPasswordField.text != editConfirmField.text {
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editErrorMessage.isHidden = false
                editErrorMessage.text = "Passwords do not match"
                editConfirmField.layer.borderWidth = 1.0
                editConfirmField.layer.cornerRadius = 5.0
                editConfirmField.layer.borderColor = UIColor.red.cgColor
            }
            else if currentPassword {
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editErrorMessage.isHidden = false
                editErrorMessage.text = "Try a password that is not your current password"
                editPasswordField.layer.borderWidth = 1.0
                editPasswordField.layer.cornerRadius = 5.0
                editPasswordField.layer.borderColor = UIColor.red.cgColor
            }
            else if editPasswordField.text == "" && editConfirmField.text == ""{
                editProfileButton.alpha = 1.0
                editProfileButton.isEnabled = true
                editErrorMessage.isHidden = true
                editPasswordField.layer.borderWidth = 0.0
                editConfirmField.layer.borderWidth = 0.0
                currentPassword = false
            }
            else if editPasswordField.text!.count >= 8 {
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editErrorMessage.isHidden = true
                editPasswordField.layer.borderWidth = 0.0
                currentPassword = false
            }
            else if editPasswordField.text!.count > 0 && editPasswordField.text!.count < 8 {
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editErrorMessage.isHidden = false
                editErrorMessage.text = "Password is too weak."
                editPasswordField.layer.borderWidth = 1.0
                editPasswordField.layer.cornerRadius = 5.0
                editPasswordField.layer.borderColor = UIColor.red.cgColor
            }

        
        case editConfirmField:
            //if current password
            if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex]?.password! == editConfirmField.text!) {
                currentPassword = true
            }
            
            // if passwords match and is original
            if editPasswordField.text == editConfirmField.text && editPasswordField.text!.count >= 8 && editConfirmField.text!.count >= 8 && !currentPassword{
                editProfileButton.alpha = 1.0
                editProfileButton.isEnabled = true
                editErrorMessage.isHidden = true
                editConfirmField.layer.borderWidth = 0.0
                currentPassword = false
            }
            else if editPasswordField.text != editConfirmField.text {
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editErrorMessage.isHidden = false
                editErrorMessage.text = "Passwords do not match"
                editConfirmField.layer.borderWidth = 1.0
                editConfirmField.layer.cornerRadius = 5.0
                editConfirmField.layer.borderColor = UIColor.red.cgColor
            }
            else if currentPassword {
                editProfileButton.alpha = 0.7
                editProfileButton.isEnabled = false
                editErrorMessage.isHidden = false
                editErrorMessage.text = "Try a password that is not your current password"
                editPasswordField.layer.borderWidth = 1.0
                editPasswordField.layer.cornerRadius = 5.0
                editPasswordField.layer.borderColor = UIColor.red.cgColor
            }
            else if editPasswordField.text == "" && editConfirmField.text == ""{
                editProfileButton.alpha = 1.0
                editProfileButton.isEnabled = true
                editErrorMessage.isHidden = true
                editPasswordField.layer.borderWidth = 0.0
                editConfirmField.layer.borderWidth = 0.0
                currentPassword = false
            }

        
        default: fatalError("Unknown field: \(textField)")
            
        } // end textField switch
        
    } // end changeEditButton
    
    
    // for changing profile picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // get user index
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })
            
            profilePic.image = image
            (UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]!.profilePic = profilePic.image
            if profilePic.image != UIImage(named: "general_profile") {
                didChangePic = true
            }
            
            if didChangePic {
                self.editProfileButton.setTitle("Save", for: .normal)
                self.editProfileButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                self.editProfileButton.setTitleColor(UIColor.systemBlue, for: .normal)
            }

            if !choseFromLibrary {
                // save image to library
                UIImageWriteToSavedPhotosAlbum(profilePic.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
        else
        {
            // error message
            print("Could not set image from photo library")
        }
        self.dismiss(animated: true, completion: nil)
    } // end imagePickerController
    
    
    // number of items for recommended panel images
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count:Int = 0
        if collectionView == slow_slide {
            count = slowImages.count
        }
        else if collectionView == upbeat_slide {
            count = fastImages.count
        }
        else if collectionView == moderate_slide {
            count = moderateImages.count
        }
        return count
    }   // numberOfItemsInSection (collectionView -> home page)
    
    
    // cell for item at for recommended panels
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // slow-paced cells
        if collectionView == self.slow_slide {
            let slow_paced_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slow_cell", for: indexPath) as! HomeCollectionViewCell
            slow_paced_cell.music_image.image = slowImages[indexPath.row]
            return slow_paced_cell
        }
        // upbeat cells
        else if collectionView == self.upbeat_slide {
            let fast_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upbeat_cell", for: indexPath) as! HomeCollectionViewCell
            fast_cell.upbeat_image.image = fastImages[indexPath.row]
            return fast_cell
        }
        // moderate cells
        else if collectionView == self.moderate_slide {
            let mod_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moderate_cell", for: indexPath) as! HomeCollectionViewCell
            mod_cell.moderate_image.image = moderateImages[indexPath.row]
            return mod_cell
        }
        // featured cells

        return UICollectionViewCell()
    }   // cellForItemAt (collectionView -> home page)
    
    
    // collection view size for recommended panels
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }   // collectionViewLayout (collectionView -> home page)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }   // layout (collectionView -> home page)
    
    
    
    
    
    // TABLEVIEW
    // did select row at for all tables
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == songTable {
            let indexPath = songTable.indexPathForSelectedRow!
            let selectedCell = songTable.cellForRow(at: indexPath) as! SearchTableViewCell
            
            self.songDetailTitle.text = songList[indexPath.row]?.Title!
            self.songDetailArtist.text = songList[indexPath.row]?.Artist!
            // if there a BPM
            if (songList[indexPath.row]!.BPM! != "") {
                self.songDetailBPM.text = "\(songList[indexPath.row]!.BPM!) BPM"
            }
            else {
                self.songDetailBPM.text = "BPM Unavailable"
            }
            // if the song detail contains an actual image
            if(songList[indexPath.row]!.imageURL! != "") {
                self.songDetailImage.image = songList[indexPath.row]!.artistImage
            }
            else {
                self.songDetailImage.image = UIImage(named: "image_unavailable")
            }
                        
            songDetailsView.isHidden = false
            tempSearchView.isHidden = false
            self.viewSlideInFromTop(view: songDetailsView)
            searchField.alpha = 0.3
            songTable.alpha = 0.3
            
        }
        else if tableView == BPMtable {
            let indexPath = BPMtable.indexPathForSelectedRow!
            let selectedCell = BPMtable.cellForRow(at: indexPath) as! SearchTableViewCell
            
            // checking selected path
            print("Row selected: \(indexPath.row)")
            print("On select, suggestedList count = \(self.suggestedList.count)")
            
            
            if self.suggestedList.count == 30 {
                if self.suggestedList[indexPath.row]?.Title! != nil {
                    self.BPMtitle.text = self.suggestedList[indexPath.row]?.Title!
                }
                if self.suggestedList[indexPath.row]?.Artist! != nil {
                    self.BPMartist.text = self.suggestedList[indexPath.row]?.Artist!
                }
                // if there a BPM
                if (self.suggestedList[indexPath.row]!.BPM! != "") {
                    self.BPMlabel.text = "\(self.suggestedList[indexPath.row]!.BPM!) BPM"
                }
                else {
                    self.BPMlabel.text = "BPM Unavailable"
                }
                // if the song detail contains an actual image
                if(self.suggestedList[indexPath.row]!.imageURL! != "") {
                    self.BPMimage.image = self.suggestedList[indexPath.row]!.artistImage
                }
                else {
                    self.BPMimage.image = UIImage(named: "image_unavailable")
                }
                            
                BPMdetailsView.isHidden = false
                tempBPMview.isHidden = false
                suggestedLoading.isHidden = true
                self.viewSlideInFromTop(view: BPMdetailsView)
                BPMtable.alpha = 0.3
            }
        }
        else if tableView == savedTable {
            let indexPath = savedTable.indexPathForSelectedRow!
            let selectedCell = savedTable.cellForRow(at: indexPath) as! SearchTableViewCell
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })
            
            self.savedTitle.text = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs[indexPath.row]?.title)
            self.savedArtist.text = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs[indexPath.row]?.artist)
            
            
            // if there a BPM
            if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs[indexPath.row]?.bpm) != nil && ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs[indexPath.row]?.bpm) != "") {
                self.savedBPM.text = "\(((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs[indexPath.row]?.bpm!)!) BPM"
            }
            else {
                self.savedBPM.text = "BPM Unavailable"
            }
            // if the song detail contains an actual image
            if(((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs[indexPath.row]?.imagePreview) != nil) {
                self.savedSongImg.image = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs[indexPath.row]?.imagePreview!)
            }
            else {
                self.savedSongImg.image = UIImage(named: "image_unavailable")
            }
                        
            savedDetailsView.isHidden = false
            tempSavedView.isHidden = false
            self.viewSlideInFromTop(view: savedDetailsView)
            savedTable.alpha = 0.3
        }
        else if tableView == recommendedTable {
            let indexPath = recommendedTable.indexPathForSelectedRow!
            let selectedCell = recommendedTable.cellForRow(at: indexPath) as! SearchTableViewCell
            
            if (selectedRange == "slow") {
                self.recSongTitle.text = slowPacedList[indexPath.row]?.Title!
                self.recSongArtist.text = slowPacedList[indexPath.row]?.Artist!
                // if there a BPM
                if (slowPacedList[indexPath.row]!.BPM! != "") {
                    self.recSongBPM.text = "\(slowPacedList[indexPath.row]!.BPM!) BPM"
                }
                else {
                    self.recSongBPM.text = "BPM Unavailable"
                }
                // if the song detail contains an actual image
                if(slowPacedList[indexPath.row]!.imageURL! != "") {
                    self.recSongImage.image = slowPacedList[indexPath.row]!.artistImage
                }
                else {
                    self.recSongImage.image = UIImage(named: "image_unavailable")
                }
                            
                recSongDetails.isHidden = false
                temporaryView.isHidden = false
                recLoading.isHidden = true
                self.viewSlideInFromTop(view: recSongDetails)
                recommendedTable.alpha = 0.3
            }
            else if (selectedRange == "upbeat") {
                self.recSongTitle.text = upbeatList[indexPath.row]?.Title!
                self.recSongArtist.text = upbeatList[indexPath.row]?.Artist!
                // if there a BPM
                if (upbeatList[indexPath.row]!.BPM! != "") {
                    self.recSongBPM.text = "\(upbeatList[indexPath.row]!.BPM!) BPM"
                }
                else {
                    self.recSongBPM.text = "BPM Unavailable"
                }
                // if the song detail contains an actual image
                if(upbeatList[indexPath.row]!.imageURL! != "") {
                    self.recSongImage.image = upbeatList[indexPath.row]!.artistImage
                }
                else {
                    self.recSongImage.image = UIImage(named: "image_unavailable")
                }
                            
                recLoading.isHidden = true
                recSongDetails.isHidden = false
                temporaryView.isHidden = false
                self.viewSlideInFromTop(view: recSongDetails)
                recommendedTable.alpha = 0.3
            }
            else if (selectedRange == "moderate") {
                self.recSongTitle.text = moderateList[indexPath.row]?.Title!
                self.recSongArtist.text = moderateList[indexPath.row]?.Artist!
                // if there a BPM
                if (moderateList[indexPath.row]!.BPM! != "") {
                    self.recSongBPM.text = "\(moderateList[indexPath.row]!.BPM!) BPM"
                }
                else {
                    self.recSongBPM.text = "BPM Unavailable"
                }
                // if the song detail contains an actual image
                if(moderateList[indexPath.row]!.imageURL! != "") {
                    self.recSongImage.image = moderateList[indexPath.row]!.artistImage
                }
                else {
                    self.recSongImage.image = UIImage(named: "image_unavailable")
                }

                // hide recommended song details
                recSongDetails.isHidden = false
                recLoading.isHidden = true
                temporaryView.isHidden = false
                self.viewSlideInFromTop(view: recSongDetails)
                recommendedTable.alpha = 0.3
            }
        }
    }   // end didSelectRowAt (tableView -> search page)
    
    
    // number of rows for all tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = 0
        if tableView == songTable {
            count = self.songListCount
            self.loading.stopAnimating()
            self.loading.isHidden = true
            self.songTable.isHidden = false
        }
        else if tableView == BPMtable {
            count = self.BPMtableCount
 
        }
        else if tableView == savedTable {
            // get user index
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })
            // show songs if there are saved songs
            if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) != nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0  {
                noSongsLabel.isHidden = true
                savedTable.isHidden = false
                count = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)!
            }
            // show no songs saved label if there are no songs saved
            else if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) == nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) == 0{
                noSongsLabel.isHidden = false
                savedTable.isHidden = true
            }
        }
        else if tableView == recommendedTable {
            
            count = self.recommendedTableCount
            
        }
        return count
    }   // numberOfRowsInSection (tableView -> search page)
    
    
    // cell for row for all tables
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if we are looking at the songTable
        if tableView == songTable {
            let cell = songTable.dequeueReusableCell(withIdentifier: "song_cell", for: indexPath) as! SearchTableViewCell
                     
            self.songTable.beginUpdates()
            if songList.count != 0 {
                cell.titleLabel?.text = self.songList[indexPath.row]?.Title!
                cell.artistLabel?.text = self.songList[indexPath.row]?.Artist!
            }
            else {
                //show label for no songs found
                
                
                
                
            }
            self.songTable.endUpdates()
            
            // get index of the user
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })
            
            if (self.songList.count == 30) {

                // if the song is already saved, upon search, make the bookmark filled
                if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                    let saved = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)
                    if saved!.firstIndex(where: { (item) -> Bool in
                        item?.id == songList[indexPath.row]?.id!
                    }) != nil {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                    }
                    else {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
                    }
                }
            }
            
            // save/unsave songs from the search page
            cell.actionBlock = {
                // make the bookmark empty if the song is not saved already
                let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                    item?.username == self.users_name
                })
                
                if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                    if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)!.firstIndex(where: { (item) -> Bool in
                        item?.id == self.songList[indexPath.row]?.id!
                    }) != nil {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
                        
                        // get index of the song in the user's saved song list
                        if let songIndex = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)!.firstIndex(where: { (item) -> Bool in
                            item?.id == self.songList[indexPath.row]?.id!
                        }) {
                            self.savedTable.beginUpdates()
                            
                            // delete the song from the saved songs table
                            self.savedTable.deleteRows(at: [(IndexPath(row: songIndex, section:0))], with: .automatic)
                            ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.deleteSavedSong(id: self.songList[indexPath.row]?.id!))
                            
                            self.savedTable.endUpdates()
                            self.songTable.reloadData()
                            self.recommendedTable.reloadData()
                            self.BPMtable.reloadData()
                            
                            // user deletes last and only song in saved songs
                            if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) == nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! == 0{
                                print("User's saved songs list is now empty")
                                self.noSongsLabel.isHidden = false
                                self.savedView.bringSubviewToFront(self.noSongsLabel)
                                self.savedTable.isHidden = true
                            }
                        }
                    }
                    else {
                        // change bookmark to fill to represent saved
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                        
                        // create saved object to append to user's saved songs list
                        var newSaved = saved()
                        newSaved.title = self.songList[indexPath.row]?.Title!
                        newSaved.artist = self.songList[indexPath.row]?.Artist!
                        newSaved.id = self.songList[indexPath.row]?.id!
                        newSaved.bpm = self.songList[indexPath.row]?.BPM!
                        if (self.songList[indexPath.row]?.artistImage != nil) {
                            newSaved.imagePreview = self.songList[indexPath.row]?.artistImage!
                        }
                        
                        // add new song to users data
                        ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.addSavedSong(song: newSaved))
                        self.savedTable.beginUpdates()
                        
                        // insert the new saved song to the saved songs page
                        self.savedTable.insertRows(at: [IndexPath(row:  ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! - 1, section: 0)], with: .automatic)
                        self.savedTable.endUpdates()
                        self.songTable.reloadData()
                        self.recommendedTable.reloadData()
                        self.BPMtable.reloadData()
                        
                    }
                }
                // savedSongs is empty
                else {
                    // change bookmark to fill to represent saved
                    cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                    
                    // create saved object to append to user's saved songs list
                    var newSaved = saved()
                    newSaved.title = self.songList[indexPath.row]?.Title!
                    newSaved.artist = self.songList[indexPath.row]?.Artist!
                    newSaved.id = self.songList[indexPath.row]?.id!
                    newSaved.bpm = self.songList[indexPath.row]?.BPM!
                    newSaved.imagePreview = self.songList[indexPath.row]?.artistImage
                    
                    // add new song to users data
                    ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.addSavedSong(song: newSaved))
                    self.savedTable.beginUpdates()
                    
                    // insert the new saved song to the saved songs page
                    self.savedTable.insertRows(at: [IndexPath(row:  ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! - 1, section: 0)], with: .automatic)
                    self.savedTable.endUpdates()
                    self.songTable.reloadData()
                    self.recommendedTable.reloadData()
                    self.BPMtable.reloadData()
                }
            } // end actionblock

            return cell
        } // end if songTable
        
        else if tableView == BPMtable {
            let cell = BPMtable.dequeueReusableCell(withIdentifier: "bpm_cell", for: indexPath) as! SearchTableViewCell
                     
            self.BPMtable.beginUpdates()
            if suggestedList.count != 0 {
                if self.suggestedList[indexPath.row]?.Title! != nil {
                    cell.titleLabel?.text = self.suggestedList[indexPath.row]?.Title!
                }
                if self.suggestedList[indexPath.row]?.Artist! != nil {
                    cell.artistLabel?.text = self.suggestedList[indexPath.row]?.Artist!
                }
            }
            else {
                //show label for no songs found
                
                
                
                
            }
            self.BPMtable.endUpdates()
            
            // get index of the user
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })
            
            if (self.suggestedList.count == 30) {

                // if the song is already saved, upon search, make the bookmark filled
                if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                    let saved = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)
                    if saved!.firstIndex(where: { (item) -> Bool in
                        item?.id == suggestedList[indexPath.row]?.id!
                    }) != nil {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                    }
                    else {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
                    }
                }
            }
            // save/unsave songs from the search page
            cell.actionBlock = {
                // make the bookmark empty if the song is not saved already
                let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                    item?.username == self.users_name
                })
                
                if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                    if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)!.firstIndex(where: { (item) -> Bool in
                        item?.id == self.suggestedList[indexPath.row]?.id!
                    }) != nil {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
                        
                        // get index of the song in the user's saved song list
                        if let songIndex = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)!.firstIndex(where: { (item) -> Bool in
                            item?.id == self.suggestedList[indexPath.row]?.id!
                        }) {
                            self.savedTable.beginUpdates()
                            
                            // delete the song from the saved songs table
                            self.savedTable.deleteRows(at: [(IndexPath(row: songIndex, section:0))], with: .automatic)
                            ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.deleteSavedSong(id: self.suggestedList[indexPath.row]?.id!))
                            
                            self.savedTable.endUpdates()
                            self.songTable.reloadData()
                            self.recommendedTable.reloadData()
                            self.BPMtable.reloadData()
                            
                            // user deletes last and only song in saved songs
                            if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) == nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! == 0{
                                print("User's saved songs list is now empty")
                                self.noSongsLabel.isHidden = false
                                self.savedView.bringSubviewToFront(self.noSongsLabel)
                                self.savedTable.isHidden = true
                            }
                        }
                    }
                    else {
                        // change bookmark to fill to represent saved
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                        
                        // create saved object to append to user's saved songs list
                        var newSaved = saved()
                        newSaved.title = self.suggestedList[indexPath.row]?.Title!
                        newSaved.artist = self.suggestedList[indexPath.row]?.Artist!
                        newSaved.id = self.suggestedList[indexPath.row]?.id!
                        newSaved.bpm = self.suggestedList[indexPath.row]?.BPM!
                        if (self.suggestedList[indexPath.row]?.artistImage != nil) {
                            newSaved.imagePreview = self.suggestedList[indexPath.row]?.artistImage!
                        }
                        
                        // add new song to users data
                        ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.addSavedSong(song: newSaved))
                        self.savedTable.beginUpdates()
                        
                        // insert the new saved song to the saved songs page
                        self.savedTable.insertRows(at: [IndexPath(row:  ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! - 1, section: 0)], with: .automatic)
                        self.savedTable.endUpdates()
                        self.songTable.reloadData()
                        self.recommendedTable.reloadData()
                        self.BPMtable.reloadData()
                    }
                }
                // savedSongs is empty
                else {
                    // change bookmark to fill to represent saved
                    cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                    
                    if (self.suggestedList.count == 30) {
                    
                        // create saved object to append to user's saved songs list
                        var newSaved = saved()
                        newSaved.title = self.suggestedList[indexPath.row]?.Title!
                        newSaved.artist = self.suggestedList[indexPath.row]?.Artist!
                        newSaved.id = self.suggestedList[indexPath.row]?.id!
                        newSaved.bpm = self.suggestedList[indexPath.row]?.BPM!
                        newSaved.imagePreview = self.suggestedList[indexPath.row]?.artistImage
                        
                        // add new song to users data
                        ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.addSavedSong(song: newSaved))
                        self.savedTable.beginUpdates()
                        
                        // insert the new saved song to the saved songs page
                        self.savedTable.insertRows(at: [IndexPath(row:  ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! - 1, section: 0)], with: .automatic)
                        self.savedTable.endUpdates()
                        self.songTable.reloadData()
                        self.recommendedTable.reloadData()
                        self.BPMtable.reloadData()
                    }
                }
            } // end actionblock

            return cell
        }
        
        else if tableView == savedTable {
            // get the index of the current user
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })
            
            // get prototype cell to modify contents
            let cell = savedTable.dequeueReusableCell(withIdentifier: "saved_cell", for: indexPath) as! SearchTableViewCell

            // modify title and artist labels in cell
            cell.titleLabel?.text = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs[indexPath.row]?.title)
            cell.artistLabel?.text = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs[indexPath.row]?.artist)
            
            // all cells should look saved, since it only displays saved songs
            cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
        
            // Unsave song in saved songs tab
            // The only option in the saved songs tab is to unsave, since the table only shows saved songs
            cell.actionBlock = {
                // make the bookmark empty if the song is not saved already
                let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                    item?.username == self.users_name
                })
                
                // if user has songs saved
                if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                    
                    cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
                                        
                    // delete the song from the saved songs table
                    var idToDelete:String?
                    idToDelete = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs[indexPath.row]?.id!)
                    
                    // delete from user's saved songs and remove from savedTable
                    ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.deleteSavedSong(id: idToDelete))
                    self.savedTable.deleteRows(at: [(IndexPath(row: indexPath.row, section:0))], with: .automatic)
                    
                    // reload all data in all tables
                    self.savedTable.reloadData()
                    self.songTable.reloadData()
                    self.recommendedTable.reloadData()
                    self.BPMtable.reloadData()
                    
                    // if user's saved songs list is empty
                    if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) == nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! == 0{
                        print("User's saved songs list is now empty (savedTable)")
                        self.noSongsLabel.isHidden = false
                        self.savedView.bringSubviewToFront(self.noSongsLabel)
                        self.savedTable.isHidden = true
                    }

                }
            } // end of actionBlock
            return cell
        } // end if savedTable
        else if tableView == recommendedTable {
            if(selectedRange == "slow") {
                recommendedList = slowPacedList
                DispatchQueue.main.async {
                    self.recommendedTable.beginUpdates()
                    self.recommendedTable.endUpdates()
                }
            }
            else if (selectedRange == "moderate") {
                recommendedList = moderateList
                DispatchQueue.main.async {
                    self.recommendedTable.beginUpdates()
                    self.recommendedTable.endUpdates()
                }
            }
            else if (selectedRange == "upbeat") {
                recommendedList = upbeatList
                DispatchQueue.main.async {
                    self.recommendedTable.beginUpdates()
                    self.recommendedTable.endUpdates()
                }
            }
            
            let cell = recommendedTable.dequeueReusableCell(withIdentifier: "slow_cell", for: indexPath) as! SearchTableViewCell
                     
            self.recommendedTable.beginUpdates()
            if recommendedList.count != 0 {
                cell.titleLabel?.text = recommendedList[indexPath.row]?.Title!
                cell.artistLabel?.text = recommendedList[indexPath.row]?.Artist!
            }
            self.recommendedTable.endUpdates()
            
            // get index of the user
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })
            
            if (self.recommendedList.count == 30) {

                // if the song is already saved, upon search, make the bookmark filled
                if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                    let saved = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)
                    if saved!.firstIndex(where: { (item) -> Bool in
                        item?.id == recommendedList[indexPath.row]?.id!
                    }) != nil {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                    }
                    else {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
                    }
                }
            
            }
            
            // save/unsave songs from the recommended table
            cell.actionBlock = {
                // make the bookmark empty if the song is not saved already
                let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                    item?.username == self.users_name
                })
                
                // if there are saved songs
                if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                    // check for song in both recommended and user data
                    if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)!.firstIndex(where: { (item) -> Bool in
                        item?.id == self.recommendedList[indexPath.row]?.id!
                    }) != nil {
                        // bookmark should be empty to represent not saved
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
                        
                        // get index of the song in the user's saved song list
                        if let songIndex = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)!.firstIndex(where: { (item) -> Bool in
                            item?.id == self.recommendedList[indexPath.row]?.id!
                        }) {
                            self.savedTable.beginUpdates()
                            
                            // delete the song from the saved songs table
                            self.savedTable.deleteRows(at: [(IndexPath(row: songIndex, section:0))], with: .automatic)
                            ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.deleteSavedSong(id: self.recommendedList[indexPath.row]?.id!))
                            
                            self.savedTable.endUpdates()
                            self.songTable.reloadData()
                            self.recommendedTable.reloadData()
                            self.BPMtable.reloadData()
                            
                            // if the user unsaves the only song in the table
                            if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) == nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! == 0{
                                print("User's saved songs list is now empty")
                                self.noSongsLabel.isHidden = false
                                self.savedView.bringSubviewToFront(self.noSongsLabel)
                                self.savedTable.isHidden = true
                            }
                        }
                    }
                    // else there exists saved songs
                    else {
                        // change bookmark to fill to represent saved
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                        
                        // create saved object to append to user's saved songs list
                        var newSaved = saved()
                        newSaved.title = self.recommendedList[indexPath.row]?.Title!
                        newSaved.artist = self.recommendedList[indexPath.row]?.Artist!
                        newSaved.id = self.recommendedList[indexPath.row]?.id!
                        newSaved.bpm = self.recommendedList[indexPath.row]?.BPM!
                        newSaved.imagePreview = self.recommendedList[indexPath.row]?.artistImage
                        
                        // add new song to user data
                        ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.addSavedSong(song: newSaved))
                        self.savedTable.beginUpdates()
                        
                        // insert the new saved song to the saved songs page
                        self.savedTable.insertRows(at: [IndexPath(row:  ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! - 1, section: 0)], with: .automatic)
                        self.savedTable.endUpdates()
                        self.songTable.reloadData()
                        self.recommendedTable.reloadData()
                        self.BPMtable.reloadData()
                    }
                }
                // else savedSongs is empty
                else {
                    // show the bookmark as filled to represent saved
                    cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                    
                    // create saved object to append to user's saved songs list
                    var newSaved = saved()
                    newSaved.title = self.recommendedList[indexPath.row]?.Title!
                    newSaved.artist = self.recommendedList[indexPath.row]?.Artist!
                    newSaved.id = self.recommendedList[indexPath.row]?.id!
                    newSaved.bpm = self.recommendedList[indexPath.row]?.BPM!
                    newSaved.imagePreview = self.recommendedList[indexPath.row]?.artistImage

                    // add new song to user data
                    ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.addSavedSong(song: newSaved))
                    self.savedTable.beginUpdates()
                    
                    // insert the new saved song to the saved songs page
                    self.savedTable.insertRows(at: [IndexPath(row:  ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! - 1, section: 0)], with: .automatic)
                    self.savedTable.endUpdates()
                    self.songTable.reloadData()
                    self.recommendedTable.reloadData()
                    self.BPMtable.reloadData()
                }
                
            } // end actionblock
            
            return cell
            
        } // end if recommendedTable
                        
        
        return UITableViewCell()
    }   // cellForRowAt (tableView -> search page)
    
    
    
    
    
    // --------------- FEATURED PANEL (TEXT IN IMAGE) ---------------
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint, fontSize: Int) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Neue", size: CGFloat(fontSize))!

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))

        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    } // end textToImage
    
    
    
    
    
    // --------------- FEATURED PANEL (iCAROUSEL) ---------------
    
    // Featured Panel Carousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 6    // 6 images to display
    } // end numberOfItems
    
    // featured panel uses cocoapods for iCarousel
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var tempJuiceImg:UIImage = textToImage(drawText: "Your Beat, Your Style", inImage: UIImage(named: "juice-wrld-ellie-goulding")!, atPoint: CGPoint(x: 20,y: 300), fontSize: 60)
        var tempMacImg:UIImage = textToImage(drawText: "Discover More Songs", inImage: UIImage(named: "mac_miller")!, atPoint: CGPoint(x: 20,y: 350), fontSize: 70)
        var tempKhalidImg:UIImage = textToImage(drawText: "Feel The Music", inImage: UIImage(named: "khalid")!, atPoint: CGPoint(x: 20,y: 455), fontSize: 105)
        var tempLanaImg:UIImage = textToImage(drawText: "Save Your Favorite Songs", inImage: UIImage(named: "lana")!, atPoint: CGPoint(x: 120,y: 1400), fontSize: 240)
        var tempBillieImg:UIImage = textToImage(drawText: "Top Recommended Songs", inImage: UIImage(named: "billie")!, atPoint: CGPoint(x: 20,y: 255), fontSize: 50)
        var tempAliciaImg:UIImage = textToImage(drawText: "Heartbeat Feature", inImage: UIImage(named: "alicia_keys")!, atPoint: CGPoint(x: 20,y: 235), fontSize: 55)
        
        featImages = [
            textToImage(drawText: "Change up your profile information in profile settings", inImage: tempJuiceImg, atPoint: CGPoint(x: 20,y: 370), fontSize: 30) ,
            textToImage(drawText: "Search any song title to view it's information", inImage: tempMacImg, atPoint: CGPoint(x: 20,y: 430), fontSize: 35) ,
            textToImage(drawText: "Find songs based on your heart rate", inImage: tempKhalidImg, atPoint: CGPoint(x: 20,y: 568), fontSize: 52) ,
            textToImage(drawText: "Bookmark your favorite songs to view later", inImage: tempLanaImg, atPoint: CGPoint(x: 120,y: 1700), fontSize: 120) ,
            textToImage(drawText: "Find popular songs in the Recommended section", inImage: tempBillieImg, atPoint: CGPoint(x: 20,y: 315), fontSize: 25) ,
            textToImage(drawText: "Get a live feed of your heart rate through the camera", inImage:tempAliciaImg, atPoint: CGPoint(x: 20,y: 295), fontSize: 27)
        ]
        
        // create a uiview to contain the image
        let view = UIView(frame:CGRect(x: 7, y: 80, width: self.view.frame.size.width/1.05, height: 225))
        view.layer.cornerRadius = 5
        
        // create imageview to put inside view
        let imageView = UIImageView(frame: view.bounds)
        imageView.layer.cornerRadius = 5
        
        // add imageview to the view
        view.addSubview(imageView)
        
        // characteristics of carousel look
        //imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true  // causes the image to have round corners
        imageView.image = featImages[index] // displays the image in the imageview
        
        return view
    } // end viewForItemAt
    
    
    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}   // end HomeController class

