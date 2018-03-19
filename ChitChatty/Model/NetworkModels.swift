//
//  Login.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import Foundation

struct LoginInfo: Decodable {
    let result:Bool
    let error:String?
    let guid:String?
    let firstName:String?
    let lastName:String?
}

struct FriendsInfo: Decodable {
    let result:Bool
    let error:String?
    let friends:[Friends]?
}

struct Friends: Decodable {
    let firstName:String
    let lastName:String
    let alias:String
    let dateOfBirth:String
    let imageURL:String
    let status:String
}
