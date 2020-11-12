//
//  HomeController.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/7/20.
//

import UIKit
import SwiftUI

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    }   // end viewDidLoad()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   // end didReceiveMemoryWarning()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }   // end viewDidLayoutSubviews()

    
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // data source/delegates
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }   // layout (collectionView -> home page)
}   // end HomeController class


let url = "https://api.getsongbpm.com/search/?api_key=c42bacc54624edfd4f3d4365f8025bab&type=song&lookup="

struct Response: Codable {
    let search: SongSearch
}

struct SongSearch: Codable {
    let id: String
    let title: String
    let uri: String
    let artist: ArtistInfo
}

struct ArtistInfo: Codable {
    let id: String
    let name: String
    let uri: String
    let img: String
    let genres: [String]
    let from: String
    let mbid: String
}

/*
 WHAT A SEARCH RESULT FOR A SONG LOOKS LIKE
 {"search":
    [
        {"id":"57633B",
         "title":"Blinding Lights",
         "uri":"https:\/\/getsongbpm.com\/song\/blinding-lights\/57633B",
         "artist":
            {"id":"jvJjY",
             "name":"The Weeknd",
             "uri":"https:\/\/getsongbpm.com\/artist\/the-weeknd\/jvJjY",
             "img":"https:\/\/i.scdn.co\/image\/22c98f5bc7713315e8d3e48aa3ce8a98ce4ec873",
             "genres":["pop","r&b"],
             "from":"CA",
             "mbid":"c8b03190-306c-4120-bb0b-6f2ebfc06ea9"
            } //artist
        } //song
    ]
  } //search
 */
