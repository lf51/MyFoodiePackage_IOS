//
//  PropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import Foundation
import MapKit
import SwiftUI
//import Firebase

public enum RestrictionLevel:Codable {
    
    // le restrizioni funzionano per esclusione. Quelle contenute nei livelli sono quelle che verranno bloccate
    
    public static let allCases:[RestrictionLevel] = [.listaDellaSpesa,.modificheDiFunzionamento,.creaMod_ing,.creaMod_dish,.creaMod_categorie,.creaMod_menu,.replyReview]
    
    public static let allLevel:[String:[RestrictionLevel]] = [
        "Level 1":RestrictionLevel.level_1,
        "Level 2":RestrictionLevel.level_2,
        "Level 3":RestrictionLevel.level_3,
        "Level 4":RestrictionLevel.level_4
    ]
    
    public static let level_1:[RestrictionLevel] = [.creaMod_ing,.creaMod_dish,.creaMod_menu,.creaMod_categorie,.replyReview]
    public static let level_2:[RestrictionLevel] = [.creaMod_menu,.replyReview]
    public static let level_3:[RestrictionLevel] = [.replyReview]
    public static let level_4:[RestrictionLevel] = []
    
    case listaDellaSpesa
    case modificheDiFunzionamento // cambio di Status // Livello Scorte
    
    case creaMod_dish
    case creaMod_ing
    
    case creaMod_categorie
    case creaMod_menu
    
    case replyReview
    
    public static func namingLevel(allRestriction:[RestrictionLevel]) -> String {
        
        for level in RestrictionLevel.allLevel {
            
            if allRestriction == level.value { return level.key}
            else { continue }
        }
        
        return "Custom"
    }
    
   public func simpleDescription() -> String {
        
        switch self {
            
        case .listaDellaSpesa:
            return "Abilita modifiche lista della spesa"
        case .modificheDiFunzionamento:
            return "Abilita modifiche di status dei modelli"
        case .creaMod_dish:
            return "Abilita crea e modifica i prodotti"
        case .creaMod_ing:
            return "Abilita crea e modifica gli ingredienti"
        case .creaMod_menu:
            return "Abilita crea e modifica i menu"
        case .replyReview:
            return "Abilita a rispondere alle recensioni"
        case .creaMod_categorie:
            return "Abilita crea e modifica categorie dei Menu"
        }
    }

}

public struct CurrentUserRoleModel:Hashable, Codable {
    
    public var ruolo:RoleModel
    public var restrictionLevel:[RestrictionLevel]?
    public var inizioCollaborazione:Date
    
    public init(ruolo: RoleModel, restrictionLevel: [RestrictionLevel]? = nil) {
        self.ruolo = ruolo
        self.restrictionLevel = restrictionLevel
        self.inizioCollaborazione = Date.now
    }
    
    public init(ruolo: RoleModel, restrictionLevel: [RestrictionLevel]? = nil, inizioCollaborazione:Date) {
        self.ruolo = ruolo
        self.restrictionLevel = restrictionLevel
        self.inizioCollaborazione = inizioCollaborazione
    }
    
}



public struct UserRoleModel:Codable,Hashable,Identifiable { // deprecata
    // authInfo
    public let id:String// deprecata
    public var userName:String// deprecata
    public let mail:String// deprecata
    
    // additional Info
    public var ruolo:RoleModel
    public var restrictionLevel:[RestrictionLevel]?
    public var inizioCollaborazione:Date?
    
    /// lo usiamo nell'auth utente
    public init(uid:String,userName:String,mail:String) {
        self.id = uid
        self.userName = userName
        self.mail = mail
        
        self.ruolo = .auth
        self.restrictionLevel = nil
        self.inizioCollaborazione = nil
    } // deprecata
    
    /// add new Collaborator
    public init() { // deprecato
            
        self.id = "NON_ACCOPPIATO" + UUID().uuidString
        self.inizioCollaborazione = Date.now
        self.mail = ""
        self.userName = ""
        self.restrictionLevel = nil
        self.ruolo = .collab
    }
    
