//
//  API manager .swift
//  Samespace
//
//  Created by Nitesh Malhotra on 25/02/24.
//

import Foundation

typealias Handler = ([Track]?, Constants.DataError?) -> Void

final class APIManager {
    func fetchTracks(completion: @escaping Handler) {
        guard let url = URL(string: Constants.API.productURL) else {
            completion(nil, Constants.DataError.invalidData)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, Constants.DataError.invalidResponde)
                return
            }
            
            do {
                let tracksResponse = try JSONDecoder().decode(TracksResponse.self, from: data)
                completion(tracksResponse.data, nil)
            } catch {
                completion(nil, Constants.DataError.invalidResponde)
            }
        }.resume()
    }
}

