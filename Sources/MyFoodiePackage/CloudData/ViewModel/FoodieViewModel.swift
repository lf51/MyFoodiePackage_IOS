//
//  File.swift
//  
//
//  Created by Calogero Friscia on 10/12/22.
//

import Foundation

/*public protocol MyProViewModelPack_L1:ObservableObject {
    
    var allMyIngredients:[IngredientModel] { get set }
    var allMyDish:[DishModel] { get set }
    var allMyMenu:[MenuModel] { get set }
    var allMyProperties:[PropertyModel] { get set }
    var allMyCategories:[CategoriaMenu] { get set }
    var allMyReviews:[DishRatingModel] { get set }
    
    // associatedType V:MyProXXXX
    // var cloudDataStore: V { get set }
    
} */

//protocol MyProXXX {
 //   associatedtype CodingKeys:String,CodingKey
//}
/*
public struct PropertyDataObject {
    
    public var info:PropertyModel?
    public var db:CloudDataStore
    
    public enum CodingKeys:String,CodingKey {
        
        case info = "propertyInfo"
        case db = "propertyData"
        
    }
    
    public init() {
        
        self.info = nil
        self.db = CloudDataStore()
    }
    
    public init(registra newProperty:PropertyModel,dataBase:CloudDataStore?) {
        self.info = newProperty
        
        if let data = dataBase {
            self.db = data
        } else {
            self.db = CloudDataStore()
        }
        
    }
    
}*/ // deprecato in futuro
/*
public struct PropertyDataModel {

    public var user:UserRoleModel
    public var cloudData:PropertyDataObject // valutare Optional
   // public var propertyInfo:PropertyModel?
   // public var propertyData:CloudDataStore // valutare di metterlo come optional
      
    public init(userAuth:UserRoleModel?) {
        
        if let authUser = userAuth {
            
            self.user = authUser
            
        } else {
            
            self.user = UserRoleModel(ruolo: .guest)
        }
        
        self.cloudData = PropertyDataObject()
    }
    
    public init(user:UserRoleModel,propertyData:PropertyDataObject) {
        
        self.user = user
        self.cloudData = propertyData
        
    }
    
   /* public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let property = try container.decodeIfPresent(PropertyModel.self, forKey: .propertyInfo)
        
        guard let organigramma = property?.organigramma,
              let user = organigramma.first(where: {$0.id == FoodieViewModel.userAuthData.id}) else {
            // lo user NON è autenticato / verifica superflua in quanto già effettuata nella PropertyLocalImage ma necessaria per tirare fuori lo userRoleModel. Da valutare meccanismi più efficienti
            let context = DecodingError.Context(codingPath: [Self.CodingKeys.propertyInfo], debugDescription: "Organigramma non trovato o User Non Autorizzato")
            throw DecodingError.valueNotFound(String.self, context)
        }
        
        self.propertyData = try container.decode(CloudDataStore.self, forKey: .propertyData)
        self.currentUser = user
        self.propertyInfo = property
 
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(propertyInfo, forKey: .propertyInfo)
        try container.encode(propertyData, forKey: .propertyData)
        
        
    } */
    
}*/ // deprecato in futuro


public struct PropertyCurrentData {
    
    public var userRole:UserRoleModel // non direct save su firebase
    public var info:PropertyModel?
    public var inventario:Inventario
    public var setup:AccountSetup
    public var db:CloudDataStore // no direct Save - decodificato come subCollection
    
    public init(
        userRole: UserRoleModel,
        info: PropertyModel,
        inventario: Inventario,
        setup: AccountSetup,
        db: CloudDataStore) {
        self.userRole = userRole
        self.info = info
        self.inventario = inventario
        self.setup = setup
        self.db = db
    }
        
}



open class FoodieViewModel:ObservableObject {
    
    public static var userAuthData:(id:String,userName:String,mail:String) = ("","","")
 //   @Published public var cloudData:CloudDataStore
    
    // aggiungere compiler
   /* @Published public var setupAccount: AccountSetup
    @Published public var inventarioScorte: Inventario // pensare di metterla optional
    
    @Published public var allMyIngredients:[IngredientModel]
    @Published public var allMyDish:[DishModel]
    @Published public var allMyMenu:[MenuModel]
    @Published public var allMyProperties:[PropertyModel]
    @Published public var allMyCategories:[CategoriaMenu]
    @Published public var allMyReviews:[DishRatingModel] */
    