    /// add empty role Guest
    public init(ruolo:RoleModel = .guest) {
        
        self.id = ""
        self.inizioCollaborazione = nil
        self.mail = ""
        self.userName = ruolo.rawValue
        self.restrictionLevel = nil
        self.ruolo = ruolo
        
    }

    
    /// Init UserRoleModel as Admin
  /*  public init(
        adminUID: String,
        registrazioneProperty: Date,
        userName: String) {
            
        self.id = adminUID
        self.inizioCollaborazione = registrazioneProperty
        self.userName = userName
        
        self.mail = nil
        self.restrictionLevel = nil
    }
    
    /// Init UserRoleModel as collab
    public init(
        collabUID: String,
        inizioCollaborazione: Date,
        userName: String,
        mail: String,
        restrictionLevel: [RestrictionLevel]) {
            
        self.id = collabUID
        self.inizioCollaborazione = inizioCollaborazione
        self.mail = mail
        self.userName = userName
        self.restrictionLevel = restrictionLevel
    }*/
    
}

// Nota 19.09

public struct PropertyModel:MyProStarterPack_L0,Codable/*MyProStarterPack_L1,MyProVisualPack_L0,MyProDescriptionPack_L0,MyProCloudPack_L1*/{
  
    // Set Codable 14.12
    
  public enum MainCodingKeys:String,CodingKey {
      case propertyInfo = "property_info"

    }
    
  public enum CodingKeys:String,CodingKey {
        
        case id
        case intestazione
        case descrizione
       
        case cityName  //"city_name"
        //case coordinates // test
        case latitude
        case longitude
        
        case webSite  //"website"
        case phoneNumber // "phone_number"
        case streetAdress // "street_adress"
        case numeroCivico // "numero_civico"
       
        case organigramma
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var main = encoder.container(keyedBy: MainCodingKeys.self)
        var container = main.nestedContainer(keyedBy: CodingKeys.self, forKey: .propertyInfo)
      
        try container.encode(coordinates.latitude, forKey: .latitude)
        try container.encode(coordinates.longitude, forKey: .longitude)
            
        try container.encode(id, forKey: .id)
        try container.encode(intestazione, forKey: .intestazione)
        try container.encode(descrizione, forKey: .descrizione)
        try container.encode(cityName, forKey: .cityName)
        try container.encode(webSite, forKey: .webSite)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(streetAdress, forKey: .streetAdress)
        try container.encode(numeroCivico, forKey: .numeroCivico)

        try container.encode(organigramma, forKey: .organigramma)
        
    }
    
    public init(from decoder: Decoder) throws {
        print("[DECODE]_PropertyModel")
        //throw URLError(.badURL)
        
        let main = try decoder.container(keyedBy: MainCodingKeys.self)
        let values = try main.nestedContainer(keyedBy: CodingKeys.self, forKey: .propertyInfo)
        
        let decodeLatitude = try values.decode(Double.self, forKey: .latitude)
        let decodedLongitude = try values.decode(Double.self, forKey: .longitude)
        
        self.coordinates = CLLocationCoordinate2D(latitude: decodeLatitude, longitude: decodedLongitude)
        self.id = try values.decode(String.self, forKey: .id)
        self.intestazione = try values.decode(String.self, forKey: .intestazione)
        self.descrizione = try values.decode(String.self, forKey: .descrizione)
        self.cityName = try values.decode(String.self, forKey: .cityName)
        self.webSite = try values.decode(String.self, forKey: .webSite)
        self.phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
        self.streetAdress = try values.decode(String.self, forKey: .streetAdress)
        self.numeroCivico = try values.decode(String.self, forKey: .numeroCivico)
        self.organigramma = try values.decode([UserCloudData].self, forKey: .organigramma)
   
    }
    
    
    
    // Beta 14.12 Codable
    
