//
//  Character.swift
//  BreakingBadApp
//
//  Created by Sasha Belov on 4.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import Foundation

struct Character: Codable {
    let charId: Int
    let name: String
    let birthday: String
    let occupation: [String]
    let image: String
    let status: String
    let nickname: String
    let appearance: [Int]
    let portrayed: String
    let category: String
    let betterCallSaulAppearance: [Int]
    
    enum CodingKeys: String, CodingKey {
           case charId = "char_id"
           case name
           case birthday
           case occupation
           case image = "img"
           case status
           case nickname
           case appearance
           case portrayed
           case category
           case betterCallSaulAppearance = "better_call_saul_appearance"
       }
}
