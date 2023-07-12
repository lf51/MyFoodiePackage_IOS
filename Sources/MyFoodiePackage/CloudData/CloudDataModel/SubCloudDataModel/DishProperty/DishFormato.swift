//
//  DishFormati.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

public struct DishFormat:Hashable,Codable {
    
    static public var modelloCorrente:[Self]?
    
    static func customInit() -> [Self] {
        
        guard let current = modelloCorrente else {
            return [DishFormat(type: .mandatory)]
        }
        return current
    }
    
    let id:String
    
    public var label: String
    public var price: String
    
    public var type: DishFormatType
   
    public init(type: DishFormatType) {
      
        self.price = ""
        self.label = ""
        self.type = type
        self.id = UUID().uuidString
    }
    
   /* public init(label:String? = nil) { // deprecata in futuro
        
        self.label = label ?? ""
        self.price = ""
        self.type = label == nil ? .mandatory : .opzionale
        
        self.id = UUID().uuidString
        
    }*/
    
    public init(label:String,type:DishFormatType) {// 12.02.23
        
        self.label = label
        self.price = ""
        self.type = type
        
        self.id = UUID().uuidString
        
    }
    
            
}

public enum DishFormatType:Codable {
    
    case mandatory,opzionale
    
    public func orderAndStorageValue() -> Int {
        switch self {
        case .mandatory: return 0
        case .opzionale: return 1
        }
    }
}

/*
public struct DishFormat:Hashable,Codable {
    
    static public var modelloCorrente:[Self]?
    
    let id:String // Non serve. Non lo salviamo su firebase e quindi ne viene assegnato uno nuovo ogni volta
    
    public var label: String // trasformare in optional
    public var price: String // trasformare in double
    
    public var type: DishFormatType
   
    public init(type: DishFormatType) { // deprecato in futuro
        self.label = ""
        self.price = ""
        self.type = type
        
        self.id = UUID().uuidString
    }
    
    public init(label:String? = nil) { // deprecata in futuro
        
        self.label = label ?? ""
        self.price = ""
        self.type = label == nil ? .mandatory : .opzionale
        
        self.id = UUID().uuidString
        
    }
    
    public init(label:String,type:DishFormatType) {// 12.02.23
        
        self.label = label
        self.price = ""
        self.type = type
        
        self.id = UUID().uuidString
        
    }
    
            
} */ // Backup 17.02.23
