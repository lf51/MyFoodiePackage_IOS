//
//  File.swift
//  
//
//  Created by Calogero Friscia on 10/12/22.
//

import Foundation

public protocol MyProViewModelPack_L1:ObservableObject {
    
    var allMyIngredients:[IngredientModel] { get set }
    var allMyDish:[DishModel] { get set }
    var allMyMenu:[MenuModel] { get set }
    var allMyProperties:[PropertyModel] { get set }
    var allMyCategories:[CategoriaMenu] { get set }
    var allMyReviews:[DishRatingModel] { get set }
    
    // associatedType V:MyProXXXX
    // var cloudDataStore: V { get set }
    
}

//protocol MyProXXX {
 //   associatedtype CodingKeys:String,CodingKey
//}

open class FoodieViewModel:ObservableObject {
    
    @Published public var cloudData:CloudDataStore?
    
    public var allMyIngredients:[IngredientModel]
    public var allMyDish:[DishModel]
    public var allMyMenu:[MenuModel]
    public var allMyProperties:[PropertyModel]
    public var allMyCategories:[CategoriaMenu]
    public var allMyReviews:[DishRatingModel]
    
    public init(userUID:String? = nil) {
        
        self.allMyIngredients = []
        self.allMyDish = []
        self.allMyMenu = []
        self.allMyProperties = []
        self.allMyCategories = []
        self.allMyReviews = []
 
    }
    
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
        
        if let ingredient = model as? IngredientModel {
            allergeniIn = !ingredient.allergeni.isEmpty
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
        
        let tipologia:TipologiaMenu = menuDiSistema.returnTipologiaMenu()
        
        return self.allMyMenu.first(where:{
               //  $0.tipologia.returnTypeCase() == tipologia &&
                 $0.tipologia == tipologia && // Vedi Nota 09.11
                 $0.isOnAir()
            })
    }
    
    /// ritorna il numero di recensioni totali, quelle delle ultime 24h, la media totale, la media delle ulteme 10
    public func monitorRecensioni(rifReview:[String]? = nil) -> (totali:Int,l24:Int,mediaGen:Double,ml10:Double) {
        
        let starter:[DishRatingModel]
        
        if rifReview == nil {
            
            starter = self.allMyReviews
            
        } else {
            starter = self.modelCollectionFromCollectionID(collectionId: rifReview!, modelPath: \.allMyReviews)
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
        
        let dishRevModel = self.allMyReviews.filter({$0.rifPiatto == idPiatto})
        let dishRevRif = dishRevModel.map({$0.id})
        return (dishRevModel,dishRevRif)
        
    }
    
    
}
