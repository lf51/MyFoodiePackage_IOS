//
//  ProductModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import Foundation
import SwiftUI

/*
 
 // Tre Tipologie di Prodotti
 1. Classico -> Contiene rif ingredienti
 2. Composizione -> Ha con se un ingrediente as Model sottostante
 3. Di terzi -> Ha con se un rif ingrediente sottostante
 
 */

public struct ProductModel:
    MyProStarterPack_L0,
    MyProStarterPack_L01,
    MyProDescriptionPack_L0{

   public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
       
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
       // lhs.status == rhs.status &&
        lhs.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        lhs.ingredientiSecondari == rhs.ingredientiSecondari &&
        lhs.elencoIngredientiOff == rhs.elencoIngredientiOff &&
        lhs.idIngredienteDaSostituire == rhs.idIngredienteDaSostituire &&
        lhs.categoriaMenu == rhs.categoriaMenu &&
        lhs.mostraDieteCompatibili == rhs.mostraDieteCompatibili &&
        lhs.pricingPiatto == rhs.pricingPiatto &&
        lhs.ingredienteSottostante == rhs.ingredienteSottostante &&
        lhs.rifIngredienteSottostante == rhs.rifIngredienteSottostante &&
        lhs.adress == rhs.adress &&
        lhs.statusCache == rhs.statusCache

    }

    public var id: String
   // public var percorsoProdotto:PercorsoProdotto
    
    public var intestazione: String
    public var descrizione: String?
  
    public var ingredientiPrincipali: [String]?
    public var ingredientiSecondari: [String]?
    
    public var ingredienteSottostante:IngredientModel?
    public var rifIngredienteSottostante:String?
   
    public var elencoIngredientiOff: [String:String]? // id Sostituito: idSOSTITUTO
    public var idIngredienteDaSostituire: String? // Nota 30.08

    /// Rif della CategoriaMenu
    public var categoriaMenu: String
    public var mostraDieteCompatibili: Bool

   // public var status: StatusModel
    public var statusCache: Int
    public var pricingPiatto:[DishFormat]
    
    public init() {
        
        self.id = UUID().uuidString
        
       // self.percorsoProdotto = .preparazione // deprecata
        self.intestazione = ""
      //  self.descrizione = nil
      //  self.ingredientiPrincipali = nil
      //  self.ingredientiSecondari = nil
      //  self.elencoIngredientiOff = nil
      //  self.idIngredienteDaSostituire = nil
        self.categoriaMenu = CategoriaMenu.defaultValue.id
        self.mostraDieteCompatibili = true
       // self.status = .noStatus
        self.pricingPiatto = DishFormat.customInit()
        
        self.statusCache = 0
        
    }
    
    public init(from ingredient:IngredientModel) {
        self.id = UUID().uuidString
       // self.percorsoProdotto = .finito(ingredient.id)
        //self.id = ingredient.id // da valutare
        self.intestazione = ingredient.intestazione
      //  self.descrizione = ingredient.descrizione
       // self.rifReviews = []
      //  self.ingredientiPrincipali = []
       // self.ingredientiSecondari = []
       // self.elencoIngredientiOff = [:]
      //  self.idIngredienteDaSostituire = nil
        self.categoriaMenu = CategoriaMenu.defaultValue.id
        self.mostraDieteCompatibili = true
       // self.status = ingredient.status
        self.pricingPiatto = DishFormat.customInit()
        self.rifIngredienteSottostante = ingredient.id
        self.statusCache = 0
    }
    
    func creaID(fromValue: String) -> String {
      
      return fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    } // non mi piace
    
}

extension ProductModel {
    
    public var adress:ProductAdress {
        
        get { self.getProductAdress() }
        set { self.setProductAdress(newValue) }
    }
    
    private func getProductAdress() -> ProductAdress {
        
        if rifIngredienteSottostante != nil { return .finito }
        else if ingredienteSottostante != nil { return .composizione }
        else { return .preparazione }
        
    }
    
    mutating private func setProductAdress(_ adress:ProductAdress) {
        
        switch adress {
            
        case .preparazione:
            self.ingredienteSottostante = nil
            self.rifIngredienteSottostante = nil
        case .composizione:
            self.ingredienteSottostante = IngredientModel()
            self.rifIngredienteSottostante = nil
            self.ingredientiPrincipali = nil
            self.ingredientiSecondari = nil
        case .finito:
            let sottostante = IngredientModel()
            self.ingredienteSottostante = sottostante
            self.rifIngredienteSottostante = sottostante.id
            self.ingredientiPrincipali = nil
            self.ingredientiSecondari = nil
        }
        
    }

