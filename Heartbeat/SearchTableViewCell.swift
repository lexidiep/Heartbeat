//
//  SearchTableViewCell.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/12/20.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var bookmarkIcon: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var actionBlock: (() -> Void)? = nil
    
    
    @IBAction func bookmarkClicked(_ sender: UIButton) {
        actionBlock?()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
