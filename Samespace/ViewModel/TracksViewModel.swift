//
//  TracksViewModel.swift
//  Samespace
//
//  Created by Nitesh Malhotra on 26/02/24.
//
import Foundation

class TracksViewModel {
    var tracks: [Track] = []
    private let apiManager = APIManager()
    
    func fetchTracks(completion: @escaping (Error?) -> Void) {
        apiManager.fetchTracks { tracks, error in
            if let error = error {
                completion(error)
            } else if let tracks = tracks {
                self.tracks = tracks
                completion(nil)
            }
        }
    }
}