    public func isDescriptionOk() -> Bool {
        
        guard self.adress == .composizione else { return true }
        
        guard let ingredienteSottostante else {
            // throw error
            return false }
        
        guard let descrizione = ingredienteSottostante.descrizione else { return false }
        
        return !descrizione.isEmpty
  
    }
    
    /// Per i prodotti finiti in fase di creazione sincronizza il nome con il sottostante
   mutating public func syncronizeIntestazione() {
        
        if self.adress == .finito {
            self.ingredienteSottostante?.intestazione = self.intestazione
           // self.ingredienteSottostante?.descrizione = self.descrizione
        }
    }
    
    /// Controlla se i campi relativi all'ingrediente siano completi in base all'adress
    public func checkCompilazioneIngredienti() -> Bool {
        
        let adress = self.adress
        
        switch adress {
            
        case .preparazione:
            let ingredienti = self.ingredientiPrincipali ?? []
            return !ingredienti.isEmpty
        default:
            let origineOk = self.ingredienteSottostante?.origine != .defaultValue
            let conservazioneOk = self.ingredienteSottostante?.conservazione != .defaultValue
            return origineOk && conservazioneOk
            
        }
    }
    
   mutating public func updateModelID() {

       let adress = self.adress
       
       guard adress != .finito else { return }
       
       if adress == .composizione {
           
           self.ingredienteSottostante?.id = UUID().uuidString
       }
    
       self.id = UUID().uuidString

    }
    
    public func getSottostante(viewModel:FoodieViewModel) -> (sottostante:IngredientModel?,notEditable:Bool) {
        
        switch self.adress {
            
        case .preparazione:
            return (nil,false)
        case .composizione:
            return (ingredienteSottostante,false)
        case .finito:
            
            if let ingredienteSottostante { return (ingredienteSottostante,false) }
            
            else if let rifIngredienteSottostante {
               let sottostante = viewModel.modelFromId(id: rifIngredienteSottostante, modelPath: \.db.allMyIngredients)
                return (sottostante,true)
                
            } else { return (nil,false) }
        }
        
    }
 
}

extension ProductModel:Codable {
    
    public enum CodingKeys:String,CodingKey {
        
        case id
      //  case percorsoProdotto = "tipologia"
        case intestazione
        case descrizione
        case ingredientiPrincipali = "ingredienti_principali"
        case ingredientiSecondari = "ingredienti_secondari"
        case ingredienteSottostante = "ingrediente_sottostante"
        case rifSottostante = "rif_sottostante"
        case elencoIngredientiOff = "ingredienti_off"
       // case idIngredienteDaSostituire = nil
        case categoriaMenu = "categoria_menu"
        case mostraDieteCompatibili = "show_diet"
        case status = "status_cache"
        case pricingPiatto = "pricing"
        
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
      //  self.percorsoProdotto = try container.decode(PercorsoProdotto.self, forKey: .percorsoProdotto)
        self.intestazione = try container.decode(String.self, forKey: .intestazione)
        self.descrizione = try container.decodeIfPresent(String.self, forKey:.descrizione)
        self.ingredientiPrincipali = try container.decodeIfPresent([String].self, forKey: .ingredientiPrincipali)
        self.ingredientiSecondari = try container.decodeIfPresent([String].self, forKey: .ingredientiSecondari)
        self.ingredienteSottostante = try container.decodeIfPresent(IngredientModel.self, forKey: .ingredienteSottostante)
        self.rifIngredienteSottostante = try container.decodeIfPresent(String.self, forKey: .rifSottostante)
        self.elencoIngredientiOff = try container.decodeIfPresent([String:String].self, forKey: .elencoIngredientiOff)
        self.categoriaMenu = try container.decode(String.self, forKey: .categoriaMenu)
        self.mostraDieteCompatibili = try container.decode(Bool.self, forKey: .mostraDieteCompatibili)
       // self.status = try container.decode(StatusModel.self, forKey: .status)
        self.pricingPiatto = try container.decode([DishFormat].self, forKey: .pricingPiatto)
        
