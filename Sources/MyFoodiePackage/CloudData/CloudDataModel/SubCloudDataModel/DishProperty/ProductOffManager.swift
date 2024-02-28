//
//  File.swift
//  
//
//  Created by Calogero Friscia on 02/02/24.
//

import Foundation

public struct ProductOffManager:Equatable {
    
    public var elencoIngredientiOff: [String:String] // salvato su Fire solo per mod Temporaneo
    public var idIngredienteDaSostituire: String? // utile nella view dei cambi per il permanente
    public var idSavedSubstitute: String? // utile per Mod Temporaneo && Permanente
    
    public init() {
        
        self.elencoIngredientiOff = [:]
    }
    
    /// Conserva nell'idSavedSubstitute l'id di un eventuale sostituto per l'ingrediente passato
   mutating public func storeValue(for ingredient:String) {
        
        guard let value = self.elencoIngredientiOff[ingredient] else { return }
        self.idSavedSubstitute = value
        
    }
    
    /// Ritorna se presente l'id del sostituto per l'ingrediente passato
    public func fetchSubstitute(for ingredient:String) -> String? {
        
        let value = self.elencoIngredientiOff[ingredient]
        return value
        
    }
    
    /// Ritorna la chiave corrispondente al valore passato. Ossia ritorna l'ingrediente titolare che ha come sostituto l'ingrediente passato.
    public func fetchTitolare(for substitute:String) -> String? {
        
        for (key,value) in elencoIngredientiOff {
            
            if value == substitute { return key }
            else { continue }
            
        }
        
        return nil
        
    }
    
}

extension ProductOffManager:Decodable {
    
    /*public enum CodingKeys:String,CodingKey {
        
        case elencoOff = "ingredienti_off"
        
    }*/
    
    public init(from decoder: Decoder) throws {
        
       // let container = try decoder.container(keyedBy: CodingKeys.self)
        let container = try decoder.singleValueContainer()
        
        self.elencoIngredientiOff = try container.decode([String:String].self)
        self.idIngredienteDaSostituire = nil
        self.idSavedSubstitute = nil
        
        
    }
    
}

extension ProductOffManager:Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
       // var container = encoder.container(keyedBy: CodingKeys.self)
        var container = encoder.singleValueContainer()
        
        try container.encode(self.elencoIngredientiOff)
        
    }
    
}
