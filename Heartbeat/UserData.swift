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
}
// struct for individual user data
struct userInfo {
    var username:String?
    var email:String?
    var password:String?
    var savedSongs:[saved?]
    var securityQuestion:String?
    var securityAnswer: String?
}
