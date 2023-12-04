//
//  File.swift
//  
//
//  Created by Calogero Friscia on 10/12/22.
//

// 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 // 05.09.23 githib token

import Foundation
import SwiftUI


public struct PropertyCurrentData:Codable { // deprecata
    
   // public var userRole:UserRoleModel // non direct save su firebase
    public var info:PropertyModel?
   // public var inventario:Inventario // deprecata_29_11_23
    public var setup:AccountSetup
   // public var db:CloudDataStore // no direct Save - decodificato come subCollection

    public init(
       // userRole: UserRoleModel,
        info: PropertyModel,
       // inventario: Inventario,
        setup: AccountSetup/*,
        db: CloudDataStore*/) {
       // self.userRole = userRole
        self.info = info
       // self.inventario = inventario
        self.setup = setup
      //  self.db = db
    }
    
    public init(
      //  userRole: UserRoleModel,
        propertyModel: PropertyModel) {
            // init prima registrazione proprietà
       // self.userRole = userRole
        self.info = propertyModel
       // self.inventario = Inventario()
        self.setup = AccountSetup()
       // self.db = CloudDataStore()
    }
    
    public init() {
        self.info = nil
      //  self.inventario = Inventario()
        self.setup = AccountSetup()
    }
    
    public enum CodingKeys:String,CodingKey {
        
       // case info = "property_info"
       // case inventario = "property_inventario"
        case setup = "property_setup"
        
    }
    
    public init(from decoder: Decoder) throws {

        let infoContainer = try decoder.singleValueContainer()
        self.info = try infoContainer.decode(PropertyModel.self)

        let container = try decoder.container(keyedBy: CodingKeys.self)
      /*  self.inventario = try container.decodeIfPresent(Inventario.self, forKey: .inventario) ?? Inventario()*/
       
        self.setup = try container.decodeIfPresent(AccountSetup.self, forKey: .setup) ?? AccountSetup()

    }
    
    
} // deprecato

/// oggetto di servizio per salvare i riferimenti delle proprietà dello User
public struct UserCloudData:Codable {
    
    // Auth info
    public let id:String
    public let email:String
    public var userName:String
    public let dataRegistrazione:Date?
    // Assunta di ufficio in fase di creazione post Auth
    public var isPremium:Bool?
    // Creata in fase di registrazione della Property
    public var propertiesRef:[String]?
    // Creata in base alla proprietà caricata
    public var propertyRole:CurrentUserRoleModel? // viene salvata nell'organigramma della property
    
    public init(
        id: String,
        email: String,
        userName: String,
        isPremium: Bool ) {
            
        self.id = id
        self.email = email
        self.userName = userName
        self.isPremium = isPremium
        self.dataRegistrazione = Date.now
            
        self.propertiesRef = nil
        self.propertyRole = nil
    }
    
    public enum CodingKeys:String,CodingKey {
        
        case id = "user_id"
        case email = "user_email"
        case userName = "user_name"
        case dataRegistrazione = "registered_since"
        
        case isPremium = "user_is_premium"
        case propertiesRef = "user_properties_ref"
        
    }
    
