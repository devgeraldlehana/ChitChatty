//
//  KeychainService.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import Foundation
import Security
import LocalAuthentication

let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)
let kSecUseOperationPromptValue = NSString(format: kSecUseOperationPrompt)

private let service = "za.co.lehana.gerald.ChitChatty"

public class KeychainService: NSObject {
    
    class func isBiometricsAvailable() -> Bool {
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    class func biometricValidation(withReason reason:String, completion: @escaping (Bool) -> Void){
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason:reason, reply: { (success, error) in
                completion(success)
                if !success {
                    print("biometricValidation failed: \(error?.localizedDescription ?? "")")
                }
            })
    }
    
    class func updatePassword(account:String, data: String) {
        if let dataFromString: Data = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
            
            let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue:dataFromString] as CFDictionary)
            print("KeychainService Update Status: \(status)")
        }
    }
    
    class func removePassword(account:String) {
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        let status = SecItemDelete(keychainQuery as CFDictionary)
        print("KeychainService Remove Status: \(status)")
    }
    
    class func savePassword(account:String, data: String) {
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            print("KeychainService Save Status: \(status)")
        }
    }
    
    class func loadPassword(account:String) -> String? {
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        } else {
            print("KeychainService Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
    
    class func saveDefault(username: String, password:String) {
        savePassword(account: "ChitChatty", data: username)
        savePassword(account: username, data: password)
    }
    
    class func retrieveDefault() -> String? {
        return loadPassword(account: "ChitChatty")
    }
    
}


