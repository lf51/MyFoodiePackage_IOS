//
//  CategoriaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/06/22.
//

import Foundation
//import Firebase

public struct CategoriaMenu:
    MyProStarterPack_L0
   /*MyProStarterPack_L1,
    MyProEnumPack_L2,
    MyProDescriptionPack_L0,
    MyProCloudPack_L1*/ {
   
    public static func == (lhs:CategoriaMenu, rhs:CategoriaMenu) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.image == rhs.image &&
        lhs.descrizione == rhs.descrizione
    } // forse inutile
     
    public static var allCases: [CategoriaMenu] = [] // Deprecata 02.06 -> Passa i dati ad una published nel viewModel // deprecata definitivamente 13.09
    public static var defaultValue: CategoriaMenu = CategoriaMenu()
    
    public var id: String
    
    public var intestazione: String
    public var image: String // non è optional ma ha un valore di default
    public var descrizione: String? // sarà optional
    public var listIndex:Int?
 
    public init(id: String, intestazione: String, image: String, descrizione: String?) {
        // Probabilmente Inutile - Verificare
        self.id = id
        self.intestazione = intestazione
        self.image = image
        self.descrizione = descrizione
        
    }
    
    public init() {
        
        self.id = UUID().uuidString
        self.intestazione = ""
        self.image = "🍽"
       // self.descrizione = nil
    }
    
    // MyProCloudPack_L1
        
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    } // forse inutile
    
    
    public func isStrictlyEqual(to otherCategory:CategoriaMenu) -> Bool {
        self.id == otherCategory.id &&
        self.intestazione.lowercased() == otherCategory.intestazione.lowercased() &&
        self.image == otherCategory.image
        }
    
   /* func createId() -> String { // Deprecata
        self.intestazione.replacingOccurrences(of: " ", with: "").lowercased()
    }*/
    
    public func simpleDescription() -> String { //
        self.intestazione
      //  "Dessert"
    }
    
    public func extendedDescription() -> String { // Deprecata
        print("Dentro ExtendedDescription in CategoriaMenu")
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
    
    // method added 13.09
    
}

extension CategoriaMenu:Codable {
    
    public static let codingInfo:CodingUserInfoKey = CodingUserInfoKey(rawValue: "categoriaMenu")!
    
    public enum CodingKeys:String,CodingKey {
        
        case id
        // vanno nel cloud
        case intestazione
        case emoji
        // a discrezione dell'utente
        case descrizione
        case menuIndex = "menu_index" // la posizione in menu
    }
    
    public init(from decoder: Decoder) throws {
    
        let decodingCase = decoder.userInfo[Self.codingInfo] as? DecodingCase ?? .categoriesSubCollection
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        
        switch decodingCase {
            
        case .categoriesMainCollection:
            
            self.intestazione = try container.decode(String.self, forKey: .intestazione)
            self.image = try container.decode(String.self, forKey: .emoji)
        
        case .categoriesSubCollection:
            
            self.intestazione = ""
            self.image = ""
            
            self.descrizione = try container.decodeIfPresent(String.self, forKey: .descrizione)
            self.listIndex = try container.decodeIfPresent(Int.self, forKey: .menuIndex)
            
        }
        
        
        
    }
    
    public func encode(to encoder: Encoder) throws {
        print("[ENCODE]_CategoriaMenu")
        let codingCase = encoder.userInfo[Self.codingInfo] as? DecodingCase ?? .categoriesSubCollection
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        
        switch codingCase {
            
        case .categoriesMainCollection:
            try container.encode(self.intestazione, forKey: .intestazione)
            try container.encode(self.image, forKey: .emoji)
            
        case .categoriesSubCollection:
            try container.encodeIfPresent(self.descrizione, forKey: .descrizione)
            try container.encodeIfPresent(self.listIndex, forKey: .menuIndex)
        }

    }
    
    public enum DecodingCase {
        
        case categoriesMainCollection
        case categoriesSubCollection
    }
    
}
