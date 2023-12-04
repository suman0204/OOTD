//
//  KeychainManager.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/30.
//

import Foundation

final class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() { }
    
    private let service = Bundle.main.bundleIdentifier ?? ""
    
    //Create 메서드
    func create(account: String, value: String) {
        
        //query
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!
        ]
        
        // Delete - Key Chain은 Key값에 중복이 생기면 저장할 수 없어서 먼저 delete
        SecItemDelete(query)
        
        // Create
        let status: OSStatus = SecItemAdd(query, nil)
        assert(status == noErr, "KeyChain Create 실패")
    }
    
    //Read 메서드
    func read(account: String) -> String? {
        
        //query
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue, //CFData타입으로 불러와라
            kSecMatchLimit: kSecMatchLimitOne // 중복되는 경우 하나의 값만 가져와라
        ]
        
        //Read
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        //Read 성공 or 실패일 때
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } else {
            print("KeyChain Read 실패, status code = \(status)")
            return nil
        }
    }
    
    //Delete 메서드
    func delete(account: String) {
        
        //query
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        
        let status = SecItemDelete(query)
        assert(status == noErr, "KeyChain Delete 실패, status code = \(status) ")
    }
}