    public enum SubRoleKey:String,CodingKey {
        // necessario per salvare il currentUserRole in linea con le CodingKey
        case ruolo
        case restrizioni
        case inizioCollaborazione = "inizio_collaborazione"
    }
    
    
    /// Lo usiamo per switchare le due configurazioni di salvataggio. Una per il business, una per l'organigramma. Default Value is True.
    /// True Salva le chiavi:
    /// • id, email, username, isPremium e propertiesRef se presente
    /// False salva le chiavi:
    /// • id, email,username, propertyRole se presente
    public var codeForBusinessCollection:CodingUserInfoKey = CodingUserInfoKey(rawValue: "businessCodable")!
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        // salvate sia nello userBusiness sia nell'organigramma
        try container.encode(self.id, forKey: .id)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.userName, forKey: .userName)
        
        let isCodeForBusiness = encoder.userInfo[codeForBusinessCollection] as? Bool ?? true
        
        if isCodeForBusiness {
            // salvate solo nello user Business
            try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
            try container.encodeIfPresent(self.dataRegistrazione, forKey: .dataRegistrazione)
            try container.encodeIfPresent(self.propertiesRef, forKey: .propertiesRef)
            
        } else {
            // salvate solo nell'organigramma
          //  try container.encodeIfPresent(self.propertyRole, forKey: .propertyRole)
            var side = encoder.container(keyedBy: SubRoleKey.self)
            
            try side.encodeIfPresent(self.propertyRole?.ruolo, forKey: .ruolo)
            try side.encodeIfPresent(self.propertyRole?.restrictionLevel, forKey: .restrizioni)
            try side.encodeIfPresent(self.propertyRole?.inizioCollaborazione, forKey: .inizioCollaborazione)

        }

    }
    
    
    public static let decoderCase = CodingUserInfoKey(rawValue: "decoding_case")!
    
    public init(from decoder: Decoder) throws {
        //
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodingCase = decoder.userInfo[Self.decoderCase] as? DecodingCase ?? .userCollection
      
        let savedUID = try container.decode(String.self, forKey: .id)
        
        self.id = savedUID
        self.userName = try container.decode(String.self, forKey: .userName)
        self.email = try container.decode(String.self, forKey: .email)
        
        switch decodingCase {
            
        case .userCollection:
        
            self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
            self.dataRegistrazione = try container.decodeIfPresent(Date.self, forKey: .dataRegistrazione)
            self.propertiesRef = try container.decodeIfPresent([String].self, forKey: .propertiesRef)
            
            self.propertyRole = nil
            
        case .propertyLocalImage(let userUID):

            guard savedUID == userUID else {
                // controllo autorizzazione
                let context = DecodingError.Context(codingPath: [Self.CodingKeys.id], debugDescription: "User Non Autorizzato")

                throw DecodingError.valueNotFound(String.self, context)
              
            }
            
        fallthrough
            
        case .organigramma:
            // da rifare
          
            let side = try decoder.container(keyedBy: SubRoleKey.self)
            
            let ruolo = try side.decode(RoleModel.self, forKey: .ruolo)
            let restrizioni = try side.decodeIfPresent([RestrictionLevel].self, forKey: .restrizioni)
            let inizioCollaborazione = try side.decode(Date.self, forKey: .inizioCollaborazione)
            
            self.propertyRole = CurrentUserRoleModel(
                ruolo: ruolo,
                restrictionLevel: restrizioni,
                inizioCollaborazione: inizioCollaborazione)

            self.isPremium = nil
            self.dataRegistrazione = nil
            self.propertiesRef = nil
        }
     

            

        
    } // close init decoder
    
    
  public enum DecodingCase {
        
        case userCollection
        case propertyLocalImage(_ userUID:String)
        case organigramma
    
    }
   
}


open class FoodieViewModel:ObservableObject {
    
    //06.09.23 La superClasse o va abolita o va usata come contenitore di metodi trasfersali alle due/tre app, generiche e riutilizzabili. Incastrarcia a dare ad antrambe le app la stessa logia di partenza è un esercizio di coding, nulla in più. Ci ha fatto e ci fa perdere molto tempo, e non lo si può ottimizzare fin quando non si ha una visione finale, alta e completa sul funzionamento di entrambe. Al client, per intenderci, non frega niente dell'inventario. Potrebbe fregargli del setup. Tutto da valutare. Cmq sarebbe più da beginner ma più utile e veloce sviluppare su due canali autonomi. Dopo aver finito vedere se e come accorpare più funzioni.
    
    
    // comune alla business, alla client e in futuro a quella fornitori
    
    @Published public var currentUser:UserCloudData?
    @Published public var currentProperty:PropertyCurrentData
    @Published public var db:CloudDataStore
        
    // deprecato
    public static var userAuthData:(id:String,userName:String,mail:String) = ("","","") // deprecata

    
  
    public init(currentProperty: PropertyCurrentData) {
        self.db = CloudDataStore()
        self.currentProperty = currentProperty
    } // deprecato
    
        
   // Methods
    
