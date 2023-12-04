//
//  CategoriaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/06/22.
//

import Foundation
//import Firebase

public enum MyCodingCase {
    
    case mainCollection
    case subCollection
    case inbound
}


public struct CategoriaMenu:
    MyProStarterPack_L0,
    MyProStarterPack_L01
   /*MyProStarterPack_L1,
    MyProEnumPack_L2,
    MyProDescriptionPack_L0,
    MyProCloudPack_L1*/ {
   
    public static func == (lhs:CategoriaMenu, rhs:CategoriaMenu) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.image == rhs.image &&
        lhs.productType == rhs.productType &&
        lhs.descrizione == rhs.descrizione &&
        lhs.listIndex == rhs.listIndex
    } // forse inutile
     
    public static var allCases: [CategoriaMenu] = [] // Deprecata 02.06 -> Passa i dati ad una published nel viewModel // deprecata definitivamente 13.09
    public static var defaultValue: CategoriaMenu = CategoriaMenu()
    
    public var id: String
    
    public var intestazione: String
    public var image: String // non è optional ma ha un valore di default
    public var productType:ProductType
    public var descrizione: String? // sarà optional
    public var listIndex:Int?
 
        public init(id: String, intestazione: String, image: String, descrizione: String?,productType:ProductType = .noValue) {
        // Probabilmente Inutile - Verificare
        self.id = id
        self.intestazione = intestazione
        self.image = image
        self.descrizione = descrizione
        self.productType = productType
        
    }
    
    public init() {
        
        self.id = UUID().uuidString
        self.intestazione = ""
        self.image = "#"
        self.productType = .noValue
       // self.descrizione = nil
    }
    
    // MyProCloudPack_L1
        
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    } // forse inutile
    
    
   /* func createId() -> String { // Deprecata
        self.intestazione.replacingOccurrences(of: " ", with: "").lowercased()
    }*/
    
    public func simpleDescription() -> String { //
        self.intestazione
      //  "Dessert"
    }
    
    public func extendedDescription() -> String { // Deprecata
        guard let descrizione,
              descrizione != "" else {
            return "No description yet"
        }
        
      //  guard self.descrizione != "" else { return "No description yet"}
        return descrizione
    }
    
    public func imageAssociated() -> String { // Deprecata
        self.image
     //   "🍰"
        
    }
    
    public func returnTypeCase() -> CategoriaMenu {
        return self
    }
    
    public func orderAndStorageValue() -> Int { // Deprecata
       // self.listPositionOrder
        return 0
    }
    
    public func manageDisable() -> Bool {
        
        guard self.intestazione != "",
              self.image != "#",
              self.productType != .noValue else { return true }
        
            return false
            
        }
        
    // method added 13.09
    
}

extension CategoriaMenu:Codable {
    
    public static let codingInfo:CodingUserInfoKey = CodingUserInfoKey(rawValue: "categoriaMenu")!
    
    public enum CodingKeys:String,CodingKey {
        
        case id
        // vanno nel cloud
        case intestazione
        case emoji
        case type
        // a discrezione dell'utente
        case descrizione
        case menuIndex = "menu_index" // la posizione in menu
    }
    
    public init(from decoder: Decoder) throws {
 
        let decodingCase = decoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .subCollection
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        
        switch decodingCase {
            
        case .inbound:
            fallthrough
            
        case .mainCollection:
            
            self.intestazione = try container.decode(String.self, forKey: .intestazione)
            self.image = try container.decode(String.self, forKey: .emoji)
            self.productType = try container.decode(ProductType.self, forKey: .type)
        
        case .subCollection:
            
            self.intestazione = try container.decode(String.self, forKey: .intestazione)
            self.image = try container.decode(String.self, forKey: .emoji)
            self.productType = try container.decode(ProductType.self, forKey: .type)
            
            self.descrizione = try container.decodeIfPresent(String.self, forKey: .descrizione)?.capitalizeFirst()
            self.listIndex = try container.decodeIfPresent(Int.self, forKey: .menuIndex)
            
        }
        
        
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        let codingCase = encoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .subCollection
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        
        switch codingCase {
            
        case .inbound:
            fallthrough
            
        case .mainCollection:
            try container.encode(self.intestazione.lowercased(), forKey: .intestazione)
            try container.encode(self.image, forKey: .emoji)
            try container.encode(self.productType, forKey: .type)
            
        case .subCollection:
            try container.encode(self.intestazione.lowercased(), forKey: .intestazione)
            try container.encode(self.image, forKey: .emoji)
            try container.encode(self.productType, forKey: .type)
            try container.encodeIfPresent(self.descrizione?.lowercased(), forKey: .descrizione)
            try container.encodeIfPresent(self.listIndex, forKey: .menuIndex)
        }

    }
    
 
    
}



extension CategoriaMenu {
    
   public func rigeneraCategoria(newId:String) -> CategoriaMenu {
        // rigeneriamo una categoria passandogli un nuovo Id. Utile quando l'utente crea localmente una categoria che già esiste nella libreria in cloud
        var new = self
        new.id = newId
        return new
        
    }
}
