//
//  UserData.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/13/20.
//

import Foundation



// struct for saved songs by user
struct saved {
    var title:String?
    var artist: String?
    var id:String?
    var bpm:String?
}
// struct for individual user data
struct userInfo {
    var username:String?
    var email:String?
    var password:String?
    var savedSongs:[saved?]
    var securityQuestion:String?
    var securityAnswer: String?
    
    mutating func addSavedSong(song:saved?) {
        savedSongs.append(song)
    } // end addSavedSong function
    
    mutating func deleteSavedSong(id:String?) {
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

