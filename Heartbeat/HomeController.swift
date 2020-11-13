//
//  HomeController.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/7/20.
//

import UIKit

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

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
    
    
    // for recommended panels (home page)
    @IBOutlet weak var featured_slide: UICollectionView!
    @IBOutlet weak var featured_pageCtrl: UIPageControl!
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
    struct songInfo {var Title:String?
        var Artist:String?
        var BPM:String?}
    var songList = [songInfo?]()
    
    
    // saved page
    @IBOutlet weak var savedIcon: UIImageView!
    @IBOutlet weak var savedButton: UIButton!
    
    
    // profile page
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    
    
    // heartRate page
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var musicIcon: UIImageView!
    @IBOutlet weak var leftWaveIcon: UIImageView!
    @IBOutlet weak var rightWaveIcon: UIImageView!
    @IBOutlet weak var heartRateButton: UIButton!
    
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // featured panel attributes
        featured.layer.borderColor = UIColor.lightGray.cgColor
        featured.layer.borderWidth = 1.0
        featured.layer.cornerRadius = 5
        featured_slide.layer.cornerRadius = 5
        //featured_slide.delegate = self
        //featured_slide.dataSource = self
        
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
        
    }   // end viewDidLoad()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   // end didReceiveMemoryWarning()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }   // end viewDidLayoutSubviews()
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        searchView.endEditing(true)
        self.songTable.isHidden = false
    }
    
    
    @IBAction func searchFieldAction(_ sender: Any) {
        print("search was pressed")
    }
    
    
    // keyboard dismissal
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        searchSongs();
        songTable.isHidden = false
        return true;
    }   // end textFieldShouldReturn()
    
    
    // searches for songs through api
    func searchSongs() {
        // API
        getData()
    }

    
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
    
    
    // api function
    private func getData() {
        let song = self.searchField.text
        let searchReplace1 = song?.replacingOccurrences(of: " ", with: "+")
        let searchReplace2 = searchReplace1?.replacingOccurrences(of: "’", with: "")
        let searchReplace3 = searchReplace2?.replacingOccurrences(of: ",", with: "")
        let searchReplace4 = searchReplace3?.replacingOccurrences(of: "-", with: "+")
        let songToSearch = searchReplace4?.replacingOccurrences(of: ".", with: "")
        print(songToSearch!)
        let link = "https://api.getsongbpm.com/search/?api_key=c42bacc54624edfd4f3d4365f8025bab&type=song&lookup=\(songToSearch!)"
        var songID: String = ""
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //var bpm: String = ""
        
        guard let url = URL(string: link) else { print("found nil"); return }
        
        // first data grab
        let task = session.dataTask(with: url, completionHandler:{ data, response, error in
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
            if json.search?.count != nil {
                self.songListCount = json.search!.count
            
                for i in 0...(self.songListCount-1) {
                    var newSong:songInfo! = songInfo()
                    newSong.Title = json.search![i].title!
                    newSong.Artist = json.search![i].artist!.name!
                    newSong.BPM = ""
                    self.songList.append(newSong)
                    songID = json.search![i].id!
                    //self.getSongBPM(id: songID)
                }
            }
        })
        task.resume()
        
    }   // end getData()
    
    /*
    // get bpm of song
    func getSongBPM(id:String) {
        let config2 = URLSessionConfiguration.default
        let session2 = URLSession(configuration: config2)
        //var songBPM: String = ""
        
        let url2 = "https://api.getsongbpm.com/song/?api_key=c42bacc54624edfd4f3d4365f8025bab&id=\(id)"
        
        //print(url2)
        
        // final data grab
        let task2 = session2.dataTask(with: URL(string: url2)!, completionHandler:{ data, response, error in
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            
            // have data
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
            
            if json.song!.tempo != nil {
                //songBPM = json.song!.tempo!
                //print("BPM: \(json.song!.tempo!)\n")
            }
            else {
                //songBPM = "error"
            }
        })
         task2.resume()
    }
    */

    // action for home nav button clicked
    @IBAction func homeClicked(_ sender: Any) {
        // hide/show pages
        searchView.isHidden = true
        scrollView.isHidden = false
        topLogo.isHidden = false
        topSplitBar.isHidden = false
        
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
        scrollView.isHidden = true
        topLogo.isHidden = true
        topSplitBar.isHidden = true
        
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
    }   // end profileClicked()
    
    
    // data source/delegates (collection views)
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
        return UICollectionViewCell()
    }   // cellForItemAt (collectionView -> home page)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }   // collectionViewLayout (collectionView -> home page)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }   // layout (collectionView -> home page)
    
    
    // data source/delegates (table view)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = songTable.indexPathForSelectedRow!
        let selectedCell = songTable.cellForRow(at: indexPath) as! SearchTableViewCell
        print("You selected:\nTitle: \(selectedCell.titleLabel!.text!), Artist: \(selectedCell.artistLabel!.text!)")
    }   // didSelectRowAt (tableView -> search page)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.songListCount)
        return self.songListCount
    }   // numberOfRowsInSection (tableView -> search page)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = songTable.dequeueReusableCell(withIdentifier: "song_cell", for: indexPath) as! SearchTableViewCell
        print("Song list count: \(songListCount)")
        print("Song list: \(songList.count)")
        cell.titleLabel?.text = songList[indexPath.row]?.Title!
        cell.artistLabel?.text = songList[indexPath.row]?.Artist!
                
        return cell
    }   // cellForRowAt (tableView -> search page)
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}   // end HomeController class