      //  self.percorsoProdotto = .preparazione // deprecare
        let statusValue = try container.decode(String.self, forKey: .status)
        self.statusCache = Int(statusValue) ?? 0 // archivito in caso di errore // o potremmo throware un errore
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
       // try container.encode(self.percorsoProdotto, forKey: .percorsoProdotto)
        try container.encode(self.intestazione, forKey: .intestazione)
        try container.encodeIfPresent(self.descrizione, forKey: .descrizione)
        try container.encodeIfPresent(self.ingredientiPrincipali, forKey: .ingredientiPrincipali)
        try container.encodeIfPresent(self.ingredientiSecondari, forKey: .ingredientiSecondari)
        try container.encodeIfPresent(self.ingredienteSottostante, forKey: .ingredienteSottostante)
        try container.encodeIfPresent(self.rifIngredienteSottostante, forKey: .rifSottostante)
        try container.encodeIfPresent(self.elencoIngredientiOff, forKey: .elencoIngredientiOff)
        try container.encode(self.categoriaMenu, forKey: .categoriaMenu)
        try container.encode(self.mostraDieteCompatibili, forKey: .mostraDieteCompatibili)
      
        try container.encode(self.pricingPiatto, forKey: .pricingPiatto)
        let statusValue = String(self.statusCache)
        try container.encode(statusValue, forKey: .status)
        
    }
    
}

extension ProductModel {
    
    public func arePriceEmpty() -> Bool {
        
        for format in self.pricingPiatto {
            
            let price = format.price
            if price != "" { return false }
            else { continue }
        }
        return true
        
    }
    
    public func estrapolaPrezzoMandatoryMaggiore() -> Double {
        
        guard let labelPrice = self.pricingPiatto.first(where: {$0.type == .mandatory}) else { return 0.0 }
        let price = Double(labelPrice.price) ?? 0.0
        return price
        
    }
    
}

extension ProductModel {
    
    /// ritorna gli ingredienti Attivi sostituendo gli ingredienti inPausa con gli eventuali sostituti
    public func allIngredientsAttivi(viewModel:FoodieViewModel) -> [IngredientModel] {
        
        let sottostante = self.getSottostante(viewModel: viewModel).sottostante
        
        guard sottostante == nil else {
            // prodotti finiti
            return [sottostante!]
        }

        let allMinusBozzeEArchiviati = allMinusArchiviati(viewModel: viewModel)

        let allInPausa = allMinusBozzeEArchiviati.filter({
           // $0.status.checkStatusTransition(check: .inPausa)
            $0.statusTransition == .inPausa
            })
        
        guard !allInPausa.isEmpty else { return allMinusBozzeEArchiviati }
        
        guard let elencoIngredientiOff,
              !elencoIngredientiOff.isEmpty else {
            return allMinusBozzeEArchiviati.filter({
               // $0.status.checkStatusTransition(check: .disponibile)
                $0.statusTransition == .disponibile
            })
        }
        
        var allActiveIDs = allMinusBozzeEArchiviati.map({$0.id})
        
        for ingredient in allInPausa {
            
            let position = allActiveIDs.firstIndex{$0 == ingredient.id}
            
            if let sostituto = elencoIngredientiOff[ingredient.id] {

                let modelSostituo = viewModel.modelFromId(id: sostituto, modelPath: \.db.allMyIngredients)
                let isActive = modelSostituo?.statusTransition == .disponibile //modelSostituo?.status.checkStatusTransition(check: .disponibile) ?? false
                
                if isActive {
                    allActiveIDs[position!] = sostituto
                } else { allActiveIDs.remove(at: position!)}
                
            } else { allActiveIDs.remove(at: position!)}
            
        }
        
        let allActiveModels = viewModel.modelCollectionFromCollectionID(collectionId: allActiveIDs, modelPath: \.db.allMyIngredients)
        
        return allActiveModels
    }
    
    public func allMinusArchiviati(viewModel:FoodieViewModel) -> [IngredientModel] {
        
        let ingredientiPrincipali = self.ingredientiPrincipali ?? []
        let ingredientiSecondari = self.ingredientiSecondari ?? []
        
        let allIngredientsID = ingredientiPrincipali + ingredientiSecondari
        
        guard !allIngredientsID.isEmpty else { return [] }
        
        let allTheIngredients = viewModel.modelCollectionFromCollectionID(collectionId: allIngredientsID, modelPath: \.db.allMyIngredients)
        
        let allMinusBozzeEArchiviati = allTheIngredients.filter({
           // !$0.status.checkStatusTransition(check: .archiviato)
            $0.statusTransition != .archiviato
        })
        
        return allMinusBozzeEArchiviati
        
    }
    
