//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import Foundation
import SwiftUI

public struct DishModel: MyProStarterPack_L01,Codable /*: MyProToolPack_L1,MyProVisualPack_L1,MyProDescriptionPack_L0,MyProStatusPack_L1,MyProCloudPack_L1 */{

   public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: DishModel, rhs: DishModel) -> Bool {
       
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
        lhs.status == rhs.status &&
        lhs.rifReviews == rhs.rifReviews &&
        lhs.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        lhs.ingredientiSecondari == rhs.ingredientiSecondari &&
        lhs.elencoIngredientiOff == rhs.elencoIngredientiOff &&
        lhs.idIngredienteDaSostituire == rhs.idIngredienteDaSostituire &&
        lhs.categoriaMenu == rhs.categoriaMenu &&
        lhs.mostraDieteCompatibili == rhs.mostraDieteCompatibili &&
        lhs.pricingPiatto == rhs.pricingPiatto &&
        lhs.percorsoProdotto == rhs.percorsoProdotto

    }

    public var id: String
    public var percorsoProdotto:PercorsoProdotto
    
    public var intestazione: String
    public var descrizione: String
    public var rifReviews: [String] // Nota 13.09 // deprecata in futuro. Gestire da lato review con riferimento al piatto.
    
    /// array con i Rif degli ingredienti Principali
    public var ingredientiPrincipali: [String]
    /// array con i Rif degli ingredienti Secondari
    public var ingredientiSecondari: [String]
   
    public var elencoIngredientiOff: [String:String] // id Sostituito: idSOSTITUTO
    public var idIngredienteDaSostituire: String? // Nota 30.08

    /// Rif della CategoriaMenu
    public var categoriaMenu: String
    public var mostraDieteCompatibili: Bool

    public var status: StatusModel
    public var pricingPiatto:[DishFormat]

    
    public init() {
        
        self.percorsoProdotto = .preparazioneFood
        self.id = UUID().uuidString
        self.intestazione = ""
        self.descrizione = ""
        self.rifReviews = []
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.elencoIngredientiOff = [:]
        self.idIngredienteDaSostituire = nil
        self.categoriaMenu = CategoriaMenu.defaultValue.id
        self.mostraDieteCompatibili = false
        self.status = .bozza()
        self.pricingPiatto = []
        
    }

    public init(percorsoProdotto: PercorsoProdotto, id: String, intestazione: String, descrizione: String, rifReviews: [String], ingredientiPrincipali: [String], ingredientiSecondari: [String], elencoIngredientiOff: [String : String], idIngredienteDaSostituire: String? = nil, categoriaMenu: String, mostraDieteCompatibili: Bool, status: StatusModel, pricingPiatto: [DishFormat], categoriaMenuDEPRECATA: CategoriaMenu, dieteCompatibili: [TipoDieta], aBaseDi: OrigineIngrediente) {
        
        self.percorsoProdotto = percorsoProdotto
        self.id = UUID().uuidString
        self.intestazione = intestazione
        self.descrizione = descrizione
        self.rifReviews = rifReviews
        self.ingredientiPrincipali = ingredientiPrincipali
        self.ingredientiSecondari = ingredientiSecondari
        self.elencoIngredientiOff = elencoIngredientiOff
        self.idIngredienteDaSostituire = idIngredienteDaSostituire
        self.categoriaMenu = categoriaMenu
        self.mostraDieteCompatibili = mostraDieteCompatibili
        self.status = status
        self.pricingPiatto = pricingPiatto

    }
    
    public init(id:String = UUID().uuidString) {
        // Necessario quando creiamo l'ibrido, poichè l'id va creato fuori e dato uguale sia all'ingredienteDiSistema che al model
        self.percorsoProdotto = .preparazioneFood
        self.id = id
        self.intestazione = ""
        self.descrizione = ""
        self.rifReviews = []
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.elencoIngredientiOff = [:]
        self.idIngredienteDaSostituire = nil
        self.categoriaMenu = CategoriaMenu.defaultValue.id
        self.mostraDieteCompatibili = false
        self.status = .bozza()
        self.pricingPiatto = []
        

    }
    
    // 31.12.22 Ricollocati OK
    
    /// ritorna gli ingredienti Attivi sostituendo gli ingredienti inPausa con gli eventuali sostituti
    public func allIngredientsAttivi(viewModel:FoodieViewModel) -> [IngredientModel] {
        
        // Innesto 06.10
        guard !self.ingredientiPrincipali.contains(self.id) else {
           // Trattasi di ibrido
            if let model = viewModel.modelFromId(id: self.id, modelPath: \.allMyIngredients) { return [model] }
            else { return [] }
        }
        
        let allMinusBozzeEArchiviati = allMinusArchiviati(viewModel: viewModel)

        let allInPausa = allMinusBozzeEArchiviati.filter({
            $0.status.checkStatusTransition(check: .inPausa)
            })
        
        guard !allInPausa.isEmpty else { return allMinusBozzeEArchiviati }
        
        guard !self.elencoIngredientiOff.isEmpty else {
            return allMinusBozzeEArchiviati.filter({
                $0.status.checkStatusTransition(check: .disponibile)
            })
        }
        
        var allActiveIDs = allMinusBozzeEArchiviati.map({$0.id})
        
        for ingredient in allInPausa {
            
            let position = allActiveIDs.firstIndex{$0 == ingredient.id}
            
            if let sostituto = self.elencoIngredientiOff[ingredient.id] {
                
                let(isActive,_,_) = viewModel.infoFromId(id: sostituto, modelPath: \.allMyIngredients)
                
                if isActive {
                    allActiveIDs[position!] = sostituto
                } else { allActiveIDs.remove(at: position!)}
                
            } else { allActiveIDs.remove(at: position!)}
            
        }
        
        let allActiveModels = viewModel.modelCollectionFromCollectionID(collectionId: allActiveIDs, modelPath: \.allMyIngredients)
        
        return allActiveModels
    }
    
    public func allMinusArchiviati(viewModel:FoodieViewModel) -> [IngredientModel] {
        
        let allIngredientsID = self.ingredientiPrincipali + self.ingredientiSecondari
        let allTheIngredients = viewModel.modelCollectionFromCollectionID(collectionId: allIngredientsID, modelPath: \.allMyIngredients)
        let allMinusBozzeEArchiviati = allTheIngredients.filter({
            !$0.status.checkStatusTransition(check: .archiviato)
        })
        
        return allMinusBozzeEArchiviati
        
    }
    
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
            else { continue }
        }
    
        return .carne
        
    }
    
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
    
    /// Ritorna la media in forma di stringa delle recensioni di un Piatto, e il numero delle stesse come Int, e un array con i modelli delle recensioni
   public func ratingInfo(readOnlyViewModel:FoodieViewModel) -> (media:Double,count:Int,allModelReview:[DishRatingModel]) {
        
        // Nota 13.09

        let allLocalReviews:[DishRatingModel] = readOnlyViewModel.modelCollectionFromCollectionID(collectionId: self.rifReviews, modelPath: \.allMyReviews)
        
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
    
    

    
    // New 02.1.23
    
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
    
    /// Controlla l'origine degli ingredienti e restituisce un array con le diete compatibili
    public func returnDietAvaible(viewModel:FoodieViewModel) -> (inDishTipologia:[TipoDieta],inStringa:[String]) {
        
        let allModelIngredients = self.allIngredientsAttivi(viewModel: viewModel)
        
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
        
       /* for ingredient in allModelIngredients {
            
            if ingredient.origine == .animale {
                
                if ingredient.allergeni.contains(.latte_e_derivati) { milkIn.append(ingredient) }
                
                else { animalOrFish.append(ingredient) }
                        }

            if ingredient.allergeni.contains(.glutine) { glutenIn.append(ingredient)}
        } */
        
        // step 2 -->
        
        var dieteOk:[TipoDieta] = []
        
        if glutenIn.isEmpty {dieteOk.append(.glutenFree)}
        if milkIn.isEmpty && animalOrFish.isEmpty {dieteOk.append(contentsOf: [.vegano,.vegariano,.vegetariano])}
        else if milkIn.isEmpty { dieteOk.append(.vegariano)}
        else if animalOrFish.isEmpty {dieteOk.append(.vegetariano)}
        else {dieteOk.append(.standard) }
 
        let dieteOkInStringa:[String] = dieteOk.map({$0.simpleDescription()})
 
      /*  for diet in dieteOk {
            
            let stringDiet = diet.simpleDescription()
            dieteOkInStringa.append(stringDiet)
       
        } */
    
        return (dieteOk,dieteOkInStringa)
    }
    
    /*
    /// Controlla l'origine degli ingredienti e restituisce un array con le diete compatibili
    func returnDietAvaible(viewModel:FoodieViewModel) -> (inDishTipologia:[TipoDieta],inStringa:[String]) {
        
        let allModelIngredients = self.allIngredientsAttivi(viewModel: viewModel)
        
        // step 1 ->
        var animalOrFish: [IngredientModel] = []
        var milkIn: [IngredientModel] = []
        var glutenIn: [IngredientModel] = []
        
        for ingredient in allModelIngredients {
            
            if ingredient.origine == .animale {
                
                if ingredient.allergeni.contains(.latte_e_derivati) { milkIn.append(ingredient) }
                
                else { animalOrFish.append(ingredient) }
                        }

            if ingredient.allergeni.contains(.glutine) { glutenIn.append(ingredient)}
        }
        
        // step 2 -->
        
        var dieteOk:[TipoDieta] = []
        
        if glutenIn.isEmpty {dieteOk.append(.glutenFree)}
        
        if milkIn.isEmpty && animalOrFish.isEmpty {dieteOk.append(contentsOf: [.vegano,.vegariano,.vegetariano])}
        else if milkIn.isEmpty { dieteOk.append(.vegariano)}
        else if animalOrFish.isEmpty {dieteOk.append(.vegetariano)}
        else {dieteOk.append(.standard) }
 
        var dieteOkInStringa:[String] = []
 
        for diet in dieteOk {
            
            let stringDiet = diet.simpleDescription()
            dieteOkInStringa.append(stringDiet)
       
        }
    
        return (dieteOk,dieteOkInStringa)
    } */ // 10.01.23 Backup per Upgrade e bug fix
    
    
    // New
    
    
    // MyProCloudPack_L1
    
   /* public init(frDocID:String,frDoc: [String:Any]) {
        
        let percorsoInt = frDoc[DataBaseField.percorsoProdotto] as? Int ?? 0
        let statusInt = frDoc[DataBaseField.status] as? Int ?? 0
        let priceMap = frDoc[DataBaseField.pricingPiatto] as? [[String:Any]] ?? []
        
        self.percorsoProdotto = DishModel.PercorsoProdotto.convertiInCase(fromNumber: percorsoInt)
        self.id = frDocID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.rifReviews = frDoc[DataBaseField.rifReviews] as? [String] ?? []
        self.ingredientiPrincipali = frDoc[DataBaseField.ingredientiPrincipali] as? [String] ?? []
        self.ingredientiSecondari = frDoc[DataBaseField.ingredientiSecondari] as? [String] ?? []
        self.elencoIngredientiOff = frDoc[DataBaseField.elencoIngredientiOff] as? [String:String] ?? [:]
        self.idIngredienteDaSostituire = nil
        self.categoriaMenu = frDoc[DataBaseField.categoriaMenu] as? String ?? ""
        self.mostraDieteCompatibili = frDoc[DataBaseField.mostraDieteCompatibili] as? Bool ?? false
        self.status = StatusModel.convertiInCase(fromNumber: statusInt)
        self.pricingPiatto = priceMap.map({DishFormat(frMapData: $0)})
 
    }
    
    public struct DataBaseField {
        
        public static let percorsoProdotto = "percorsoProdotto"
        public static let intestazione = "intestazione"
        public static let descrizione = "descrizione"
        public static let rifReviews = "rifReview"
        public static let ingredientiPrincipali = "ingredientiPrincipali"
        public static let ingredientiSecondari = "ingredientiSecondari"
        public static let elencoIngredientiOff = "elencoIngredientiOff"
        public static let categoriaMenu = "categoriaMenu"
        public static let mostraDieteCompatibili = "mostraDieteCompatibili"
        public static let status = "status"
        public static let pricingPiatto = "pricing"
        
    } */

    func creaID(fromValue: String) -> String {
        print("DishModel/creaID()")
      return fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    } // non mi piace
    

    /// conta gli ingredienti secondari e principali
    public func countIngredients() -> (count:Int,canBeExpanded:Bool) { // Da sistemare (04.10) // gli ingredienti non posso essere == 0
        let count = (self.ingredientiPrincipali + self.ingredientiSecondari).count
        let cantBe:Bool = {
            count == 0 ||
            self.ingredientiPrincipali.contains(self.id)
        }()
       return (count,cantBe)
    }
  
    /// controlla la presenza di un ingrediente soltanto fra i principali e i secondari
    public func checkIngredientsInPlain(idIngrediente:String) -> Bool {
        
        let all = self.ingredientiPrincipali + self.ingredientiSecondari
        let condition = all.contains(where: {$0 == idIngrediente})
        return condition
    }
    
    /// Ritorna tutti i rif degli ingredienti contenuti nel piatto, senza badare allo status, ritorna i principali, i secondari, e i sostituti
    private func allIngredientsRif() -> [String] {
        
        let allIDSostituti = self.elencoIngredientiOff.values
        let allTheIngredients = self.ingredientiPrincipali + self.ingredientiSecondari + allIDSostituti
        
        return allTheIngredients
    }
    
    /// Controlla la presenza dell'idIngrediente sia fra gl iingredienti Principali e Secondari, sia fra i sostituti
    public func checkIngredientsIn(idIngrediente:String) -> Bool {

        let allTheIngredients = self.allIngredientsRif()
        let condition = allTheIngredients.contains(idIngrediente)
        
        return condition

    }
    
    /// cerca corrispondenza delle chiavi sostituite negli array ingredienti Principali e Secondari, e in caso di assenza cancella la key portandola su nil
   mutating public func autoCleanElencoIngredientiOff() {
        
        let allKey = self.elencoIngredientiOff.keys
        
        for key in allKey {
            
            if self.ingredientiPrincipali.contains(key) || self.ingredientiSecondari.contains(key) { continue }
            else { self.elencoIngredientiOff[key] = nil }
        }
        
    }
    
    /// controlla se un ingrediente ha un sostituto, ovvero se esiste la chiave a suo nome nell'elencoIngredientiOff
    public func checkIngredientHasSubstitute(idIngrediente:String) -> Bool {
        
        let allSostituiti = self.elencoIngredientiOff.keys
        let condition = allSostituiti.contains(where: {$0 == idIngrediente})
        return condition
    }
    
    /// ritorna il path dell'ingrediente, quindi o l'array di ingredienti principali, o quello dei secondari, o se assente in entrambi ritorna nil
    public func individuaPathIngrediente(idIngrediente:String) -> (path:WritableKeyPath<Self,[String]>?,index:Int?) {
        
        if let index = self.ingredientiPrincipali.firstIndex(of: idIngrediente) {
            
            return (\.ingredientiPrincipali,index)
            
        } else if let index = self.ingredientiSecondari.firstIndex(of: idIngrediente) {
            
            return(\.ingredientiSecondari,index)
            
        } else { return (nil,nil)}
        
    }
    
    /// ritorna true se tutte le proprietà optional sono state compilate, e dunque il modello è completo.
    public func optionalComplete() -> Bool {
        
        self.descrizione != "" &&
        self.mostraDieteCompatibili &&
        !self.ingredientiPrincipali.isEmpty
       
    }
    
    public func estrapolaPrezzoMandatoryMaggiore() -> Double {
        
        guard let labelPrice = self.pricingPiatto.first(where: {$0.type == .mandatory}) else { return 0.0 }
        let price = Double(labelPrice.price) ?? 0.0
        return price
        
    }
    
    public enum BasePreparazione:MyProEnumPack_L0 {

        public static var allCase:[BasePreparazione] = [.vegetale,.carne,.pesce]
        
        case vegetale,carne,pesce
        
        public func simpleDescription() -> String {
            
            switch self {
            case .vegetale:
                return "Verdure"
            case .carne:
                return "Carne"
            case .pesce:
                return "Pesce"
            }
        }
        
        public func returnTypeCase() -> DishModel.BasePreparazione {
           return self
        }

        public func orderAndStorageValue() -> Int {
            return 0
        }
        
       public func imageAssociate() -> String {
            
            switch self {
            case .vegetale:
                return "🥗"
            case .carne:
                return "🥩"
            case .pesce:
                return "🍤"
            }

        }
    }
    
    public enum PercorsoProdotto:MyProEnumPack_L0,Codable {

        public static var allCases:[PercorsoProdotto] = [.preparazioneFood,.preparazioneBeverage,.prodottoFinito]
        
        case prodottoFinito //= "Prodotto Finito"
        case preparazioneFood //= "Piatto" // case standard di default
        case preparazioneBeverage //= "Drink"
        
        public func imageAssociated() -> String {
            switch self {
            case .prodottoFinito:
                return "🧃"
            case .preparazioneFood:
                return "fork.knife.circle"
            case .preparazioneBeverage:
                return "wineglass"
                
            }
        }
        
        public func simpleDescription() -> String {
            
            switch self {
                
            case .prodottoFinito:
                return "Prodotto Finito"
            case .preparazioneFood:
                return "Piatto"
            case .preparazioneBeverage:
                return "Drink"
                
            }
            
        }
        
        public func returnTypeCase() -> DishModel.PercorsoProdotto {
            self
        }
        
        public func orderAndStorageValue() -> Int {
            
            switch self {
                
            case .prodottoFinito:
                return 0
            case .preparazioneFood:
                return 1
            case .preparazioneBeverage:
                return 2
                
            }
        }
        
       /* public static func convertiInCase(fromNumber: Int) -> DishModel.PercorsoProdotto {
            
            switch fromNumber {
            case 0: return .prodottoFinito
            case 1: return .preparazioneFood
            case 2: return .preparazioneBeverage
            default: return .preparazioneFood
            }
        } */
        
        public func extendedDescription() -> String {
            
            switch self {
            case .prodottoFinito:
                return "Trattasi di un prodotto pronto che non richiede altri ingredienti per essere servito"
            default:
                return "E' il frutto della combinazione e/o lavorazione di uno o più ingredienti"
            }
        }
        
    }
    
}

