//
//  HomeController.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/7/20.
//

import UIKit
import iCarousel

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, iCarouselDataSource {

    // home page
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
    @IBOutlet weak var upbeat_slide: UICollectionView!
    @IBOutlet weak var upbeat_pageCtrl: UIPageControl!
    @IBOutlet weak var slow_slide: UICollectionView!
    @IBOutlet weak var slow_pageCtrl: UIPageControl!
    @IBOutlet weak var moderate_slide: UICollectionView!
    @IBOutlet weak var moderate_pageCtrl: UIPageControl!
    
    
    // search page
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var songTable: UITableView!
    var songListCount:Int = 0
    struct songInfo {
        var Title:String?
        var Artist:String?
        var id:String?
        var BPM:String?
        var imageURL:String?
        var artistImage:UIImage?
    }
    var songList = [songInfo?]()
    @IBOutlet weak var songDetailsView: UIView!
    @IBOutlet weak var songDetailTitle: UILabel!
    @IBOutlet weak var songDetailArtist: UILabel!
    @IBOutlet weak var songDetailBPM: UILabel!
    @IBOutlet weak var songDetailImage: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    // saved page
    @IBOutlet weak var savedView: UIView!
    @IBOutlet weak var savedTable: UITableView!
    @IBOutlet weak var savedIcon: UIImageView!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var noSongsLabel: UILabel!
    
    
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
    
    
    // variables for recommended section (home page)
    var timer: Timer?
    var currentIndex = 0
    var currentIndex_upbeat = 0
    
    // image data for each panel
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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.text = "Hi, \(users_name!)"
        
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
        
        // upbeat panel attributes
        first_recomm.layer.borderColor = UIColor.lightGray.cgColor
        first_recomm.layer.borderWidth = 1.0
        first_recomm.layer.cornerRadius = 5
        upbeat_slide.layer.cornerRadius = 5
        upbeat_slide.delegate = self
        upbeat_slide.dataSource = self
        upbeat_pageCtrl.numberOfPages = fastImages.count
        
        // slow-paced panel attributes
        second_recomm.layer.borderColor = UIColor.lightGray.cgColor
        second_recomm.layer.borderWidth = 1.0
        second_recomm.layer.cornerRadius = 5
        slow_slide.layer.cornerRadius = 5
        slow_slide.delegate = self
        slow_slide.dataSource = self
        slow_pageCtrl.numberOfPages = slowImages.count
        
        // moderate panel attributes
        third_recomm.layer.borderColor = UIColor.lightGray.cgColor
        third_recomm.layer.borderWidth = 1.0
        third_recomm.layer.cornerRadius = 5
        moderate_slide.layer.cornerRadius = 5
        moderate_slide.delegate = self
        moderate_slide.dataSource = self
        moderate_pageCtrl.numberOfPages = moderateImages.count
        
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
        
        
        // profile page
        // profile pic
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        // username/email Label
        usernameLabel.text = "\(users_name!)"
        emailLabel.text?.append("   \(users_email!)")
        
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
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        searchView.endEditing(true)
        self.songTable.isHidden = false
    }
    
    
    // testing to check if search button is functional
    @IBAction func searchFieldAction(_ sender: Any) {
        print("search was pressed")
    }
    
    
    // keyboard dismissal
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
    
    
    
    
    
    // --------------- RETRIEVE SONG DATA FROM API ---------------
    
    // session manager
    static let sessionManager: URLSession = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30 // seconds
            configuration.timeoutIntervalForResource = 30 // seconds
            return URLSession(configuration: configuration)
    }()
    
    
    // api function
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

            self.songList.removeAll()
            self.songIDs.removeAll()
            self.imageURLs.removeAll()
            
            if json.search?.count != nil {
                self.songListCount = json.search!.count
            
                for i in 0...(self.songListCount-1) {
                    var newSong:songInfo! = songInfo()
                    newSong.Title = json.search![i].title!
                    newSong.Artist = json.search![i].artist!.name!
                    
                    // getting image url
                    var imageCode = ""
                    if (json.search![i].artist!.img != nil) {
                        imageCode = json.search![i].artist!.img!
                        //print(imageCode)
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
                }
            }
            
            // get the bpm's of the songs from search results
            self.getSongBPM(ids: self.songIDs)
            
            // get the images of the songs from search results
            self.getArtistImage(images: self.imageURLs)
                        
        }) // end task
        
        task.resume()
        
    }   // end getData()
    
    
    // get bpm of song
    func getSongBPM(ids:[String]) {

        for i in 0...(ids.count-1) {
        
            // url for song details api
            let url2 = "https://api.getsongbpm.com/song/?api_key=c42bacc54624edfd4f3d4365f8025bab&id=\(self.songIDs[i])"

            
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
    
    
    // get the image of artist to show in song details
    func getArtistImage(images:[String]) {
        
        for i in 0...(images.count-1) {
            
            // url for image urls
            let url3 = images[i]
            
            // task for bpm data grab
            let task3 = HomeController.sessionManager.dataTask(with: URL(string: url3)!, completionHandler:{ data, response, error in
                guard let data = data, let downloadedImg = UIImage(data: data), error == nil else {
                    print("Something went wrong")
                    return
                }
                
                // try to get data from api
                DispatchQueue.main.async{

                        if let index = self.songList.firstIndex(where: {$0?.imageURL == self.imageURLs[i]}) {
                            self.songList[index]?.artistImage = downloadedImg
                        }

                    self.songTable.reloadData()
                } // end dispatch queue
            }) // end of task2

            task3.resume()
            
        } // end for loop
        
    } // end of getArtistImage
    

    
    
    
    
    // -------------- NAVIGATION BUTTONS ---------------
    
    // action for home nav button clicked
    @IBAction func homeClicked(_ sender: Any) {
        // hide/show pages
        searchView.isHidden = true
        savedView.isHidden = true
        scrollView.isHidden = false
        topLogo.isHidden = false
        topSplitBar.isHidden = false
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
                
    }   // end profileClicked()
    
    
    
    // hides the song detail panel from view
    @IBAction func exitSongDetail(_ sender: Any) {
        
        songDetailsView.isHidden = true
        self.viewSlideCancel(view: songDetailsView)
        searchField.alpha = 1.0
        songTable.alpha = 1.0
        
    } // end exitSongDetail function
    
    
    
    
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
    
    
    // slide from top animation for cancel create account
    func viewSlideCancel(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        view.layer.add(transition, forKey: kCATransition)
    }   // end viewSlideCancel()
    
    
    
    
    
    // --------------- DATA SOURCE/DELEGATES ---------------
    
    // COLLECTION VIEW
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.songTable.isHidden = true
    }   // didBeginEditing (text field -> search page)
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }   // collectionViewLayout (collectionView -> home page)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }   // layout (collectionView -> home page)
    
    
    
    // TABLEVIEW
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
            self.viewSlideInFromTop(view: songDetailsView)
            searchField.alpha = 0.3
            songTable.alpha = 0.3
            
        }
        else if tableView == savedTable {
            let indexPath = savedTable.indexPathForSelectedRow!
            let selectedCell = savedTable.cellForRow(at: indexPath) as! SearchTableViewCell
        }
    }   // didSelectRowAt (tableView -> search page)
    
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
        return count
    }   // numberOfRowsInSection (tableView -> search page)
    
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}   // end HomeController class