   public func modelFromId<M:MyProStarterPack_L0>(id:String,modelPath:KeyPath<FoodieViewModel,[M]>) -> M? {
        
        let containerM = self[keyPath: modelPath]
        return containerM.first(where: {$0.id == id})
    }

   public func infoFromId<M:MyProStarterPack_L0&MyProStarterPack_L01&MyProStatusPack_L0>(id:String,modelPath:KeyPath<FoodieViewModel,[M]>) -> (isActive:Bool,nome:String,hasAllergeni:Bool) {
        
        guard let model = modelFromId(id: id, modelPath: modelPath) else { return (false,"",false) }
        
        let isActive = model.status.checkStatusTransition(check: .disponibile)
        let name = model.intestazione
        var allergeniIn:Bool = false
        
        if let ingredient = model as? IngredientModel,
           ingredient.allergeni != nil {
            
            allergeniIn = !ingredient.allergeni!.isEmpty
        }
        
        return (isActive,name,allergeniIn)
        
        
    } // 02.01.23 Riscontrata inutilità. Valutare in futuro
    
   public func modelCollectionFromCollectionID<M:MyProStarterPack_L0>(collectionId:[String],modelPath:KeyPath<FoodieViewModel,[M]>) -> [M] {
         
         var modelCollection:[M] = []
        
         for id in collectionId {
             
             if let model = modelFromId(id: id, modelPath: modelPath) {modelCollection.append(model)}
         }
       
        return modelCollection

     }
    
    /// Controlla se un menuDiSistema contiene un dato piatto
   public func checkMenuDiSistemaContainDish(idPiatto:String,menuDiSistema:TipologiaMenu.DiSistema) -> Bool {
        
        if let menuDS = trovaMenuDiSistema(tipo: menuDiSistema) {
            return menuDS.rifDishIn.contains(idPiatto)
        } else {
            return false
        }

    }
    
    /// Ritorna un menuDiSistema Attivo. Se non lo trova ritorna nil
    public func trovaMenuDiSistema(tipo menu:TipologiaMenu.DiSistema,seAttivo:Bool = true) -> MenuModel? {
        
       let tipologia:TipologiaMenu = menu.returnTipologiaMenu()
 
       return self.db.allMyMenu.first(where:{
           
           let condition = $0.tipologia == tipologia
           
           if seAttivo {
             return condition && $0.isOnAirValue().today
           } else { return condition }
            })
    }
    
    /// ritorna il numero di recensioni totali, quelle delle ultime 24h, la media totale, la media delle ulteme 10
    public func monitorRecensioni(rifReview:[String]? = nil) -> (totali:Int,l24:Int,mediaGen:Double,ml10:Double) {

        let starter:[DishRatingModel]
        
        if rifReview == nil {
            
            starter = self.db.allMyReviews
            
        } else {
            starter = self.modelCollectionFromCollectionID(collectionId: rifReview!, modelPath: \.db.allMyReviews)
        }
        
        let currentDate = Date()
        let totalCount = starter.count //.0
        
        let last24Count = starter.filter({
            $0.dataRilascio < currentDate &&
            $0.dataRilascio > currentDate.addingTimeInterval(-86400)
        }).count // .1
        
        let reviewByDate = starter.sorted(by: {$0.dataRilascio > $1.dataRilascio})
        
        let onlyLastTen = reviewByDate.prefix(10)
        let onlyL10 = Array(onlyLastTen)
        
        let mediaGeneralePonderata = csCalcoloMediaRecensioni(elementi: starter) //.2
        let mediaL10 = csCalcoloMediaRecensioni(elementi: onlyL10) //.3
        
        return (totalCount,last24Count,mediaGeneralePonderata,mediaL10)
    }
    
    /// Torna tutti i rif delle recensioni che riguardano un determinato Piatto, o tutti i model
    public func reviewFilteredByDish(idPiatto:String) -> (model:[DishRatingModel],rif:[String]) {
        
        let dishRevModel = self.db.allMyReviews.filter({$0.rifPiatto == idPiatto})
        let dishRevRif = dishRevModel.map({$0.id})
        return (dishRevModel,dishRevRif)
        
    }
    
    
}
