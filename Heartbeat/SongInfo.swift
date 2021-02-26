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

class Response2: Codable {
    let tempo: [RecommendedResult]?
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

class RecommendedResult: Codable {
    let song_id:String?
    let song_title:String?
    let song_uri:String?
    let tempo:String?
    let artist:ArtistInfo?
    let album:AlbumInfo?
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

class AlbumInfo: Codable {
    let title:String?
    let uri:String?
    let img:String?
    let year:String?
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
 
 TEMPO (BPM) QUERY
 {"tempo":
    [
        {"song_id":"J8NQ7D",
         "song_title":"Coon Town",
         "song_uri":"https:\/\/getsongbpm.com\/song\/coon-town\/J8NQ7D",
         "tempo":"40",
         "artist":{"id":"pYZYr","name":"Johnny Rebel",
            "uri":"https:\/\/getsongbpm.com\/artist\/johnny-rebel\/pYZYr",
            "img":"https:\/\/i.scdn.co\/image\/67684eed365510448a2e29e0e2ced55ede9cc08d",
            "genres":["country","folk"],
            "from":"US",
            "mbid":"2429da67-f80a-47ab-8bac-aad27316bdfe"
         }, // artist
         "album":
            {"title":"Johnny Rebel, Volume One",
             "uri":"https:\/\/getsongbpm.com\/album\/johnny-rebel-volume-one\/oKnlj",
             "img":"https:\/\/lastfm.freetls.fastly.net\/i\/u\/300x300\/b1f381d9fa7d3cb056bd98b7fdc120fa.png",
             "year":"2009"
             } // album
         } // song
    ]
 } // tempo
 */


