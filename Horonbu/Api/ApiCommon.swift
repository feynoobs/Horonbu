//
//  ApiCommon.swift
//  Horonbu
//
//  Created by 穴口昌宏 on 2022/05/11.
//

import Foundation
import CommonCrypto

protocol Undefined
{
    func start();
    func finish(result: String);
}

class ApiCommon
{
    private let entryPoint: String
    private let method: String
    
    private static let API_KEY = "2hSoAk98Pw9Vk6LNmXOO6hip6"
    private static let API_SECRET = "t7jHT6dysIJvPVzWORgex8FuHW2orZUEul1JzUazgFoaJqnaGx"
    public static let CALLBACK_URL = "twinida://";
    
    init(entryPoint: String, method: String)
    {
        self.entryPoint = entryPoint
        self.method = method
    }
    
    private func hmacSHA1(data: String, key: String) -> String
    {
        let dKey = key.data(using: .utf8)
        let dData = data.data(using: .utf8)
        let signature = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_SHA256_DIGEST_LENGTH))
        
        
        
    }
    
    public func startMain(params: Dictionary<String, String>, fixedToken: Dictionary<String, String>? = nil)
    {
        var headerParams: Dictionary<String, String> = [
            "oauth_consumer_key": Self.API_KEY,
            "oauth_nonce": String(NSDate().timeIntervalSince1970),
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": String(NSDate().timeIntervalSince1970),
            "oauth_version": "1.0"
        ]
        var signatureKey = Self.API_SECRET.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)! + "&"
        if fixedToken == nil {
            params.forEach {elem in
                if elem.key == "oauth_token_secret" {
                    signatureKey += elem.value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
                }
                else {
                    headerParams[elem.key] = elem.value
                }
            }
        }
        else {
            headerParams["oauth_token"] = fixedToken!["oauth_token"]
            signatureKey += fixedToken!["oauth_token_secret"]!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
            headerParams = headerParams.merging(params){ (current, _) in current}
        }
        
        let sortParams = headerParams.sorted { $0.key < $1.key }
        var query: String = ""
        sortParams.forEach { elem in
            let value = elem.value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
            query += "\(elem.key)=\(value)&"
        }
        query = String(query.remove(at: query.index(query.endIndex, offsetBy: -1)))
        let encodeUrl = entryPoint.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let signatureData = "\(method)&\(encodeUrl)&\(query)"
        //sortParams["oauth_signature"]
    }
}
