//
//  NetworkController.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import UIKit

class NetworkController {
    class func login(withUsername username:String, andPassword password:String, completion: @escaping (LoginInfo?) -> Void) {
        let body = ["username" : username, "password" : password]
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        var request = URLRequest(url: URL(string: "http://mobileexam.dstv.com/login")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
        request.httpBody = httpBody
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let data = data else { return }
            do {
                let loginInfo = try JSONDecoder().decode(LoginInfo.self, from: data)
                completion(loginInfo)
            } catch let err {
                completion(LoginInfo(result: false, error: err.localizedDescription, guid: nil, firstName: nil, lastName: nil))
                print("Login Error: \(err.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func retrieveFriends(withGUID guid:String, andLastname lastname:String, completion: @escaping (FriendsInfo?) -> Void) {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        var request = URLRequest(url: URL(string: "http://mobileexam.dstv.com/friends;uniqueID=\(guid);name=\(lastname)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let data = data else { return }
            do {
                let friendsinfo = try JSONDecoder().decode(FriendsInfo.self, from: data)
                completion(friendsinfo)
            } catch let err {
                completion(FriendsInfo(result: false, error: err.localizedDescription, friends: nil))
                print("Login Error: \(err.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func image(fromUrl url:String, completion: @escaping (UIImage?) -> Void) {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let data = data else { return }
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else { return }
            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
    }
}
