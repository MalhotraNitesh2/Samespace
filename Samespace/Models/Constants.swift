//
//  Constants.swift
//  Samespace
//
//  Created by Nitesh Malhotra on 26/02/24.
//

import Foundation
enum Constants
{
    enum API {
        static let productURL = "https://cms.samespace.com/items/songs"
    }
    
    enum DataError : Error
    {
        case invalidResponde
        case invalidURL
        case invalidData
        case network(Error?)
    }
    enum CoverImage
    {
        static let imageURL = "https://cms.samespace.com/assets/"
    }
}
