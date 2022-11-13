//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by Aaron Johncock on 13/11/2022.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [Video]
}

struct Video: Codable {
    let id: VideoID
}

struct VideoID: Codable {
    let kind: String
    let videoId: String
}
