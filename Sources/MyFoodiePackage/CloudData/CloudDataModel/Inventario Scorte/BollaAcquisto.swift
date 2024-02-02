//
//  File.swift
//  
//
//  Created by Calogero Friscia on 04/12/23.
//

import Foundation

public struct BollaAcquisto:MyProStarterPack_L0{
    
    public let id:String
    
    public var rifIngrediente:String?
    public var nota:String?
    public var data:Date?
    public var user:String?
    
   // public var price:String?
   // public var quantity:String?
   // public var rifFornitore:String?
    
    /// Init con data corrente
   public init() {
        self.id = UUID().uuidString
        self.data = Date()//csTimeFormatter().data.string(from: Date())
    }
    /// init con data nil
   public init(nota: String) {
         self.id = UUID().uuidString
         self.nota = nota
     }
}

extension BollaAcquisto:Decodable {
    
    public static let codingInfo:CodingUserInfoKey = CodingUserInfoKey(rawValue: "BollaAcquisto")!
    
    public enum CodingKeys:String,CodingKey {
        
        case id
        case nota
        case data
        case rif = "rif_ingrediente"
        case user
    }
    
    
    public init(from decoder: Decoder) throws {
        
        let decodingCase = decoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .inbound
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch decodingCase {
            
        case .mainCollection:
            fallthrough
        case .subCollection:
            
            self.id = try container.decode(String.self, forKey: .id)
            self.rifIngrediente = try container.decode(String.self, forKey: .rif)
            self.data = try container.decode(Date.self, forKey: .data)
            self.nota = try container.decodeIfPresent(String.self, forKey: .nota)
            self.user = try container.decode(String.self, forKey: .user)
            
        case .inbound:
            self.id = UUID().uuidString
            self.data = try container.decodeIfPresent(Date.self, forKey: .data)
            self.nota = try container.decodeIfPresent(String.self, forKey: .nota)
            
        }
 
    }
    
   /* private func decodeSingleValue(_ value:String) -> (data:String?,nota:String?) {
        
        guard !value.isEmpty else {
            return (nil,nil)
        }
        
        let strings = value.split(separator: "_:")
        let count = strings.count
        
        guard count == 1 else {
            
            let data = String(strings.first ?? "")
            let nota = String(strings.last ?? "")
            
            return (data,nota)
            
        }
            
            if value.hasSuffix("_:") {
                
                let data = String(strings.first ?? "")
                return(data,nil)
                
            } else {
                
                let nota = String(strings.first ?? "")
                return (nil,nota)
            }

    }*/ // deprecata
    
}

extension BollaAcquisto:Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        let codingCase = encoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .inbound
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch codingCase {
            
        case .mainCollection:
            fallthrough
            
        case .subCollection:
           
            try container.encode(self.id, forKey: .id)
            try container.encode(self.rifIngrediente, forKey: .rif)
            try container.encode(self.data, forKey: .data)
            try container.encodeIfPresent(self.nota, forKey: .nota)
            try container.encode(self.user, forKey: .user)
            
        case .inbound:
            
            try container.encodeIfPresent(self.data, forKey: .data)
            try container.encodeIfPresent(self.nota, forKey: .nota)
            
        }
    }
    
   /*public func encodeSingleValue() -> String {
        
       /* let nota = self.nota ?? ""
        let data = self.data ?? ""
        
        guard !nota.isEmpty ||
              !data.isEmpty else { return "" }
        
        let value = "\(data)_:\(nota)"*/
        let value = "DA CORREGGERE"
        return value
        
    }*/ // deprecata

    
}

extension BollaAcquisto:MyProSubCollectionPack {
    
    public typealias Sub = CloudDataStore.SubCollectionKey
    
    public func subCollection() -> CloudDataStore.SubCollectionKey {
        return .archivioBolleAcquisto
    }
    
    public func sortCondition(compare rhs: BollaAcquisto) -> Bool {
        
       /* let currentData = self.data ?? ""
        let rhsData = rhs.data ?? ""
        return csCompareDateString(lhs: currentData, rhs: rhsData) */
        return false
    }
}
