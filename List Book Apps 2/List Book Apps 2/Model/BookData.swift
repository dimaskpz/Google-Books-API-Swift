//
//  BookData.swift
//  List Book Apps 2
//
//  Created by dimas pratama on 22/01/20.
//  Copyright © 2020 dimas pratama. All rights reserved.
//
import Foundation

struct BookData:Decodable {
    let kind:String
    let totalItems:Int
    let items:[Items]
}

struct Items:Decodable {
    let volumeInfo:VolumeInfo
}
    
struct VolumeInfo:Decodable {
    let title:String
    let authors:[String]!
    let publishedDate:String?
    let imageLinks:ImageLinks?
    let averageRating:Double?
}

struct ImageLinks:Decodable {
    let thumbnail:String?
}
