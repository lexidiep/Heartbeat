//
//  SongInfo.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/13/20.
//

import Foundation


class Response1: Codable {
    let search: [SongSearch]?
}

class FinalResponse: Codable {
    let song: SongResult?
}

class SongResult: Codable {
    let id: String?
    let title: String?
    let uri: String?
    let artist: ArtistInfo?
    let tempo: String?
    let time_sig: String?
    let key_of: String?
    let open_key: String?
}

class SongSearch: Codable {
    let id: String?
    let title: String?
    let uri: String?
    let artist: ArtistInfo?
}

class ArtistInfo: Codable {
    let id: String?
    let name: String?
    let uri: String?
    let img: String?
    let genres: [String]?
    let from: String?
    let mbid: String?
}

/*
 SEARCH QUERY
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
 
 SONG QUERY
    {"song":
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
            },
         "tempo":"172",
         "time_sig":"4\/4",
         "key_of":"Fm",
         "open_key":"9m"
        } // details
    } // song
 */
