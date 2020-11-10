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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        featured.layer.borderColor = UIColor.lightGray.cgColor
        featured.layer.borderWidth = 1.0
        featured.layer.cornerRadius = 5
        first_recomm.layer.borderColor = UIColor.lightGray.cgColor
        first_recomm.layer.borderWidth = 1.0
        first_recomm.layer.cornerRadius = 5
        second_recomm.layer.borderColor = UIColor.lightGray.cgColor
        second_recomm.layer.borderWidth = 1.0
        second_recomm.layer.cornerRadius = 5
        third_recomm.layer.borderColor = UIColor.lightGray.cgColor
        third_recomm.layer.borderWidth = 1.0
        third_recomm.layer.cornerRadius = 5
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
