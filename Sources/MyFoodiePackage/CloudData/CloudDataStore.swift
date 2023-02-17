//
//  ClockSyncroVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/10/22.
//

import Foundation
import SwiftUI

public struct CloudDataStore { // deprecata in futuro
    
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
    
    public init(userUID:String? = nil) {
        
        self.allMyIngredients = []
        self.allMyDish = []
        self.allMyMenu = []
        self.allMyProperties = []
        self.allMyCategories = []
        self.allMyReviews = []
 
        self.setupAccount = AccountSetup()
        self.inventarioScorte = Inventario()
    }
    
        
   public init() { // Deprecata in futuro
        
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
    } // deprecata in futuro

}
