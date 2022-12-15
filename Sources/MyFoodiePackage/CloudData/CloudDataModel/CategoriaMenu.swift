//
//  CategoriaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/06/22.
//

import Foundation
//import Firebase

public struct CategoriaMenu:
    MyProStarterPack_L0,
    Codable
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
    public var image: String
    public var descrizione: String
    public var listIndex:Int?
        
    public init(id: String, intestazione: String, image: String, descrizione: String) {
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
        self.descrizione = ""
    }
    
    // MyProCloudPack_L1
    
   /* public init(frDocID:String,frDoc: [String:Any]) {
        
        self.id = frDocID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.image = frDoc[DataBaseField.image] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.listIndex = frDoc[DataBaseField.listIndex] as? Int ?? nil
    }
    

    public struct DataBaseField {
        
        public static let intestazione = "intestazione"
        public static let descrizione = "descrizione"
        public static let image = "image"
        public static let listIndex = "listIndex"
        
    } */
    
    //
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    } // forse inutile
    
    
    
    func createId() -> String { // Deprecata
        self.intestazione.replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    public func simpleDescription() -> String { // Deprecata
        self.intestazione
      //  "Dessert"
    }
    
    public func extendedDescription() -> String { // Deprecata
        print("Dentro ExtendedDescription in CategoriaMenu")
        return ""
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
