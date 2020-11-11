//
//  HomeController.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/7/20.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var featured: UILabel!
    @IBOutlet weak var first_recomm: UILabel!
    @IBOutlet weak var second_recomm: UILabel!
    @IBOutlet weak var third_recomm: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var featured_panel: UIImageView!
    @IBOutlet weak var first_recomm_panel: UIImageView!
    @IBOutlet weak var second_recomm_panel: UIImageView!
    @IBOutlet weak var third_recomm_panel: UIImageView!
    
    
    var slowImages = ["antidote_travis_scott_66bpm", "congratulations_mac_miller_57bpm", "perfect_ed_sheeran_63bpm", "sign_of_the_times_harry_styles_60bpm", "something_just_like_this_chainsmokers_51bpm", "xanny_billie_eilish_50bpm"]
    
    var moderateImages = ["ariana-7-rings_70bpm", "humble_kendrick_lamar_76bpm", "lonely_justin_bieber_79bpm", "redbone_childish_gambino_81bpm", "watermelon_sugar_harry_styles_95bpm", "you-need-to-calm-down_taylor-swift_85bpm"]
    
    var fastImages = ["bad_and_boujee_migos_129bpm", "blinding_lights_weeknd_172bpm", "dangerous-woman_ariana-grande_136bpm", "dont_start_now_dua_lipa_123bpm", "laugh_now_cry_later_drake_133bpm", "power_kanye_west_152bpm", "thunder_imagine_dragons_166bpm"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        featured.layer.borderColor = UIColor.lightGray.cgColor
        featured.layer.borderWidth = 1.0
        featured.layer.cornerRadius = 5
        featured_panel.layer.cornerRadius = 5
        first_recomm.layer.borderColor = UIColor.lightGray.cgColor
        first_recomm.layer.borderWidth = 1.0
        first_recomm.layer.cornerRadius = 5
        first_recomm_panel.layer.cornerRadius = 5
        second_recomm.layer.borderColor = UIColor.lightGray.cgColor
        second_recomm.layer.borderWidth = 1.0
        second_recomm.layer.cornerRadius = 5
        second_recomm_panel.layer.cornerRadius = 5
        third_recomm.layer.borderColor = UIColor.lightGray.cgColor
        third_recomm.layer.borderWidth = 1.0
        third_recomm.layer.cornerRadius = 5
        third_recomm_panel.layer.cornerRadius = 5
        
        let timer1 = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {
            timer in self.first_recomm_panel.image = UIImage(named: self.fastImages.randomElement()!)
        }
        let timer2 = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {
            timer in self.second_recomm_panel.image = UIImage(named: self.slowImages.randomElement()!)
        }
        let timer3 = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {
            timer in self.third_recomm_panel.image = UIImage(named: self.moderateImages.randomElement()!)
        }
        timer1.fire()
        timer2.fire()
        timer3.fire()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
