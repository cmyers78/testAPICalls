//
//  PKCSImport.swift
//  testAPICalls
//
//  Created by Christopher Myers on 12/7/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import Foundation

public class PKCSImport {
    var label : String?
    var keyID : Data?
    var trust : SecTrust?
    var certChain : [SecTrust]?
    var identity : SecIdentity?
    
    let securityError : OSStatus
    
    public init(data : Data, password : String) {
        var items : CFArray?
        
        let certOptions : Dictionary = [kSecImportExportPassphrase as String : password as String]
        
        // import certificate to read its entries
        // success or error will be return from the PKCS12 blob imported
        self.securityError = SecPKCS12Import(data as CFData, certOptions as CFDictionary, &items)
        
        // if successful import
        if securityError == errSecSuccess {
            let certItems : Array = (items! as Array)
            let dict : Dictionary<String, AnyObject> = certItems.first! as! Dictionary<String, AnyObject>
            
            self.label = dict[kSecImportItemLabel as String] as? String
            self.keyID = dict[kSecImportItemKeyID as String] as? Data
            self.trust = dict[kSecImportItemTrust as String] as! SecTrust?
            self.certChain = dict[kSecImportItemCertChain as String] as? Array<SecTrust>
            self.identity = dict[kSecImportItemIdentity as String] as! SecIdentity?
            
        }
    }
    
    public convenience init(mainBundleResource : String, resourceType : String, password : String) {
        self.init(data : NSData(contentsOfFile: Bundle.main.path(forResource: mainBundleResource, ofType: resourceType)!)! as Data, password : password)
        
    }
    
    public func urlCredential() -> URLCredential {
        return URLCredential(identity : self.identity!, certificates: self.certChain!, persistence: URLCredential.Persistence.forSession)
    }
    
}
