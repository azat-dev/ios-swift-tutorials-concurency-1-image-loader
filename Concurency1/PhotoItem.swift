//
//  PhotoItem.swift
//  Concurency1
//
//  Created by Azat Kaiumov on 04.06.2021.
//

import Foundation

struct PhotoItem: Codable {
    let id: String
    let url: String
    let download_url: String
    let width: Int
    let height: Int
    let author: String
}