    /// cerca corrispondenza delle chiavi sostituite negli array ingredienti Principali e Secondari, e in caso di assenza cancella la key portandola su nil
   mutating public func autoCleanElencoIngredientiOff() {
       
       guard let elencoIngredientiOff = self.elencoIngredientiOff else { return }
       
       let allKey = elencoIngredientiOff.keys
       guard !allKey.isEmpty else { return }
       
       let ingredientiPrincipali = self.ingredientiPrincipali ?? []
       let ingredientiSecondari = self.ingredientiSecondari ?? []
       
        for key in allKey {
            
            if ingredientiPrincipali.contains(key) || ingredientiSecondari.contains(key) { continue }
            else { self.elencoIngredientiOff?[key] = nil }
        }
        
    }
    
    /// conta gli ingredienti secondari e principali
    public func countIngredients() -> (count:Int,canBeExpanded:Bool) {
        
        let count = ((self.ingredientiPrincipali ?? []) + (self.ingredientiSecondari ?? [])).count
        
        switch self.adress {
            
        case .preparazione:
            return (count,true)
        case .finito:
            return (1,false)
        case .composizione:
            return(0,false)

        }
    }
    
    /// controlla la presenza di un ingrediente soltanto fra i principali e i secondari
    public func checkIngredientsInPlain(idIngrediente:String) -> Bool {
        
        let all = (self.ingredientiPrincipali ?? []) + (self.ingredientiSecondari ?? [])
        let condition = all.contains(where: {$0 == idIngrediente})
        return condition
    }
    
    /// Ritorna tutti i rif degli ingredienti contenuti nel piatto, senza badare allo status, ritorna i principali, i secondari, e i sostituti
    public func allIngredientsRif() -> [String] {
        let elencoIngredientiOff = self.elencoIngredientiOff ?? [:]
        let allIDSostituti = elencoIngredientiOff.values
        let allTheIngredients = (self.ingredientiPrincipali ?? []) + (self.ingredientiSecondari ?? []) + allIDSostituti
        
        return allTheIngredients
    } // 16.03.23 Probabile fonte di bug qualora un ingrediente sostituito torni disponibile il suo sostituto non ci interessa nel monitor di servizio
    
    /// Controlla la presenza dell'idIngrediente sia fra gl iingredienti Principali e Secondari, sia fra i sostituti
    public func checkIngredientsIn(idIngrediente:String) -> Bool {

        let allTheIngredients = self.allIngredientsRif()
        let condition = allTheIngredients.contains(idIngrediente)
        
        return condition

    }
    
    /// controlla se un ingrediente ha un sostituto, ovvero se esiste la chiave a suo nome nell'elencoIngredientiOff
    public func checkIngredientHasSubstitute(idIngrediente:String) -> Bool {
        
        guard let elencoIngredientiOff else { return false}
        
        let allSostituiti = elencoIngredientiOff.keys
        let condition = allSostituiti.contains(where: {$0 == idIngrediente})
        return condition
    }
    
    /// ritorna il path dell'ingrediente, quindi o l'array di ingredienti principali, o quello dei secondari, o se assente in entrambi ritorna nil
    public func individuaPathIngrediente(idIngrediente:String) -> (path:WritableKeyPath<Self,[String]?>?,index:Int?) {
        
        let ingredientiPrincipali = self.ingredientiPrincipali ?? []
        let ingredientiSecondari = self.ingredientiSecondari ?? []
        
        if let index = ingredientiPrincipali.firstIndex(of: idIngrediente) {
            
            return (\.ingredientiPrincipali,index)
            
        } else if let index = ingredientiSecondari.firstIndex(of: idIngrediente) {
            
            return(\.ingredientiSecondari,index)
            
        } else { return (nil,nil)}
        
    }
    
}

extension ProductModel {
    
