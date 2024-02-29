//
//  TrackModel.swift
//  Samespace
//
//  Created by Nitesh Malhotra on 26/02/24.
//

import Foundation
import UIKit
struct TracksResponse: Decodable {
    let data: [Track]
}

struct Track: Decodable {
    let id: Int
    let status: String
    let sort: String?
    let user_created: String
    let date_created: String
    let user_updated: String
    let date_updated: String
    let name: String
    let artist: String
    let accent: String
    let cover: String?
    let top_track: Bool
    let url: URL
}