    public static func == (lhs: PropertyModel, rhs: PropertyModel) -> Bool {
        
        lhs.id == rhs.id  &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione
      
    }
    
   
        
    public static func creaID(coordinates:CLLocationCoordinate2D,cityName:String) -> String {
        
        let city = cityName.uppercased()
        let latitude = String(coordinates.latitude).replacingOccurrences(of: ".", with: "A")
        let longitude = String(coordinates.longitude).replacingOccurrences(of: ".", with: "E")
        
        let codID = latitude + city + longitude
        
        return codID

    }
    
    public var id: String
    public var intestazione: String // deve sostituire il nome
    public var descrizione: String?
   
    public var cityName: String
    public var coordinates: CLLocationCoordinate2D
    public var webSite: String
    public var phoneNumber: String
    public var streetAdress: String
    public var numeroCivico: String
    
    public var organigramma:[UserCloudData]
    // MyProCloudPack_L1
    
   /* public init(frDocID:String,frDoc: [String:Any]) {
        
        self.id = frDocID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.cityName = frDoc[DataBaseField.cityName] as? String ?? ""
        self.webSite = frDoc[DataBaseField.webSite] as? String ?? ""
        self.phoneNumber = frDoc[DataBaseField.phoneNumber] as? String ?? ""
        self.streetAdress = frDoc[DataBaseField.streetAdress] as? String ?? ""
        self.numeroCivico = frDoc[DataBaseField.numeroCivico] as? String ?? ""
        
        let latitudeString = frDoc[DataBaseField.latitude] as? String ?? ""
        let latitudeDegree = CLLocationDegrees(latitudeString) ?? 0.0
        
        let longitudeString = frDoc[DataBaseField.longitude] as? String ?? ""
        let longitudeDegree = CLLocationDegrees(longitudeString) ?? 0.0
        
        self.coordinates = CLLocationCoordinate2D(latitude: latitudeDegree, longitude: longitudeDegree)
    }
    
    
    
    public struct DataBaseField {
        
        public static let intestazione = "intestazione"
        public static let descrizione = "descrizione"
        public static let cityName = "cityName"
        public static let webSite = "webSite"
        public static let phoneNumber = "phoneNumber"
        public static let streetAdress = "streetAdress"
        public static let numeroCivico = "numeroCivico"
        public static let latitude = "latitudine"
        public static let longitude = "longitudine"
        
    } */
            
   /* public init() { // utile quando creaiamo la @State NewProperty
        
        let coordinates = CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)

        self.id = Self.creaID(coordinates: coordinates,cityName: "X")
        self.intestazione = ""
        self.descrizione = ""
        self.cityName = ""
        self.coordinates = coordinates
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    } */
    /// La property model è registrata solo ed esclusivamente da un utente che assume in automico il ruolo di admin
    public init (
        intestazione: String,
        cityName: String,
        coordinates: CLLocationCoordinate2D,
        webSite: String,
        phoneNumber: String,
        streetAdress: String,
        numeroCivico: String,
        admin:UserCloudData) {
        
        self.id = Self.creaID(coordinates: coordinates,cityName: cityName)
        self.intestazione = intestazione
        self.descrizione = ""
        self.cityName = cityName
        self.coordinates = coordinates
        self.webSite = webSite
        self.phoneNumber = phoneNumber
        self.streetAdress = streetAdress
        self.numeroCivico = numeroCivico
            
        self.organigramma = [admin]
    
    }
    
  /*  public init(nome: String) {
        
        let coordinates = CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)

        self.id = Self.creaID(coordinates: coordinates,cityName: "X")
        self.intestazione = nome
        self.descrizione = ""
        self.cityName = ""
        self.coordinates = coordinates
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }*/
    
   /* public init(nome: String, coordinates: CLLocationCoordinate2D) {
        
        self.id = Self.creaID(coordinates: coordinates,cityName: "X")
        self.intestazione = nome
        self.descrizione = ""
        self.cityName = ""
        self.coordinates = coordinates
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }*/
    
    // Method

  public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
}

