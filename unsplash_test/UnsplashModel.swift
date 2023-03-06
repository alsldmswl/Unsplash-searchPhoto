//
//  UnsplashModel.swift
//  unsplash_test
//
//  Created by eun-ji on 2023/03/05.
//

import Foundation

struct UnsplashModel: Codable {
    let total, totalPages: Int?
    let results: [UnsplashResult]
}
struct UnsplashResult: Codable {
    let alt_description: String?
    let urls: Urls
    
}
struct Urls: Codable {
    let full : String?
}
