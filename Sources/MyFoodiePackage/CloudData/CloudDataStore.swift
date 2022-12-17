//
//  ClockSyncroVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/10/22.
//

import Foundation
import SwiftUI


public struct CloudDataStore {
    
    public var setupAccount: AccountSetup // caricato
    public var inventarioScorte: Inventario // caricato
    
    public var allMyIngredients:[IngredientModel] // caricato
    public var allMyDish:[DishModel] // caricato
    public var allMyMenu:[MenuModel] // caricato
    public var allMyProperties:[PropertyModel] // caricato
    
    public var allMyCategories: [CategoriaMenu] // caricato
    public var allMyReviews:[DishRatingModel] // caricato
    
    
   public enum CodingKeys:String,CodingKey {
    
       case allMyIngredients = "allUserIngredients"
       case allMyDish = "allUserProducts"
       case allMyMenu = "allUserMenu"
       case allMyProperties =  "allUserProperties"
       
       case allMyCategories = "allUserCategories"
       case allMyReviews = "allUserReviews"
       
       case otherDocument = "otherDocuments"
       
    }
    
    public enum AdditionalInfoKeys:String,CodingKey {
        
        case setupAccount = "userAccountSetup"
        case inventarioScorte = "userInventarioScorte"
        
    }
    
    public enum SetupKeys:String,CodingKey {
        
        case countDown
        case autoPauseDish_byPauseING
        case autoPauseDish_byArchiveING
        case autoPauseDish_byDeleteING
        
    }
    
   /* public init(from decoder: Decoder) throws {
        self.init()
    }*/
   /* public init(from decoder: Decoder) throws {
       
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.allMyIngredients = try values.decode([IngredientModel].self, forKey: .allMyIngredients)
        self.allMyDish = try values.decode([DishModel].self, forKey: .allMyDish)
        self.allMyMenu = try values.decode([MenuModel].self, forKey: .allMyMenu)
        self.allMyProperties = try values.decode([PropertyModel].self, forKey: .allMyProperties)
        
        self.allMyCategories = try values.decode([CategoriaMenu].self, forKey: .allMyCategories)
        self.allMyReviews = try values.decode([DishRatingModel].self, forKey: .allMyReviews)
        
        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .anyDocument)
        self.setupAccount = try additionalInfo.decode(AccountSetup.self, forKey: .setupAccount)
        self.inventarioScorte = try additionalInfo.decode(Inventario.self, forKey: .inventarioScorte)
        
        
    } */
    
    /*
     
     public enum CodingKeys:String,CodingKey {
           
           case allMyIngredients = "allUserIngredients"
           case allMyDish = "allUserProducts"
           case allMyMenu = "allUserMenu"
           case allMyProperties =  "allUserProperties"
           case allMyCategories = "allUserCategories"
           case allMyReviews = "allUserReviews"
                   
           case anyDocument = "datiDiFunzionamento"
           
       }
       
      public enum AdditionalInfoKeys:String,CodingKey {
           
           case setupAccount = "userAccountSetup"
           case inventarioScorte = "userInventarioScorte"
       }

     
     
    public init(from decoder: Decoder) throws {
       
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.allMyIngredients = try values.decode([IngredientModel].self, forKey: .allMyIngredients)
        self.allMyDish = try values.decode([DishModel].self, forKey: .allMyDish)
        self.allMyMenu = try values.decode([MenuModel].self, forKey: .allMyMenu)
        self.allMyProperties = try values.decode([PropertyModel].self, forKey: .allMyProperties)
        
        self.allMyCategories = try values.decode([CategoriaMenu].self, forKey: .allMyCategories)
        self.allMyReviews = try values.decode([DishRatingModel].self, forKey: .allMyReviews)
        
        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .anyDocument)
        self.setupAccount = try additionalInfo.decode(AccountSetup.self, forKey: .setupAccount)
        self.inventarioScorte = try additionalInfo.decode(Inventario.self, forKey: .inventarioScorte)
        
        
    } */
    
    
    
    
  /* public enum CloudCollectionKey:String { // Custom - Deprecata 14.12
        
        case ingredient = "userIngredients"
        case dish = "userPreparazioniEprodotti"
        case menu = "userMenu"
        case properties =  "userProperties"
        case categories = "userCategories"
        case reviews = "userReviews"
                
        case anyDocument = "datiDiFunzionamento"
    
    } */
    
   public init() {
        
        self.setupAccount = AccountSetup()
        self.inventarioScorte = Inventario()
        self.allMyIngredients = [] // vanno inseriti gli ing,dish,menu,property fake
        self.allMyDish = []
        self.allMyMenu = []
        self.allMyProperties = []
        self.allMyCategories = [] // vanno inserite le categorie di default
        self.allMyReviews = [] // vanno inserite review fake
        
    }
    
   public init(accountSetup: AccountSetup, inventarioScorte: Inventario, allMyIngredients: [IngredientModel], allMyDish: [DishModel], allMyMenu: [MenuModel], allMyProperties: [PropertyModel], allMyCategory: [CategoriaMenu], allMyReviews: [DishRatingModel]) {
        self.setupAccount = accountSetup
        self.inventarioScorte = inventarioScorte
        self.allMyIngredients = allMyIngredients
        self.allMyDish = allMyDish
        self.allMyMenu = allMyMenu
        self.allMyProperties = allMyProperties
        self.allMyCategories = allMyCategory
        self.allMyReviews = allMyReviews
    }

}
