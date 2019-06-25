//
//  ViewController.swift
//  AES-256-Demo
//
//  Created by le.huu.dung on 6/25/19.
//  Copyright © 2019 le.huu.dung. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let plainText = "API001"
        
        
        

        let keyArr: [UInt8] = Array.init(1...32)
        let ivARr: [UInt8] = Array.init(1...16)
        
        let encryptText = "API001".AESEncript(key: keyArr.convertArrUInt8toString(), iv: ivARr.convertArrUInt8toString())
        print("ma hoa: \(encryptText)")
        print("gia ma: \(encryptText.AESDecrypt(key: keyArr.convertArrUInt8toString(), iv: ivARr.convertArrUInt8toString()))")
        
        
    }
    
    


}

extension String {
    func AESEncript(key: String, iv: String) -> String {
        // convert keyString to [UInit8]
        guard let keyArrUInt8: [UInt8] = key.convertStringtoArrUInt8(),
            let ivArrUInt8:[UInt8] = iv.convertStringtoArrUInt8() else {
                return ""
        }
        
        let aes = try? AES.init(key: "08D3AA75E8F39BC8255E76F4533CBA4D".convertStringtoArrUInt8(), blockMode: CTR.init(iv: ivArrUInt8), padding: .pkcs7)
        guard let convertData = self.data(using: String.Encoding.utf8),
            let encryptText = try? aes?.encrypt(convertData.bytes) else {
            return ""
        }
        return encryptText!.toBase64()!
        
    }
    
    func AESDecrypt(key: String, iv: String) -> String {
        guard let keyArrUInt8: [UInt8] = key.convertStringtoArrUInt8(),
            let ivArrUInt8:[UInt8] = iv.convertStringtoArrUInt8() else {
                return ""
        }
        
        let aes = try? AES.init(key: "08D3AA75E8F39BC8255E76F4533CBA4D".convertStringtoArrUInt8(), blockMode: CTR.init(iv: ivArrUInt8), padding: .pkcs7)
        guard let convertData = Data.init(base64Encoded: self),
            let decryptText = try? aes?.decrypt(convertData.bytes) else {
                return ""
        }
        
        return String.init(bytes: decryptText!, encoding: String.Encoding.utf8)!
    }
    
    func convertStringtoArrUInt8() -> [UInt8] {
        return Array(self.utf8)
    }
    
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    
}

extension Array {
    func convertArrUInt8toString() -> String {
        let arrUInt8: [UInt8] = self as! [UInt8]
        let resultNSString = NSString.init(bytes: arrUInt8, length: arrUInt8.count, encoding: String.Encoding.utf8.rawValue)
        return resultNSString as! String
    }
}