    /// Questa Pre Call serve nei filtri perchè la proprietà nel filterCore è optional e quindi la pre trattiamo prima di chiamare il metodo principale
    /// - Parameters:
    ///   - viewModel: <#viewModel description#>
    ///   - kpQuality: <#kpQuality description#>
    ///   - quality: <#quality description#>
    /// - Returns: <#description#>
    public func preCallHasAllIngredientSameQuality<T:MyProEnumPack_L0>(viewModel:FoodieViewModel,kpQuality:KeyPath<IngredientModel,T>,quality:T?) -> Bool {
        
        guard let unwrapQuality = quality else { return true }
        
       return self.hasAllIngredientSameQuality(viewModel: viewModel, kpQuality: kpQuality, quality: unwrapQuality)
        
    }
    
    public func hasAllIngredientSameQuality<T:MyProEnumPack_L0>(viewModel:FoodieViewModel,kpQuality:KeyPath<IngredientModel,T>,quality:T) -> Bool {
        
        let allIngredient = self.allIngredientsAttivi(viewModel: viewModel)
        guard !allIngredient.isEmpty else { return false }
        
        for ingredient in allIngredient {
            if ingredient[keyPath: kpQuality] == quality { continue }
            else { return false }
        }
        return true
    }
    
    /// Analizza gli ingredienti per verificare se ce ne sia almeno uno che ha la qualità richiesta
    /// - Parameters:
    ///   - viewModel: viewModel
    ///   - kpQuality: percorso della qualità nell'IngredientModel
    ///   - quality: valore della proprietà ricercato
    /// - Returns: True se c'è qualche ingrediente nel piatto con quella qualità
    public func hasSomeIngredientASpecificQuality<T:MyProEnumPack_L0>(viewModel:FoodieViewModel,kpQuality:KeyPath<IngredientModel,T>,quality:T) -> Bool {
        
        let allIngredient = self.allIngredientsAttivi(viewModel: viewModel)
        guard !allIngredient.isEmpty else { return false }
        
        let map = allIngredient.filter({$0[keyPath: kpQuality] == quality})
        
        return !map.isEmpty
        
    }
}

extension ProductModel {
    
    /// Controlla l'origine degli ingredienti e restituisce un array con le diete compatibili. Il byPass di default su false, se true byPassa la scelta dell'utente di mostrare o meno le diete e calcola le compatibilità
    public func returnDietAvaible(
        viewModel:FoodieViewModel,
        byPassShowCompatibility:Bool = false) -> (inDishTipologia:[TipoDieta],inStringa:[String]) {
        
        // Step 0 -> controlliamo che l'utente abbia scelto o meno di mostrare le diete. In caso negativo mandiamo la dieta standard
        guard self.mostraDieteCompatibili || byPassShowCompatibility else { return ([],[])}

            if let throwSottostante = self.getSottostante(viewModel: viewModel).sottostante {
                return returnDiet(throw: throwSottostante)
            }
            else {
                let allModelIngredients = self.allIngredientsAttivi(viewModel: viewModel)
                return returnDiet(throw: allModelIngredients)
            }
           /* if let throwSottostante = self.ingredienteSottostante {
                return returnDiet(throw: throwSottostante)
            } else {
               let allModelIngredients = self.allIngredientsAttivi(viewModel: viewModel)
               return returnDiet(throw: allModelIngredients)
            } */
    
    }
    
    private func returnDiet(throw singleIngredient:IngredientModel) -> (inDishTipologia:[TipoDieta],inStringa:[String]) {
        
        // step 1 ->
        let animalOrFish:Bool = singleIngredient.origine.returnTypeCase() == .animale
        
        let milkIn:Bool = {
            
            if let allergeniIn = singleIngredient.allergeni {
                return allergeniIn.contains(.latte_e_derivati)
            } else { return false }
        }()

        let glutenIn:Bool = {
            if let allergeniIn = singleIngredient.allergeni {
                return allergeniIn.contains(.glutine)
            } else { return false }
            
        }()
        // step 2 -->
        
        var dieteOk:[TipoDieta] = []
        
        if !glutenIn {dieteOk.append(.glutenFree)}

        if !animalOrFish && !milkIn {
            dieteOk.append(contentsOf: [.vegano,.zeroLatticini,.vegetariano])
        }
        else if animalOrFish && !milkIn {
            dieteOk.append(contentsOf: [.zeroLatticini])
        }
        else {
            // Nota 21_11_23
            if self.adress == .finito {
                dieteOk.append(.vegetariano)
            }
            
        }

        let dieteOkInStringa:[String] = dieteOk.map({$0.simpleDescription()})
 
        return (dieteOk,dieteOkInStringa)
    }
    
