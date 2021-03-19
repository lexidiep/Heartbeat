//
//  HomeController.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/7/20.
//

import UIKit
import iCarousel

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, iCarouselDataSource {
    
    
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
    
    
    // for recommended panels (home page)
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
    @IBOutlet weak var savedSongsLabel: UILabel!
    @IBOutlet weak var editProfilePicButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!

    
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
                      UIImage(named: "billie") ,
                      UIImage(named: "lana") ,
                      UIImage(named: "khalid") ,
                      UIImage(named: "alicia_keys") ]
    
    
    
    
    
    // --------------- VIEW DID LOAD ---------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.text = "Hi, \(users_name!)"
        welcomeLabel.textColor = .lightGray
        
        navBar.backgroundColor = .lightGray
        navBar.text = ""
        
        // featured panel attributes
        featured.layer.borderColor = UIColor.lightGray.cgColor
        featured.layer.borderWidth = 1.0
        featured.layer.cornerRadius = 5
        //featured_slide.layer.cornerRadius = 5
        //featured_slide.dataSource = self
        //featured_slide.delegate = self
        scrollView.addSubview(featCarousel)
        featCarousel.dataSource = self
        featCarousel.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: 283)
        
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
        // profile pic
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        // username/email Label
        usernameLabel.textColor = .lightGray
        usernameLabel.text = "\(users_name!)"
        emailLabel.textColor = .lightGray
        emailLabel.text?.append("   \(users_email!)")
        nameLabel.textColor = .lightGray
        savedSongsLabel.textColor = .lightGray
        
        // buttons
        deleteAccountButton.layer.cornerRadius = 5
        logOutButton.layer.cornerRadius = 5
        
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
        // API
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
        slow_slide.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        slow_pageCtrl.currentPage = currentIndex
        upbeat_slide.scrollToItem(at: IndexPath(item: currentIndex_upbeat, section: 0), at: .centeredHorizontally, animated: true)
        upbeat_pageCtrl.currentPage = currentIndex_upbeat
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
        recLoading.isHidden = false
        recLoading.startAnimating()
        self.recLoading.alpha = 1.0
    } // end upbeatClicked
    
    
    // user taps slow-paced panel
    @IBAction func slowClicked(_ sender: Any) {
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
        let song = self.searchField.text
        let searchReplace1 = song?.replacingOccurrences(of: " ", with: "+")
        let searchReplace2 = searchReplace1?.replacingOccurrences(of: "’", with: "")
        let searchReplace3 = searchReplace2?.replacingOccurrences(of: ",", with: "")
        let searchReplace4 = searchReplace3?.replacingOccurrences(of: "-", with: "+")
        let songToSearch = searchReplace4?.replacingOccurrences(of: ".", with: "")
        
        let link = "https://api.getsongbpm.com/search/?api_key=c42bacc54624edfd4f3d4365f8025bab&type=song&lookup=\(songToSearch!)"
        //let config = URLSessionConfiguration.default
        //let session = URLSession(configuration: config)
        
        guard let url = URL(string: link) else { print("found nil"); return }
        
        // first data grab
        let task = HomeController.sessionManager.dataTask(with: url, completionHandler:{ data, response, error in
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            
            // have data
            var result:Response1?
            do {
                result = try JSONDecoder().decode(Response1.self, from: data)
                DispatchQueue.main.async {
                    self.songListCount = (result?.search?.count)!
                    self.songTable.reloadData()
                 }
                
            }
            catch {
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
        
        for i in 0...(images.count-1) {
            
            // url for image urls
            let url3 = images[i]
            
            print(images[i])
            
            // task for image data grab
            let task3 = HomeController.sessionManager.dataTask(with: URL(string: url3)!, completionHandler:{ data, response, error in
                guard let data = data, let downloadedImg = UIImage(data: data), error == nil else {
                    print("Something went wrong")
                    return
                }
                
                // try to get data from api
                DispatchQueue.main.async{

                    if (self.getSongFromWhere == "search") {
                        if let index = self.songList.firstIndex(where: {$0?.imageURL == self.imageURLs[i]}) {
                            self.songList[index]?.artistImage = downloadedImg
                        }

                        self.songTable.reloadData()
                        
                        let topIndex = IndexPath(row: 0, section: 0)
                        self.songTable.scrollToRow(at: topIndex, at: .top, animated: false)
                    }
                    else if (self.getSongFromWhere == "slow") {
                        if let index = self.slowPacedList.firstIndex(where: {$0?.imageURL == self.slowImgURLs[i]}) {
                            self.slowPacedList[index]?.artistImage = downloadedImg
                        }

                        self.recommendedTable.reloadData()
                        
                        let topIndex = IndexPath(row: 0, section: 0)
                        self.recommendedTable.scrollToRow(at: topIndex, at: .top, animated: false)
                    }
                    else if (self.getSongFromWhere == "upbeat") {
                        if let index = self.upbeatList.firstIndex(where: {$0?.imageURL == self.upbeatImgURLs[i]}) {
                            self.upbeatList[index]?.artistImage = downloadedImg
                        }

                        self.recommendedTable.reloadData()
                        
                        let topIndex = IndexPath(row: 0, section: 0)
                        self.recommendedTable.scrollToRow(at: topIndex, at: .top, animated: false)
                    }
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
                     //self.songListCount = json.search!.count
                    
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
                    
                    self.recommendedTable.isHidden = false
                    self.recLoading.isHidden = true
                    self.recLoading.alpha = 0.0
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
                    self.recommendedTable.isHidden = false
                    self.recLoading.isHidden = true
                    self.recLoading.alpha = 0.0
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
                    self.recommendedTable.isHidden = false
                    self.recLoading.isHidden = true
                    self.recLoading.alpha = 0.0
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
        if (!onRecommended) {
            scrollView.isHidden = false
            topLogo.isHidden = false
            topSplitBar.isHidden = false
            backButton.isHidden = true
            recommendedView.isHidden = true
        }
        else {
            recommendedView.isHidden = false
            backButton.isHidden = false
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
        scrollView.isHidden = true
        topLogo.isHidden = true
        topSplitBar.isHidden = true
        profileView.isHidden = true
        backButton.isHidden = true
        recommendedView.isHidden = true
        
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
        
        backButton.isHidden = true
        recommendedView.isHidden = true
        
        
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
    }   // end heartRateClicked()
    
    
    // action for saved nav button clicked
    @IBAction func savedClicked(_ sender: Any) {
        // hide/show pages
        savedView.isHidden = false
        searchView.isHidden = true
        scrollView.isHidden = true
        topLogo.isHidden = false
        topSplitBar.isHidden = true
        profileView.isHidden = true
        backButton.isHidden = true
        recommendedView.isHidden = true
        
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
        scrollView.isHidden = true
        topLogo.isHidden = false
        topSplitBar.isHidden = true
        profileView.isHidden = false
        backButton.isHidden = true
        recommendedView.isHidden = true
                
    }   // end profileClicked()
    
    
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
    
    // COLLECTION VIEW
    // hide table when user starts typing in search
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.songTable.isHidden = true
    }   // didBeginEditing (text field -> search page)
    
    
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
        else if tableView == savedTable {
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })
            if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) != nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0  {
                noSongsLabel.isHidden = true
                savedTable.isHidden = false
                count = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)!
            }
            else if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) == nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) == 0{
                noSongsLabel.isHidden = false
                savedTable.isHidden = true
            }
        }
        else if tableView == recommendedTable {
            count = self.recommendedTableCount
            //self.recLoading.stopAnimating()
            //self.recLoading.isHidden = true
            //self.recommendedTable.isHidden = false
            
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
            
            // if song is saved, filled bookmark should show on search
            if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)!.firstIndex(where: { (item) -> Bool in
                    item?.id != self.songList[indexPath.row]?.id!
                }) != nil {
                    cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
                }
                else {
                    cell.bookmarkIcon.image
                        = UIImage(systemName: "bookmark.fill")
                }
            }
            // if user has an empty saved songs list
            else {
                cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
            }

            // if the song is already saved, upon search, make the bookmark filled
            if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                let saved = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)
                if saved!.firstIndex(where: { (item) -> Bool in
                    item?.id == songList[indexPath.row]?.id!
                }) != nil {
                    cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
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
                            
                            if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) == nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! == 0{
                                print("User's saved songs list is now empty")
                                self.noSongsLabel.isHidden = false
                                self.savedView.bringSubviewToFront(self.noSongsLabel)
                                self.savedTable.isHidden = true
                            }
                        }
                    }
                    else {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                        
                        // create saved object to append to user's saved songs list
                        var newSaved = saved()
                        newSaved.title = self.songList[indexPath.row]?.Title!
                        newSaved.artist = self.songList[indexPath.row]?.Artist!
                        newSaved.id = self.songList[indexPath.row]?.id!
                        newSaved.bpm = self.songList[indexPath.row]?.BPM!
                        newSaved.imagePreview = self.songList[indexPath.row]?.artistImage!
                        //get bpm from api
                        ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.addSavedSong(song: newSaved))
                        self.savedTable.beginUpdates()
                        
                        // insert the new saved song to the saved songs page
                        self.savedTable.insertRows(at: [IndexPath(row:  ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! - 1, section: 0)], with: .automatic)
                        self.savedTable.endUpdates()
                    }
                }
                // savedSongs is empty
                else {
                    cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                    
                    // create saved object to append to user's saved songs list
                    var newSaved = saved()
                    newSaved.title = self.songList[indexPath.row]?.Title!
                    newSaved.artist = self.songList[indexPath.row]?.Artist!
                    newSaved.id = self.songList[indexPath.row]?.id!
                    newSaved.bpm = self.songList[indexPath.row]?.BPM!
                    newSaved.imagePreview = self.songList[indexPath.row]?.artistImage
                    //get bpm from api
                    ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.addSavedSong(song: newSaved))
                    self.savedTable.beginUpdates()
                    
                    // insert the new saved song to the saved songs page
                    self.savedTable.insertRows(at: [IndexPath(row:  ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! - 1, section: 0)], with: .automatic)
                    self.savedTable.endUpdates()
                }
            } // end actionblock

            return cell
        } // end if songTable
        
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
                    
                    self.savedTable.reloadData()
                    self.songTable.reloadData()
                    self.recommendedTable.reloadData()
                    
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
            var recommendedList = [songInfo?]()
            if(selectedRange == "slow") {
                recommendedList = slowPacedList
            }
            else if (selectedRange == "moderate") {
                recommendedList = moderateList
            }
            else if (selectedRange == "upbeat") {
                recommendedList = upbeatList
            }
            
            let cell = recommendedTable.dequeueReusableCell(withIdentifier: "slow_cell", for: indexPath) as! SearchTableViewCell
                     
            self.recommendedTable.beginUpdates()
            if recommendedList.count != 0 {
                cell.titleLabel?.text = recommendedList[indexPath.row]?.Title!
                cell.artistLabel?.text = recommendedList[indexPath.row]?.Artist!
            }
            self.recommendedTable.endUpdates()
            //self.recommendedTable.isHidden = false
            //self.recLoading.isHidden = true
            
            // get index of the user
            let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                item?.username == users_name
            })
            
            // if song is saved, filled bookmark should show
            if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)!.firstIndex(where: { (item) -> Bool in
                    item?.id != recommendedList[indexPath.row]?.id!
                }) != nil {
                    cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
                }
                else {
                    cell.bookmarkIcon.image
                        = UIImage(systemName: "bookmark.fill")
                }
            }
            // if user has an empty saved songs list
            else {
                cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
            }

            // if the song is already saved, upon search, make the bookmark filled
            if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                let saved = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)
                if saved!.firstIndex(where: { (item) -> Bool in
                    item?.id == recommendedList[indexPath.row]?.id!
                }) != nil {
                    cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                }
            }
            
            
            // save/unsave songs from the recommended table
            cell.actionBlock = {
                // make the bookmark empty if the song is not saved already
                let userIndex = ((UIApplication.shared.delegate as! AppDelegate).userData).firstIndex(where: { (item) -> Bool in
                    item?.username == self.users_name
                })
                
                if (((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count) != 0) {
                    if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)!.firstIndex(where: { (item) -> Bool in
                        item?.id == recommendedList[indexPath.row]?.id!
                    }) != nil {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark")
                        
                        // get index of the song in the user's saved song list
                        if let songIndex = ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs)!.firstIndex(where: { (item) -> Bool in
                            item?.id == recommendedList[indexPath.row]?.id!
                        }) {
                            self.savedTable.beginUpdates()
                            
                            // delete the song from the saved songs table
                            self.savedTable.deleteRows(at: [(IndexPath(row: songIndex, section:0))], with: .automatic)
                            ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.deleteSavedSong(id: recommendedList[indexPath.row]?.id!))
                            
                            self.savedTable.endUpdates()
                            
                            if ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs) == nil || ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! == 0{
                                print("User's saved songs list is now empty")
                                self.noSongsLabel.isHidden = false
                                self.savedView.bringSubviewToFront(self.noSongsLabel)
                                self.savedTable.isHidden = true
                            }
                        }
                    }
                    else {
                        cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                        
                        // create saved object to append to user's saved songs list
                        var newSaved = saved()
                        newSaved.title = recommendedList[indexPath.row]?.Title!
                        newSaved.artist = recommendedList[indexPath.row]?.Artist!
                        newSaved.id = recommendedList[indexPath.row]?.id!
                        newSaved.bpm = self.songList[indexPath.row]?.BPM!
                        newSaved.imagePreview = self.songList[indexPath.row]?.artistImage
                        //get bpm from api
                        ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.addSavedSong(song: newSaved))
                        self.savedTable.beginUpdates()
                        
                        // insert the new saved song to the saved songs page
                        self.savedTable.insertRows(at: [IndexPath(row:  ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! - 1, section: 0)], with: .automatic)
                        self.savedTable.endUpdates()
                    }
                }
                // savedSongs is empty
                else {
                    cell.bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
                    
                    // create saved object to append to user's saved songs list
                    var newSaved = saved()
                    newSaved.title = recommendedList[indexPath.row]?.Title!
                    newSaved.artist = recommendedList[indexPath.row]?.Artist!
                    newSaved.id = recommendedList[indexPath.row]?.id!
                    newSaved.bpm = self.songList[indexPath.row]?.BPM!
                    newSaved.imagePreview = self.songList[indexPath.row]?.artistImage
                    //get bpm from api
                    ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.addSavedSong(song: newSaved))
                    self.savedTable.beginUpdates()
                    
                    // insert the new saved song to the saved songs page
                    self.savedTable.insertRows(at: [IndexPath(row:  ((UIApplication.shared.delegate as! AppDelegate).userData[userIndex!]?.savedSongs.count)! - 1, section: 0)], with: .automatic)
                    self.savedTable.endUpdates()
                }
                
            } // end actionblock
            
            return cell
            
        } // end if recommendedTable
                        
        
        return UITableViewCell()
    }   // cellForRowAt (tableView -> search page)
    
    
    
    
    
    // --------------- FEATURED PANEL ---------------
    
    // Featured Panel Carousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 6
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame:CGRect(x: 0, y: 80, width: 374, height: 283))
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 5, y: 0, width: 374, height: 283)
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.image = featImages[index]
        return view
    }
    
    
    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}   // end HomeController class