   // public var dbCompiler:Any?
   // @Published public var currentUserRoleModel:UserRoleModel // deprecata
   // @Published public var currentProperty:PropertyModel? // deprecata
   // @Published public var cloudData:CloudDataStore // deprecata
    
    @Published public var currentProperty:PropertyCurrentData
   // @Published public var propertyMainObject:PropertyCurrentData
    
    public init(currentProperty: PropertyCurrentData) {

        self.currentProperty = currentProperty
    }
    
    
   /*public init(userAuth:UserRoleModel?,currentProperty:PropertyDataModel?) {
        // 13.08.23 Temporaneo da sistemare
        if let user = userAuth {
            
            Self.userAuthData = (user.id,user.userName,user.mail)
            
        }
        
        if let currentProperty {
            
            self.currentProperty = PropertyCurrentData
            
        } else {
            
            self.currentProperty = PropertyDataModel(userAuth: nil)
        }
        
        
        
    } */
    
    
   /* public init(userAuth:UserRoleModel?) {
        
        if let user = userAuth {
            
            Self.userAuthData = (user.id,user.userName,user.mail)
            
        }
        
        
       // self.cloudData = CloudDataStore()
       // self.currentProperty = nil
       // self.currentUserRoleModel = UserRoleModel() //
        
        self.currentProperty = PropertyDataModel(userAuth: userAuth)
       // self.onProperty = PropertyDataModel(userAuth: authUser)
        
    }*/ // 29.07.23 Studiare la relazione fra init delle classi con le superClassi per capire come ottimizzare l'init del viewModel nelle sottoclassi
    
  /*  public init(userUID:String? = nil) { // deprecata
        
       /* self.allMyIngredients = []
        self.allMyDish = []
        self.allMyMenu = []
        self.allMyProperties = []
        self.allMyCategories = []
        self.allMyReviews = []
 
        self.setupAccount = AccountSetup()
        self.inventarioScorte = Inventario() */
 
        self.cloudData = CloudDataStore(userUID: userUID)
    } */
    
   // Methods
    
   public func modelFromId<M:MyProStarterPack_L0>(id:String,modelPath:KeyPath<FoodieViewModel,[M]>) -> M? {
        
        let containerM = self[keyPath: modelPath]
        return containerM.first(where: {$0.id == id})
    }

   public func infoFromId<M:MyProStarterPack_L01>(id:String,modelPath:KeyPath<FoodieViewModel,[M]>) -> (isActive:Bool,nome:String,hasAllergeni:Bool) {
        
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
        
        if let menuDS = trovaMenuDiSistema(menuDiSistema: menuDiSistema) {
            return menuDS.rifDishIn.contains(idPiatto)
        } else {
            return false
        }

    }
    
    /// Ritorna un menuDiSistema Attivo. Se non lo trova ritorna nil
   public func trovaMenuDiSistema(menuDiSistema:TipologiaMenu.DiSistema) -> MenuModel? {
        
      // guard let data = self.cloudData else { return nil }
       
        let tipologia:TipologiaMenu = menuDiSistema.returnTipologiaMenu()
        
       return self.currentProperty.db.allMyMenu.first(where:{
               //  $0.tipologia.returnTypeCase() == tipologia &&
                 $0.tipologia == tipologia && // Vedi Nota 09.11
                 $0.isOnAirValue().today
            })
    }
    
    /// ritorna il numero di recensioni totali, quelle delle ultime 24h, la media totale, la media delle ulteme 10
    public func monitorRecensioni(rifReview:[String]? = nil) -> (totali:Int,l24:Int,mediaGen:Double,ml10:Double) {

        let starter:[DishRatingModel]
        
        if rifReview == nil {
            
            starter = self.currentProperty.db.allMyReviews
            
        } else {
            starter = self.modelCollectionFromCollectionID(collectionId: rifReview!, modelPath: \.currentProperty.db.allMyReviews)
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
        
        let dishRevModel = self.currentProperty.db.allMyReviews.filter({$0.rifPiatto == idPiatto})
        let dishRevRif = dishRevModel.map({$0.id})
        return (dishRevModel,dishRevRif)
        
    }
    
    
}