    private func returnDiet(throw allModelIngredients:[IngredientModel]) -> (inDishTipologia:[TipoDieta],inStringa:[String]) {
        
        // step 1 ->
        let animalOrFish: [IngredientModel] = allModelIngredients.filter({$0.origine.returnTypeCase() == .animale})
        
        let milkIn: [IngredientModel] = allModelIngredients.filter({
            
            if let allergeniIn = $0.allergeni {
                return allergeniIn.contains(.latte_e_derivati)
            } else { return false }
            
            //  $0.allergeni.contains(.latte_e_derivati)
            
        })
        
        let glutenIn: [IngredientModel] = allModelIngredients.filter({
            // $0.allergeni.contains(.glutine)
            if let allergeniIn = $0.allergeni {
                return allergeniIn.contains(.glutine)
            } else { return false }
        })
        
        // step 2 -->
        
        var dieteOk:[TipoDieta] = []
        
        if glutenIn.isEmpty {dieteOk.append(.glutenFree)}
 
        let animalCount = animalOrFish.count
        let milkCount = milkIn.count
        
        if (animalCount + milkCount) == 0 {
            dieteOk.append(contentsOf: [.vegano,.zeroLatticini,.vegetariano])
        }
        else if milkCount == 0 { dieteOk.append(.zeroLatticini) }
        else if (animalCount - milkCount) == 0 { dieteOk.append(.vegetariano) }
        
        let dieteOkInStringa:[String] = dieteOk.map({$0.simpleDescription()})
 
        return (dieteOk,dieteOkInStringa)
    }
    
}

extension ProductModel {
    
    /// Ritorna la media in forma di stringa delle recensioni di un Piatto, e il numero delle stesse come Int, e un array con i modelli delle recensioni
   public func ratingInfo(readOnlyViewModel:FoodieViewModel) -> (media:Double,count:Int,allModelReview:[DishRatingModel]) {
        
        // Nota 13.09 // Nota 20_11_23

      /* let allLocalReviews:[DishRatingModel] = readOnlyViewModel.modelCollectionFromCollectionID(collectionId: self.rifReviews, modelPath: \.db.allMyReviews)*/
       guard self.adress != .finito else {
           return (0.0,0,[])
       }
       
       let allLocalReviews:[DishRatingModel] = readOnlyViewModel.db.allMyReviews.filter({$0.rifPiatto == self.id})
        
        guard !allLocalReviews.isEmpty else {
            
            return (0.0,0,[])
        }
        
        let ratingCount: Int = allLocalReviews.count // item.rating.count
        let mediaPonderata = csCalcoloMediaRecensioni(elementi: allLocalReviews)
 
        return (mediaPonderata,ratingCount,allLocalReviews)
        
    }
    
    /// Torna un valore da usare per ordinare i model nella classifica TopRated. In questo caso torna il peso delle recensioni, ossia la media ponderata per il numero di recensioni
   public func topRatedValue(readOnlyVM:FoodieViewModel) -> Double {
        
        let (media,count,_) = self.ratingInfo(readOnlyViewModel:readOnlyVM)
       
        return (media * Double(count))
     
    }
    
}

extension ProductModel {
    
    /// Calcola se la preparazione è a base di carne, pesce, o verdure
   public func calcolaBaseDellaPreparazione(readOnlyVM:FoodieViewModel) -> BasePreparazione {
        
        let allING = self.allIngredientsAttivi(viewModel: readOnlyVM)
        let allInGMapped = allING.map({$0.origine})
        
        guard allInGMapped.contains(.animale) else { return .vegetale }
        
       // let allergeneIn = allING.map({$0.allergeni})
       let allergeneIn = allING.compactMap({$0.allergeni})
        // 09.02.23
       
        for arrAll in allergeneIn {
            
            if arrAll.contains(where: {
                $0 == .pesce ||
                $0 == .molluschi ||
                $0 == .crostacei
            }) { return .pesce }
            
            else if arrAll.contains(where: {
                $0 == .latte_e_derivati
            }) { return .latticini}
                        
            else { continue }
        }

        return .carne
        
    }
    
    public enum BasePreparazione:MyProEnumPack_L0 {

