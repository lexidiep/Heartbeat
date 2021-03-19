//
//  UserData.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/13/20.
//

import Foundation
import UIKit



// struct for saved songs by user
class saved {
    var title:String?
    var artist: String?
    var id:String?
    var bpm:String?
    var image:String?
    var imagePreview: UIImage?
}
// struct for individual user data
class userInfo {
    var username:String?
    var email:String?
    var password:String?
    var savedSongs:[saved?] = []
    var securityQuestion:String?
    var securityAnswer: String?
    var name: String?
    var profilePic: UIImage?
    
    func addSavedSong(song:saved?) {
        savedSongs.append(song)
    } // end addSavedSong function
    
    func deleteSavedSong(id:String?) {
        if savedSongs.count != 0 {
            if let songIndex = savedSongs.firstIndex(where: { (item) -> Bool in
                item?.id == id!
            }) {
                print("Removed \(savedSongs[songIndex]!)")
                savedSongs.remove(at: songIndex)
            }
            else {
                print("Song not found in saved Songs!")
            }
        }
    } // end deleteSavedSong function
    
} // end userInfo struct