/*
public struct DishModel: MyProToolPack_L1,MyProVisualPack_L1,MyProDescriptionPack_L0,MyProStatusPack_L1,MyProCloudPack_L1 {

    static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [DishModel]> {
        return \.allMyDish
    }
    
   static func == (lhs: DishModel, rhs: DishModel) -> Bool {
       
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
        lhs.status == rhs.status &&
        lhs.rifReviews == rhs.rifReviews &&
        lhs.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        lhs.ingredientiSecondari == rhs.ingredientiSecondari &&
        lhs.elencoIngredientiOff == rhs.elencoIngredientiOff &&
        lhs.idIngredienteDaSostituire == rhs.idIngredienteDaSostituire &&
        lhs.categoriaMenu == rhs.categoriaMenu &&
        lhs.mostraDieteCompatibili == rhs.mostraDieteCompatibili &&
        lhs.pricingPiatto == rhs.pricingPiatto &&
        lhs.percorsoProdotto == rhs.percorsoProdotto

    }

    var id: String
    var percorsoProdotto:PercorsoProdotto
    
    var intestazione: String
    var descrizione: String
    var rifReviews: [String] // Nota 13.09
    
    var ingredientiPrincipali: [String]
    var ingredientiSecondari: [String]
   
    var elencoIngredientiOff: [String:String] // id Sostituito: idSOSTITUTO
    var idIngredienteDaSostituire: String? // Nota 30.08
    
    var categoriaMenu: String
    var mostraDieteCompatibili: Bool

    var status: StatusModel
    var pricingPiatto:[DishFormat]
    
    public init() {
        
        self.percorsoProdotto = .preparazioneFood
        self.id = UUID().uuidString
        self.intestazione = ""
        self.descrizione = ""
        self.rifReviews = []
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.elencoIngredientiOff = [:]
        self.idIngredienteDaSostituire = nil
        self.categoriaMenu = CategoriaMenu.defaultValue.id
        self.mostraDieteCompatibili = false
        self.status = .bozza()
        self.pricingPiatto = []
        
    }

    public init(percorsoProdotto: PercorsoProdotto, id: String, intestazione: String, descrizione: String, rifReviews: [String], ingredientiPrincipali: [String], ingredientiSecondari: [String], elencoIngredientiOff: [String : String], idIngredienteDaSostituire: String? = nil, categoriaMenu: String, mostraDieteCompatibili: Bool, status: StatusModel, pricingPiatto: [DishFormat], categoriaMenuDEPRECATA: CategoriaMenu, dieteCompatibili: [TipoDieta], aBaseDi: OrigineIngrediente) {
        
        self.percorsoProdotto = percorsoProdotto
        self.id = UUID().uuidString
        self.intestazione = intestazione
        self.descrizione = descrizione
        self.rifReviews = rifReviews
        self.ingredientiPrincipali = ingredientiPrincipali
        self.ingredientiSecondari = ingredientiSecondari
        self.elencoIngredientiOff = elencoIngredientiOff
        self.idIngredienteDaSostituire = idIngredienteDaSostituire
        self.categoriaMenu = categoriaMenu
        self.mostraDieteCompatibili = mostraDieteCompatibili
        self.status = status
        self.pricingPiatto = pricingPiatto

    }
    
    public init(id:String = UUID().uuidString) {
        // Necessario quando creiamo l'ibrido, poichè l'id va creato fuori e dato uguale sia all'ingredienteDiSistema che al model
        self.percorsoProdotto = .preparazioneFood
        self.id = id
        self.intestazione = ""
        self.descrizione = ""
        self.rifReviews = []
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.elencoIngredientiOff = [:]
        self.idIngredienteDaSostituire = nil
        self.categoriaMenu = CategoriaMenu.defaultValue.id
        self.mostraDieteCompatibili = false
        self.status = .bozza()
        self.pricingPiatto = []
        

    }
    
    // MyProCloudPack_L1
    
    public init(frDocID:String,frDoc: [String:Any]) {
        
        let percorsoInt = frDoc[DataBaseField.percorsoProdotto] as? Int ?? 0
        let statusInt = frDoc[DataBaseField.status] as? Int ?? 0
        let priceMap = frDoc[DataBaseField.pricingPiatto] as? [[String:Any]] ?? []
        
        self.percorsoProdotto = DishModel.PercorsoProdotto.convertiInCase(fromNumber: percorsoInt)
        self.id = frDocID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.rifReviews = frDoc[DataBaseField.rifReviews] as? [String] ?? []
        self.ingredientiPrincipali = frDoc[DataBaseField.ingredientiPrincipali] as? [String] ?? []
        self.ingredientiSecondari = frDoc[DataBaseField.ingredientiSecondari] as? [String] ?? []
        self.elencoIngredientiOff = frDoc[DataBaseField.elencoIngredientiOff] as? [String:String] ?? [:]
        self.idIngredienteDaSostituire = nil
        self.categoriaMenu = frDoc[DataBaseField.categoriaMenu] as? String ?? ""
        self.mostraDieteCompatibili = frDoc[DataBaseField.mostraDieteCompatibili] as? Bool ?? false
        self.status = StatusModel.convertiInCase(fromNumber: statusInt)
        self.pricingPiatto = priceMap.map({DishFormat(frMapData: $0)})
 
    }
    
    func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String : Any] {
        
        let documentData:[String:Any] = [
            
            DataBaseField.percorsoProdotto : self.percorsoProdotto.orderAndStorageValue(),
            DataBaseField.intestazione : self.intestazione,
            DataBaseField.descrizione : self.descrizione,
            DataBaseField.rifReviews : self.rifReviews,
            DataBaseField.ingredientiPrincipali : self.ingredientiPrincipali,
            DataBaseField.ingredientiSecondari : self.ingredientiSecondari,
            DataBaseField.elencoIngredientiOff : self.elencoIngredientiOff,
            DataBaseField.categoriaMenu : self.categoriaMenu,
            DataBaseField.mostraDieteCompatibili : self.mostraDieteCompatibili,
            DataBaseField.status : self.status.orderAndStorageValue(),
            DataBaseField.pricingPiatto : self.pricingPiatto.map({$0.documentDataForFirebaseSavingAction()})
 
        ]
        return documentData
    }
    
    public struct DataBaseField {
        
        static let percorsoProdotto = "percorsoProdotto"
        static let intestazione = "intestazione"
        static let descrizione = "descrizione"
        static let rifReviews = "rifReview"
        static let ingredientiPrincipali = "ingredientiPrincipali"
        static let ingredientiSecondari = "ingredientiSecondari"
        static let elencoIngredientiOff = "elencoIngredientiOff"
        static let categoriaMenu = "categoriaMenu"
        static let mostraDieteCompatibili = "mostraDieteCompatibili"
        static let status = "status"
        static let pricingPiatto = "pricing"
        
    }
    
    //
    
    func manageModelDelete(viewModel: AccounterVM) {
        
        let allMenuWithDish = viewModel.allMenuContaining(idPiatto: self.id)
        
        guard allMenuWithDish.countWhereDishIsIn != 0 else {
            
            viewModel.deleteItemModel(itemModel: self)
            return
            
        }
        
        var allCleanedMenu:[MenuModel] = []
        for eachMenu in allMenuWithDish.allModelWithDish {
            
            var new = eachMenu
            
            if eachMenu.status.checkStatusTransition(check: .disponibile) {
                new.autoManageCambioStatus(viewModel: viewModel, idPiattoEscluso: self.id)
            }
            new.rifDishIn.removeAll(where: {$0 == self.id})
            
           /* if new.rifDishIn.isEmpty { new.status = eachMenu.status.changeStatusTransition(changeIn: .inPausa)} */
            allCleanedMenu.append(new)
            
        }
        viewModel.updateItemModelCollection(items: allCleanedMenu)
        viewModel.deleteItemModel(itemModel: self)
    }
    
    /// Porta lo status automaticamente (previa verifica delle condizioni) nello status .inPausa
   /* func autoManageCambioStatus(viewModel:AccounterVM) {
        
        guard self.status.checkStatusTransition(check: .disponibile) else { return }
        
        let allMenuWithDish = viewModel.allMenuContaining(idPiatto: self.id)
        for eachMenu in allMenuWithDish.allModelWithDish {

            eachMenu.autoManageCambioStatus(viewModel: viewModel,idPiattoEscluso: self.id)
   
        }
        viewModel.manageCambioStatusModel(model: self, nuovoStatus: .inPausa)
    } */
    
    func manageCambioStatus(nuovoStatus: StatusTransition, viewModel: AccounterVM) {
            //Nota 27.11 // Nota 28.11
        let isCurrentlyDisponibile = self.status.checkStatusTransition(check: .disponibile)
        viewModel.manageCambioStatusModel(model: self, nuovoStatus: nuovoStatus)
      //  viewModel.remoteStorage.modelRif_modified.insert(self.id)
        
        guard isCurrentlyDisponibile else { return }

        let allMenuWithDish = viewModel.allMenuContaining(idPiatto: self.id)
        
        for eachMenu in allMenuWithDish.allModelWithDish {
            if eachMenu.status.checkStatusTransition(check: .disponibile) {
                eachMenu.autoManageCambioStatus(viewModel: viewModel,idPiattoEscluso: self.id)
              //  eachMenu.manageCambioStatus(nuovoStatus: .inPausa, viewModel: viewModel)
            }
        }
    }

    
    func conditionToManageMenuInterattivo() -> (disableCustom: Bool, disableStatus: Bool, disableEdit: Bool, disableTrash: Bool, opacizzaAll: CGFloat) {
        
      if self.status.checkStatusTransition(check: .disponibile) {
            
            return (false,false,false,true,1.0)
        }
        
        else if self.status.checkStatusTransition(check: .inPausa) {
            
            return (false,false,false,true,0.8)
        }
        
        else {
            return (true,false,true,false,0.5)
        }
        
    }
    
    func conditionToManageMenuInterattivo_dispoStatusDisabled(viewModel:AccounterVM) -> Bool { false }
    
    func creaID(fromValue: String) -> String {
        print("DishModel/creaID()")
      return fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    } // non mi piace
    
    func modelStatusDescription() -> String {
      //  "Piatto (\(self.status.simpleDescription().capitalized))"
        "\(self.percorsoProdotto.simpleDescription()) (\(self.status.simpleDescription().capitalized))"
    }
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [DishModel]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
       // return (\.allMyDish, "Lista Piatti", "Piatto","fork.knife.circle")
        return (\.allMyDish, "Lista Piatti", self.percorsoProdotto.simpleDescription(),self.percorsoProdotto.imageAssociated())
    }
       
    func pathDestination() -> DestinationPathView {
        DestinationPathView.piatto(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // SearchPack
    
    static func sortModelInstance(lhs: DishModel, rhs: DishModel,condition:FilterPropertyModel.SortCondition?,readOnlyVM:AccounterVM) -> Bool {
        
        switch condition {
            
  
        case .alfabeticoDecrescente:
            return lhs.intestazione > rhs.intestazione
            
        case .livelloScorte:
            return readOnlyVM.inventarioScorte.statoScorteIng(idIngredient: lhs.id).orderAndStorageValue() <
                readOnlyVM.inventarioScorte.statoScorteIng(idIngredient: rhs.id).orderAndStorageValue()
        case .mostUsed:
            return readOnlyVM.allMenuContaining(idPiatto: lhs.id).countWhereDishIsIn >
            readOnlyVM.allMenuContaining(idPiatto: rhs.id).countWhereDishIsIn
            
        case .mostRated:
            return lhs.rifReviews.count > rhs.rifReviews.count
            
        case .topRated:
            return lhs.topRatedValue(readOnlyVM: readOnlyVM) >
            rhs.topRatedValue(readOnlyVM: readOnlyVM)
            
        case .topPriced:
            return lhs.estrapolaPrezzoMandatoryMaggiore() >
            rhs.estrapolaPrezzoMandatoryMaggiore()
            
        default:
            return lhs.intestazione < rhs.intestazione
        }
    }
    
    func modelStringResearch(string: String, readOnlyVM:AccounterVM?) -> Bool {
        
        guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let conditionOne = self.intestazione.lowercased().contains(ricerca)
        
        guard readOnlyVM != nil else { return conditionOne } // è inutile percheè passeremo sempre un valore valido. Lo mettiamo per forma. Abbiamo messo il parametro optional per non passarlo negli altri modelli dove non ci serve
        
        let allIngredients = self.allMinusArchiviati(viewModel: readOnlyVM!)
        let allINGMapped = allIngredients.map({$0.intestazione.lowercased()})
        
        let allInGChecked = allINGMapped.filter({$0.contains(ricerca)})
        let conditionTwo = !allInGChecked.isEmpty
        
        return conditionOne || conditionTwo
        // inserire la ricerca degli ingredienti
    }
    
    func modelPropertyCompare(filterProperty: FilterPropertyModel, readOnlyVM: AccounterVM) -> Bool {
        
        let allAllergeniIn = self.calcolaAllergeniNelPiatto(viewModel: readOnlyVM)
        let allDietAvaible = self.returnDietAvaible(viewModel: readOnlyVM).inDishTipologia
        let basePreparazione = self.calcolaBaseDellaPreparazione(readOnlyVM: readOnlyVM)
        
        return self.modelStringResearch(string: filterProperty.stringaRicerca,readOnlyVM: readOnlyVM) &&
        
        filterProperty.comparePropertyToCollection(localProperty: self.percorsoProdotto, filterCollection: \.percorsoPRP) &&
        
        filterProperty.compareStatusTransition(localStatus: self.status) &&
        
        filterProperty.compareCollectionToCollection(localCollection: allAllergeniIn, filterCollection: \.allergeniIn) &&
        
        filterProperty.compareCollectionToCollection(localCollection:allDietAvaible, filterCollection: \.dietePRP)  &&
        
        filterProperty.compareStatoScorte(modelId: self.id, readOnlyVM: readOnlyVM) &&
        
        self.preCallHasAllIngredientSameQuality(viewModel: readOnlyVM, kpQuality: \.produzione, quality: filterProperty.produzioneING) &&
        
        self.preCallHasAllIngredientSameQuality(viewModel: readOnlyVM, kpQuality: \.provenienza, quality: filterProperty.provenienzaING) &&
        
        filterProperty.comparePropertyToProperty(local: basePreparazione, filter: \.basePRP)
        
    }
    
    // end SearchPack
    
    func returnModelRowView(rowSize:RowSize) -> some View {
        DishModel_RowView(item: self,rowSize: rowSize) // conforme al Protocollo
    }

    func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let generalDisabled = self.status.checkStatusTransition(check: .archiviato)
        
        let disabilitaReview = self.rifReviews.isEmpty
        let priceCount = self.pricingPiatto.count
        let currencyCode = Locale.current.currency?.identifier ?? "EUR"
        let (ingredientsCount,ingredientsCantBeExpanded) = countIngredients()
        
        let isDelGiorno = viewModel.checkMenuDiSistemaContainDish(idPiatto: self.id, menuDiSistema: .delGiorno)
        let isDelloChef = viewModel.checkMenuDiSistemaContainDish(idPiatto: self.id, menuDiSistema: .delloChef)

        let isDisponibile = self.status.checkStatusTransition(check: .disponibile)

        let(_,allMenuMinusDS,allWhereDishIsIn) = viewModel.allMenuMinusDiSistemaPlusContain(idPiatto: self.id)
        
      return VStack {
            
            Button {
                
                viewModel[keyPath: navigationPath].append(DestinationPathView.recensioni(self))
                
            } label: {
                HStack{
                    Text("Vedi Recensioni")
                    Image(systemName: "eye")
                }
            }.disabled(disabilitaReview)
          
          if priceCount > 1 {
              
              Menu {
             
                 ForEach(self.pricingPiatto,id:\.self) { format in
        
                     let price = Double(format.price) ?? 0
                     Text("\(format.label) : \(price,format: .currency(code: currencyCode))")
                  //   Text("\(format.label) : € \(format.price)")
                  }

                  
              } label: {

                  Text("Prezziario (\(priceCount))")
                
              }// end label menu

          } // end if

          Button {
              
              viewModel.manageInOutPiattoDaMenuDiSistema(idPiatto: self.id, menuDiSistema: .delGiorno)

          } label: {
              HStack{
                  
                  Text(isDelGiorno ? "[-] dal Menu del Giorno" : "[+] nel Menu del Giorno")
                  Image(systemName:isDelGiorno ? "clock.badge.xmark" : "clock.badge.checkmark")
              }
          }.disabled(!isDisponibile)
          
          Button {
              
              viewModel.manageInOutPiattoDaMenuDiSistema(idPiatto: self.id, menuDiSistema: .delloChef)

          } label: {
              HStack{
                  Text(isDelloChef ? "Rimuovi dai consigliati" : "Consigliato dallo 👨🏻‍🍳")
                  Image(systemName:isDelloChef ? "x.circle" : "clock.badge.checkmark")
              }
          }.disabled(!isDisponibile)
          
          Button {
             
              viewModel[keyPath: navigationPath].append(DestinationPathView.vistaMenuEspansa(self))
        
          } label: {
              HStack{
                  Text("Espandi Menu (\(allWhereDishIsIn)/\(allMenuMinusDS))")
                  Image (systemName: "menucard")
              }
          }.disabled(allMenuMinusDS == 0)
          
          if ingredientsCantBeExpanded {
             
              let statoScorte = viewModel.inventarioScorte.statoScorteIng(idIngredient: self.id)
              let ultimoAcquisto = viewModel.inventarioScorte.dataUltimoAcquisto(idIngrediente: self.id)
              
              
              Menu {
                  
                  Button("in Esaurimento") {
                      viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inEsaurimento)
                  }.disabled(statoScorte != .inStock)
                  
                  Button("Esaurite") {
                      viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .esaurito)
                     // innsesto 01.12.22
                      if self.status.checkStatusTransition(check: .disponibile) {
                          
                          viewModel.alertItem = AlertModel(
                            title: "Update Status Prodotto",
                            message: "Clicca su conferma se desideri porre il prodotto - \(self.intestazione) - nello status di - in Pausa -\nI Menu che contengono il prodotto potrebbero subire anch'essi modifiche di status.",
                            actionPlus: ActionModel(
                                title: .conferma,
                                action: {
                                    self.manageCambioStatus(nuovoStatus: .inPausa, viewModel: viewModel)
                                }))
                      }
                      
                      
                  }.disabled(statoScorte == .esaurito || statoScorte == .inArrivo)
                  
                  if statoScorte == .esaurito || statoScorte == .inEsaurimento {
                      
                      Button("Rimetti in Stock") {
                          viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inStock)
                      }
                  }
                  
                  Text("Ultimo Acquisto:\n\(ultimoAcquisto)")
                  
                  if let ingDS = viewModel.modelFromId(id: self.id, modelPath: \.allMyIngredients) {
                      
                      Button("Cronologia Acquisti") {
                          viewModel[keyPath: navigationPath].append(DestinationPathView.vistaCronologiaAcquisti(ingDS))
                      }
                  }
              } label: {
                  HStack{
                      Text("Scorte \(statoScorte.simpleDescription())")
                      Image(systemName: statoScorte.imageAssociata())
                  }
              }
              
          } else {
              
              Button {
                  
                  viewModel[keyPath: navigationPath].append(DestinationPathView.vistaIngredientiEspansa(self))
            
              } label: {
                  HStack{
                      Text("Espandi Ingredienti (\(ingredientsCount))")
                      Image(systemName:"leaf")
                  }
              }
          }
        }
      .disabled(generalDisabled)
    }
    
    /// conta gli ingredienti secondari e principali
    func countIngredients() -> (count:Int,canBeExpanded:Bool) { // Da sistemare (04.10) // gli ingredienti non posso essere == 0
        let count = (self.ingredientiPrincipali + self.ingredientiSecondari).count
        let cantBe:Bool = {
            count == 0 ||
            self.ingredientiPrincipali.contains(self.id)
        }()
       return (count,cantBe)
    }
  
    /// controlla la presenza di un ingrediente soltanto fra i principali e i secondari
    func checkIngredientsInPlain(idIngrediente:String) -> Bool {
        
        let all = self.ingredientiPrincipali + self.ingredientiSecondari
        let condition = all.contains(where: {$0 == idIngrediente})
        return condition
    }
    
    /// Ritorna tutti i rif degli ingredienti contenuti nel piatto, senza badare allo status, ritorna i principali, i secondari, e i sostituti
    private func allIngredientsRif() -> [String] {
        
        let allIDSostituti = self.elencoIngredientiOff.values
        let allTheIngredients = self.ingredientiPrincipali + self.ingredientiSecondari + allIDSostituti
        
        return allTheIngredients
    }
    
    /// Controlla la presenza dell'idIngrediente sia fra gl iingredienti Principali e Secondari, sia fra i sostituti
    func checkIngredientsIn(idIngrediente:String) -> Bool {

        let allTheIngredients = self.allIngredientsRif()
        let condition = allTheIngredients.contains(idIngrediente)
        
        return condition

    }
    
    /// cerca corrispondenza delle chiavi sostituite negli array ingredienti Principali e Secondari, e in caso di assenza cancella la key portandola su nil
   mutating func autoCleanElencoIngredientiOff() {
        
        let allKey = self.elencoIngredientiOff.keys
        
        for key in allKey {
            
            if self.ingredientiPrincipali.contains(key) || self.ingredientiSecondari.contains(key) { continue }
            else { self.elencoIngredientiOff[key] = nil }
        }
        
    }
    
    /// controlla se un ingrediente ha un sostituto, ovvero se esiste la chiave a suo nome nell'elencoIngredientiOff
    func checkIngredientHasSubstitute(idIngrediente:String) -> Bool {
        
        let allSostituiti = self.elencoIngredientiOff.keys
        let condition = allSostituiti.contains(where: {$0 == idIngrediente})
        return condition
    }
    
    /// ritorna il path dell'ingrediente, quindi o l'array di ingredienti principali, o quello dei secondari, o se assente in entrambi ritorna nil
     func individuaPathIngrediente(idIngrediente:String) -> (path:WritableKeyPath<Self,[String]>?,index:Int?) {
        
        if let index = self.ingredientiPrincipali.firstIndex(of: idIngrediente) {
            
            return (\.ingredientiPrincipali,index)
            
        } else if let index = self.ingredientiSecondari.firstIndex(of: idIngrediente) {
            
            return(\.ingredientiSecondari,index)
            
        } else { return (nil,nil)}
        
    }
    
    /// ritorna gli ingredienti meno le bozze e gli archiviati. Comprende i completi(.pubblici) e i completi(.inPausa)
    func allMinusArchiviati(viewModel:AccounterVM) -> [IngredientModel] {
        
        let allIngredientsID = self.ingredientiPrincipali + self.ingredientiSecondari
        let allTheIngredients = viewModel.modelCollectionFromCollectionID(collectionId: allIngredientsID, modelPath: \.allMyIngredients)
        let allMinusBozzeEArchiviati = allTheIngredients.filter({
          // !$0.status.checkStatusTransition(check: .archiviato)
            !$0.status.checkStatusTransition(check: .archiviato)
           /* $0.status != .completo(.archiviato) &&
            $0.status != .bozza() */
        })
        
        return allMinusBozzeEArchiviati
    }
    
    /// ritorna gli ingredienti Attivi sostituendo gli ingredienti inPausa con gli eventuali sostituti
    func allIngredientsAttivi(viewModel:AccounterVM) -> [IngredientModel] {
        
        // Innesto 06.10
        guard !self.ingredientiPrincipali.contains(self.id) else {
           // Trattasi di ibrido
            if let model = viewModel.modelFromId(id: self.id, modelPath: \.allMyIngredients) { return [model] }
            else { return [] }
        }
        
        let allMinusBozzeEArchiviati = allMinusArchiviati(viewModel: viewModel)

        let allInPausa = allMinusBozzeEArchiviati.filter({
            $0.status.checkStatusTransition(check: .inPausa)
            })
        
        guard !allInPausa.isEmpty else { return allMinusBozzeEArchiviati }
        
        guard !self.elencoIngredientiOff.isEmpty else {
            return allMinusBozzeEArchiviati.filter({
                $0.status.checkStatusTransition(check: .disponibile)
            })
        }
        
        var allActiveIDs = allMinusBozzeEArchiviati.map({$0.id})
        
        for ingredient in allInPausa {
            
            let position = allActiveIDs.firstIndex{$0 == ingredient.id}
            
            if let sostituto = self.elencoIngredientiOff[ingredient.id] {
                
                let(isActive,_,_) = viewModel.infoFromId(id: sostituto, modelPath: \.allMyIngredients)
                
                if isActive {
                    allActiveIDs[position!] = sostituto
                } else { allActiveIDs.remove(at: position!)}
                
            } else { allActiveIDs.remove(at: position!)}
            
        }
        
        let allActiveModels = viewModel.modelCollectionFromCollectionID(collectionId: allActiveIDs, modelPath: \.allMyIngredients)
        
        return allActiveModels
    }
    
    /// controlla tutti gii ingredienti attivi del piatto, se sono in stock, in arrivo, o in esaurimento. In caso affermativo ritorna true, il piatto è eseguibile
    func controllaSeEseguibile(viewModel:AccounterVM) -> Bool {
        
        let allIngActive = self.allIngredientsAttivi(viewModel: viewModel)
        let mapStock = allIngActive.map({
            viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id)
        })
        let filtraStock = mapStock.filter({
            $0 != .esaurito
        })
        
        return allIngActive.count == filtraStock.count
        
    }
    
    private func preCallHasAllIngredientSameQuality<T:MyProEnumPack_L0>(viewModel:AccounterVM,kpQuality:KeyPath<IngredientModel,T>,quality:T?) -> Bool {
        
        guard quality != nil else { return true }
        
       return self.hasAllIngredientSameQuality(viewModel: viewModel, kpQuality: kpQuality, quality: quality!)
        
    }
    
    func hasAllIngredientSameQuality<T:MyProEnumPack_L0>(viewModel:AccounterVM,kpQuality:KeyPath<IngredientModel,T>,quality:T) -> Bool {
        
        let allIngredient = self.allIngredientsAttivi(viewModel: viewModel)
        guard !allIngredient.isEmpty else { return false }
        
        for ingredient in allIngredient {
            if ingredient[keyPath: kpQuality] == quality { continue }
            else { return false }
        }
        return true
    }
     
    func calcolaAllergeniNelPiatto(viewModel:AccounterVM) -> [AllergeniIngrediente] {
      
        let allIngredients = self.allIngredientsAttivi(viewModel: viewModel)
        var allergeniPiatto:[AllergeniIngrediente] = []
        
             for ingredient in allIngredients {
                 
                 let allergeneIngre:[AllergeniIngrediente] = ingredient.allergeni
                 allergeniPiatto.append(contentsOf: allergeneIngre)
             }

            let setAllergeniPiatto = Set(allergeniPiatto)
            let orderedAllergeni = Array(setAllergeniPiatto).sorted { $0.simpleDescription() < $1.simpleDescription() }
        
            return orderedAllergeni
    
     }
    
    /// Controlla l'origine degli ingredienti e restituisce un array con le diete compatibili
    func returnDietAvaible(viewModel:AccounterVM) -> (inDishTipologia:[TipoDieta],inStringa:[String]) {
        
        let allModelIngredients = self.allIngredientsAttivi(viewModel: viewModel)
        
        // step 1 ->
        var animalOrFish: [IngredientModel] = []
        var milkIn: [IngredientModel] = []
        var glutenIn: [IngredientModel] = []
        
        for ingredient in allModelIngredients {
            
            if ingredient.origine == .animale {
                
                if ingredient.allergeni.contains(.latte_e_derivati) { milkIn.append(ingredient) }
                
                else { animalOrFish.append(ingredient) }
                        }

            if ingredient.allergeni.contains(.glutine) { glutenIn.append(ingredient)}
        }
        
        // step 2 -->
        
        var dieteOk:[TipoDieta] = []
        
        if glutenIn.isEmpty {dieteOk.append(.glutenFree)}
        
        if milkIn.isEmpty && animalOrFish.isEmpty {dieteOk.append(contentsOf: [.vegano,.vegariano,.vegetariano])}
        else if milkIn.isEmpty { dieteOk.append(.vegariano)}
        else if animalOrFish.isEmpty {dieteOk.append(.vegetariano)}
        else {dieteOk.append(.standard) }
 
        var dieteOkInStringa:[String] = []
 
        for diet in dieteOk {
            
            let stringDiet = diet.simpleDescription()
            dieteOkInStringa.append(stringDiet)
       
        }
    
        return (dieteOk,dieteOkInStringa)
    }
    
    /// Calcola se la preparazione è a base di carne, pesce, o verdure
    func calcolaBaseDellaPreparazione(readOnlyVM:AccounterVM) -> BasePreparazione {
        
        let allING = self.allIngredientsAttivi(viewModel: readOnlyVM)
        let allInGMapped = allING.map({$0.origine})
        
        guard allInGMapped.contains(.animale) else { return .vegetale }
        
        let allergeneIn = allING.map({$0.allergeni})
        
        for arrAll in allergeneIn {
            
            if arrAll.contains(where: {
                $0 == .pesce ||
                $0 == .molluschi ||
                $0 == .crostacei
            }) { return .pesce }
            else { continue }
        }
    
        return .carne
        
    }
    
    /// ritorna true se tutte le proprietà optional sono state compilate, e dunque il modello è completo.
    func optionalComplete() -> Bool {
        
        self.descrizione != "" &&
        self.mostraDieteCompatibili &&
        !self.ingredientiPrincipali.isEmpty
       
    }
    
    /// Ritorna la media in forma di stringa delle recensioni di un Piatto, e il numero delle stesse come Int, e un array con i modelli delle recensioni
    func ratingInfo(readOnlyViewModel:AccounterVM) -> (media:Double,count:Int,allModelReview:[DishRatingModel]) {
        
        // Nota 13.09

        let allLocalReviews:[DishRatingModel] = readOnlyViewModel.modelCollectionFromCollectionID(collectionId: self.rifReviews, modelPath: \.allMyReviews)
        
        guard !allLocalReviews.isEmpty else {
            
            return (0.0,0,[])
        }
        
        let ratingCount: Int = allLocalReviews.count // item.rating.count
        let mediaPonderata = csCalcoloMediaRecensioni(elementi: allLocalReviews)
 
        return (mediaPonderata,ratingCount,allLocalReviews)
        
    }
    
    /// Torna un valore da usare per ordinare i model nella classifica TopRated. In questo caso torna il peso delle recensioni, ossia la media ponderata per il numero di recensioni
    func topRatedValue(readOnlyVM:AccounterVM) -> Double {
        
        let (media,count,_) = self.ratingInfo(readOnlyViewModel:readOnlyVM)
       
        return (media * Double(count))
     
    }
    
    func estrapolaPrezzoMandatoryMaggiore() -> Double {
        
        guard let labelPrice = self.pricingPiatto.first(where: {$0.type == .mandatory}) else { return 0.0 }
        let price = Double(labelPrice.price) ?? 0.0
        return price
        
    }
    
    public enum BasePreparazione:MyProEnumPack_L0 {

        static var allCase:[BasePreparazione] = [.vegetale,.carne,.pesce]
        
        case vegetale,carne,pesce
        
        func simpleDescription() -> String {
            
            switch self {
            case .vegetale:
                return "Verdure"
            case .carne:
                return "Carne"
            case .pesce:
                return "Pesce"
            }
        }
        
        func returnTypeCase() -> DishModel.BasePreparazione {
           return self
        }

        func orderAndStorageValue() -> Int {
            return 0
        }
        
        func imageAssociate() -> String {
            
            switch self {
            case .vegetale:
                return "🥗"
            case .carne:
                return "🥩"
            case .pesce:
                return "🍤"
            }

        }
    }
    
    public enum PercorsoProdotto:MyProEnumPack_L0,MyProCloudPack_L0 {

        static var allCases:[PercorsoProdotto] = [.preparazioneFood,.preparazioneBeverage,.prodottoFinito]
        
        case prodottoFinito //= "Prodotto Finito"
        case preparazioneFood //= "Piatto" // case standard di default
        case preparazioneBeverage //= "Drink"
        
        func imageAssociated() -> String {
            switch self {
            case .prodottoFinito:
                return "🧃"
            case .preparazioneFood:
                return "fork.knife.circle"
            case .preparazioneBeverage:
                return "wineglass"
                
            }
        }
        
        func simpleDescription() -> String {
            
            switch self {
                
            case .prodottoFinito:
                return "Prodotto Finito"
            case .preparazioneFood:
                return "Piatto"
            case .preparazioneBeverage:
                return "Drink"
                
            }
            
        }
        
        func returnTypeCase() -> DishModel.PercorsoProdotto {
            self
        }
        
        func orderAndStorageValue() -> Int {
            
            switch self {
                
            case .prodottoFinito:
                return 0
            case .preparazioneFood:
                return 1
            case .preparazioneBeverage:
                return 2
                
            }
        }
        
        static func convertiInCase(fromNumber: Int) -> DishModel.PercorsoProdotto {
            
            switch fromNumber {
            case 0: return .prodottoFinito
            case 1: return .preparazioneFood
            case 2: return .preparazioneBeverage
            default: return .preparazioneFood
            }
        }
        
        func extendedDescription() -> String {
            
            switch self {
            case .prodottoFinito:
                return "Trattasi di un prodotto pronto che non richiede altri ingredienti per essere servito"
            default:
                return "E' il frutto della combinazione e/o lavorazione di uno o più ingredienti"
            }
        }
    }
    
} */ // BACKUP 09.12
