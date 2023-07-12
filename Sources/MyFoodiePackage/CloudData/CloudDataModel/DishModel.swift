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

    /*
     // 25.06.23 Serirebbe public init(percorso:PercorsoProdotto){ }
     // Ma non lo abbiamo implementato perchè ci da una serie di errori sparsi che non comprendiamo. Abbiamo anche provato a implementarlo nella extensione. Non è essenziale, è solo per fare maggiore ordine
     
     */
    
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
        self.mostraDieteCompatibili = true 
        self.status = .bozza()
        self.pricingPiatto = DishFormat.customInit()
        
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
    public func arePriceEmpty() -> Bool {
        
        for format in self.pricingPiatto {
            
            let price = format.price
            if price != "" { return false }
            else { continue }
        }
        return true 
        
    }
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
    
    /// Controlla l'origine degli ingredienti e restituisce un array con le diete compatibili. Il byPass di default su false, se true byPassa la scelta dell'utente di mostrare o meno le diete e calcola le compatibilità
    public func returnDietAvaible(viewModel:FoodieViewModel,byPassShowCompatibility:Bool = false) -> (inDishTipologia:[TipoDieta],inStringa:[String]) {
        
        // Step 0 -> controlliamo che l'utente abbia scelto o meno di mostrare le diete. In caso negativo mandiamo la dieta standard
        guard self.mostraDieteCompatibili || byPassShowCompatibility else { return ([TipoDieta.standard],[TipoDieta.standard.simpleDescription()])}
        
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
        
        /*  if milkIn.isEmpty && animalOrFish.isEmpty {dieteOk.append(contentsOf: [.vegano,.vegariano,.vegetariano])}
         else if milkIn.isEmpty { dieteOk.append(.vegariano)}
         else if animalOrFish.isEmpty {dieteOk.append(.vegetariano)}
         else {dieteOk.append(.standard) } */ // 25.06 bug dieta vegetariana
        
        // Soluzione bug 25.06
        
        let animalCount = animalOrFish.count
        let milkCount = milkIn.count
        
        if (animalCount + milkCount) == 0 {
            dieteOk.append(contentsOf: [.vegano,.vegariano,.vegetariano])
        }
        else if milkCount == 0 { dieteOk.append(.vegariano) }
        else if (animalCount - milkCount) == 0 { dieteOk.append(.vegetariano) }
       // else { dieteOk.append(.standard) }
        
        else if dieteOk.isEmpty { dieteOk.append(.standard) }
        
        // fine soluzione bug
        
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
       /* let cantBe:Bool = {
            count == 0 ||
            self.ingredientiPrincipali.contains(self.id)
        }() */
        // update 11.07.23
        let canBe:Bool = !self.ingredientiPrincipali.contains(self.id)
        
        return (count,canBe)
    }
  
    /// controlla la presenza di un ingrediente soltanto fra i principali e i secondari
    public func checkIngredientsInPlain(idIngrediente:String) -> Bool {
        
        let all = self.ingredientiPrincipali + self.ingredientiSecondari
        let condition = all.contains(where: {$0 == idIngrediente})
        return condition
    }
    
    /// Ritorna tutti i rif degli ingredienti contenuti nel piatto, senza badare allo status, ritorna i principali, i secondari, e i sostituti
    public func allIngredientsRif() -> [String] {
        
        let allIDSostituti = self.elencoIngredientiOff.values
        let allTheIngredients = self.ingredientiPrincipali + self.ingredientiSecondari + allIDSostituti
        
        return allTheIngredients
    } // 16.03.23 Probabile fonte di bug qualora un ingrediente sostituito torni disponibile il suo sostituto non ci interessa nel monitor di servizio
    
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
        self.mostraDieteCompatibili// &&
        //!self.ingredientiPrincipali.isEmpty
       
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
                return "🥬"
            case .carne:
                return "🐂"
            case .pesce:
                return "🐟"
            }

        }
    }
    
    public enum PercorsoProdotto:MyProEnumPack_L0,Codable {

        public static var allCases:[PercorsoProdotto] = [.preparazioneFood,.preparazioneBeverage,.composizione,.prodottoFinito]
        
        case prodottoFinito //= "Prodotto Finito"
        case preparazioneFood //= "Piatto" // case standard di default
        case preparazioneBeverage //= "Drink"
        case composizione //composizione di piatti e/o ingredienti indicati in forma descrittiva. Es: Tris Caldo:Arancine,panelle,crocket // Nota 23.06.23
        
      /* public func imageAssociated() -> String {
            switch self {
            case .prodottoFinito:
                return "🧃"
            case .preparazioneFood:
                return "fork.knife.circle"
            case .preparazioneBeverage:
                return "wineglass"
            case .composizione:
                return "takeoutbag.and.cup.and.straw"
                
            }
        } */ // deprecata 24.06.23
        
        public func imageAssociated() -> (system:String,color:Color) {
            
            switch self {
            case .prodottoFinito:
                return ("takeoutbag.and.cup.and.straw",Color.gray)
            case .preparazioneFood:
                return ("fork.knife",Color.yellow)
            case .preparazioneBeverage:
                return ("wineglass",Color.orange)
            case .composizione:
                return ("swatchpalette",Color.mint)
                
            }
        }
        
        public func pickerDescription() -> String {
            
            switch self {
            case .prodottoFinito:
                return "di Terzi"
            case .preparazioneFood:
                return "Food"
            case .preparazioneBeverage:
                return "Beverage"
            case .composizione:
                return "Composto"
                
            }
        }
        
        public func simpleDescription() -> String {
            
            switch self {
                
            case .prodottoFinito:
                return "Prodotto di Terzi"
            case .preparazioneFood:
                return "Piatto"
            case .preparazioneBeverage:
                return "Drink"
            case .composizione:
                return "Composizione"
                
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
            case .composizione:
                return 3
                
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
                return "Prodotto pronto acquistato da terzi. Es: CocaCola"
            case .composizione:
                return "Composizione di piatti in porzioni ridotte, ingredienti variabili, ecc... Es: Tagliere di Salumi e Formaggi locali "
            case .preparazioneBeverage:
                return "Combinazione e/o lavorazione in loco di uno o più ingredienti in forma liquida."
            case .preparazioneFood:
                return "Combinazione e/o lavorazione in loco di uno o più ingredienti in forma solida."
                
            }
        }
        
    }
    
}
