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
    
    var cloudData:CloudDataStore?
    
    var allMyIngredients:[IngredientModel]
    var allMyDish:[DishModel]
    var allMyMenu:[MenuModel]
    var allMyProperties:[PropertyModel]
    var allMyCategories:[CategoriaMenu]
    var allMyReviews:[DishRatingModel]
    
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
    
    
    
}