        public static var allCase:[BasePreparazione] = [.vegetale,.carne,.pesce,.latticini]
        
        case vegetale,carne,pesce,latticini
        
        public func simpleDescription() -> String {
            
            switch self {
            case .vegetale:
                return "Verdure"
            case .carne:
                return "Carne"
            case .pesce:
                return "Pesce"
            case .latticini:
                return "Latticini"
            }
        }
        
        public func returnTypeCase() -> ProductModel.BasePreparazione {
           return self
        }

        public func orderAndStorageValue() -> Int {
            return 0
        }
        
       public func imageAssociate() -> String {
            
            switch self {
            case .vegetale:
                return "🥬"
            case .carne:
                return "🐂"
            case .pesce:
                return "🐟"
            case .latticini:
                return "🥛"
            }

        }
    }
  
    
}

extension ProductModel {
    
    public func calcolaAllergeniNelPiatto(viewModel:FoodieViewModel) -> [AllergeniIngrediente] {
       
         let allIngredients = self.allIngredientsAttivi(viewModel: viewModel)
         var allergeniPiatto:[AllergeniIngrediente] = []
         
              for ingredient in allIngredients {
                  
                  let allergeneIngre:[AllergeniIngrediente] = ingredient.allergeni ?? []
                  allergeniPiatto.append(contentsOf: allergeneIngre)
              }

             let setAllergeniPiatto = Set(allergeniPiatto)
             let orderedAllergeni = Array(setAllergeniPiatto).sorted { $0.simpleDescription() < $1.simpleDescription() }
         
             return orderedAllergeni
     
      }
}

public enum ProductAdress {

    public static var allCases:[ProductAdress] = [.preparazione,.composizione,.finito]
    
    case preparazione // sintetizzabile
    case composizione
    case finito
    
    public func imageAssociated(to productType:ProductType? = nil) -> (system:String,color:Color) {
        
        switch self {
            
        case .finito:
            return ("takeoutbag.and.cup.and.straw",Color.gray)
        case .preparazione:
            if let productType { return productType.imageAssociated() }
            else { return ("fork.knife",Color.yellow) }
            
        case .composizione:
            return ("swatchpalette",Color.mint)
            
        }
    }
    
    public func pickerDescription() -> String {
        
        switch self {
        case .finito:
            return "Pronto"
        case .preparazione:
            return "Preparazione"
        case .composizione:
            return "Composizione"
            
        }
    }
    
    public func simpleDescription() -> String {
        
        switch self {
            
        case .finito:
            return "Prodotto Pronto"
        case .preparazione:
            return "Preparazione"
        case .composizione:
            return "Composizione"
            
        }
    }
    
    public func boxDescription() -> String {
        
        switch self {
            
        case .composizione:
            return "Descrizione (!)"
        default:
            return "Descrizione (Optional)"
            
        }
        
    }
    
    public func returnTypeCase() -> ProductAdress { return self }
    
    public func genereCase() -> String {
        
        switch self {
        
        case .finito:
            return "Nuovo"
        default:
            return "Nuova"
        }
    }
  /*  public func associatedValue() -> Any? {
        
        switch self {
            
        case .preparazione:
            return nil
        case .composizione(let ing):
            return ing
        case .finito(let rif):
            return rif
        }
    }*/
    
    public func orderAndStorageValue() -> Int {
        
        switch self {
            
        case .finito:
            return 0
        case .preparazione:
            return 1
        case .composizione:
            return 2
            
        }
    }

    public func extendedDescription() -> String {
        
        switch self {
            
        case .finito:
            return "Prodotto pronto acquistato da terzi. Es: CocaCola"
        case .composizione:
            return "Composizione descrittiva, per ingredienti variabili e/o generici. Es: Tagliere di Salumi e Formaggi locali "
        case .preparazione:
            return "Combinazione e/o lavorazione in loco di uno o più ingredienti"
            
        }
    }
    
}

public enum ProductType:String,Codable,CaseIterable {
    
    static public var allCases: [ProductType] = [.noValue,.food,.beverage]
    
    case food
    case beverage
    case noValue = "n/d"
    
   public func imageAssociated() -> (system:String,color:Color) {
        
        switch self {
        case .food:
            return ("fork.knife",Color.yellow)
        case .beverage:
            return ("wineglass",Color.orange)
        case .noValue:
            return ("x.circle",Color.red)
        }
    }
}

