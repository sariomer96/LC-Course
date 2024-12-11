//
//  Helper.swift
//  Learn Connect
//
//  Created by Omer on 7.12.2024.
//
import Foundation
import CommonCrypto
class Helper {
    
    static var shared = Helper()
    
   

    func hashPassword(password: String) -> String? {
    
        guard let passwordData = password.data(using: .utf8) else {
            return nil
        }
         
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        passwordData.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(passwordData.count), &hash)
        }
         
        let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
        return hashString
    }
      
}
