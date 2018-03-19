//
//  KeychainService.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import Foundation

// TODO:  Cant add a domain without a valid developer account 😭
let domain = "" as CFString

class SafariKeychainManager {
    
    class func checkCredential(completion: @escaping (_ account: String?, _ password: String?) ->() ){
        SecRequestSharedWebCredential(nil, nil) { credentials, error in
            guard error == nil else { return completion(nil, nil) }
            
            guard let credentials = credentials, CFArrayGetCount(credentials) > 0 else { return completion(nil, nil) }
            
            let unsafeCredential = CFArrayGetValueAtIndex(credentials, 0)
            let credential = unsafeBitCast(unsafeCredential, to: CFDictionary.self)
            let unsafeAccount = CFDictionaryGetValue(credential, Unmanaged.passUnretained(kSecAttrAccount).toOpaque())
            let account = unsafeBitCast(unsafeAccount, to: CFString.self) as String
            let unsafePassword = CFDictionaryGetValue(credential, Unmanaged.passUnretained(kSecSharedPassword).toOpaque())
            let password = unsafeBitCast(unsafePassword, to: CFString.self) as String
            
            completion(account, password)
            print(account, password)
        }
    }
    
    class func submitCredentials(account: String, password: String) {
        SecAddSharedWebCredential(domain, account as CFString, password as CFString, {(error: CFError!) -> Void in
            print("SecAddSharedWebCredential error: \(error)")
        });
    }
    
    class func deleteCredentials(account: String) {
        SecAddSharedWebCredential(domain, account as CFString, nil, {(error: CFError!) -> Void in
            print("SecAddSharedWebCredential error: \(error)")
        });
    }
    
    class func generatePassword() -> String {
        return SecCreateSharedWebCredentialPassword().unsafelyUnwrapped as String
    }
}
