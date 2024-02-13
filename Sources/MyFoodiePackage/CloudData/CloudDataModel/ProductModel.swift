//
//  ProductModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import Foundation
import SwiftUI
import MyFilterPackage

/*
 
 // Tre Tipologie di Prodotti
 1. Classico -> Contiene rif ingredienti principali e/o secondari
 2. Composizione -> Ha con se un ingredientSubModel as Model sottostante
 3. Di terzi -> Ha con se un rif ingrediente collegato e un ingredientSubModel (il prodotto non esiste su firebase ma solo nel viewModel)
 // Sviluppi Futuri:
 4. Sintetizzato come Ingrediente -> Ha SOLO il rif(id) dell'ingrediente da sintetizzare (ingrediente non esiste su firebase ma solo nel viewModel)
 
 // Relazione con Ingredienti:
 • Gli ingredienti non possono essere archiviati se presenti in un prodotto. Quindi escludervi per archiviazione non ha più senso
 
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
        lhs.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        lhs.ingredientiSecondari == rhs.ingredientiSecondari &&
        lhs.offManager == rhs.offManager &&
       // lhs.elencoIngredientiOff == rhs.elencoIngredientiOff &&
       // lhs.idIngredienteDaSostituire == rhs.idIngredienteDaSostituire &&
       // lhs.idSavedSubstitute == rhs.idSavedSubstitute &&
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
    
    public var ingredienteSottostante:IngredientSubModel?
    public var rifIngredienteSottostante:String?
    
    public var offManager:ProductOffManager?
   // public var elencoIngredientiOff: [String:String]? // salvato su Fire solo per mod Temporaneo
   // public var idIngredienteDaSostituire: String? // utile per Mod Permanente
   // public var idSavedSubstitute: String? // utile per Mod Temporaneo && Permanente

    /// Rif della CategoriaMenu
    public var categoriaMenu: String
    public var mostraDieteCompatibili: Bool

   // public var status: StatusModel
    public var statusCache: Int
    public var pricingPiatto:[DishFormat]
    
    public init() {
        
        self.id = UUID().uuidString
        
        self.intestazione = ""

        self.categoriaMenu = CategoriaMenu.defaultValue.id
        self.mostraDieteCompatibili = true
        self.pricingPiatto = DishFormat.customInit()
        
        self.statusCache = 0
        
    }
    
    public init(from ingredient:IngredientModel) {
        
        self.id = UUID().uuidString
        self.intestazione = ingredient.intestazione
        self.descrizione = ingredient.descrizione
      
        self.categoriaMenu = CategoriaMenu.defaultValue.id
        self.mostraDieteCompatibili = true
    
        self.pricingPiatto = DishFormat.customInit()
        self.rifIngredienteSottostante = ingredient.id
        self.ingredienteSottostante = ingredient.values
        self.statusCache = ingredient.statusTransition.orderAndStorageValue()
    }
    
    func creaID(fromValue: String) -> String {
      
      return fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    } // non mi piace
    
}

extension ProductModel {
    /// muta il prodotto salvando l'eventuale valore del sostituto per l'ingrediente da sostituire considerato. Utile per il modulo di cambio temporaneo
   mutating public func prepareForTemporarySubstitution(for ingredientId:String) {
        
       guard var offManager else {
           self.offManager = ProductOffManager()
           return 
       }
       
       /* guard let elencoIngredientiOff else {
            
            let dictionary:[String:String] = [:]
            self.elencoIngredientiOff = dictionary
            
            return
        } */
        
      // guard let value = offManager.elencoIngredientiOff[ingredientId] else { return }
        
      // offManager.idSavedSubstitute = value
       
       offManager.storeValue(for: ingredientId)
       self.offManager = offManager
    
    }
    
    mutating public func prepareForPermanentSubstitution(for ingredientId:String) {
         
        guard var offManager else {
            
            var off = ProductOffManager()
            off.idIngredienteDaSostituire = ingredientId
            self.offManager = off
            return
        }
        
        offManager.storeValue(for: ingredientId)
        offManager.idIngredienteDaSostituire = ingredientId
        self.offManager = offManager
        
        /* self.idIngredienteDaSostituire = ingredientId
        
         guard let elencoIngredientiOff else {
             let dictionary:[String:String] = [:]
             self.elencoIngredientiOff = dictionary
             
             return }
         
         guard let value = elencoIngredientiOff[ingredientId] else { return }
         
         self.idSavedSubstitute = value*/
     
     }
    
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
            self.ingredienteSottostante = IngredientSubModel()//IngredientModel()
            self.rifIngredienteSottostante = nil
           // self.ingredientiPrincipali = nil
           // self.ingredientiSecondari = nil
        case .finito:
           // new
            
            let ingID = UUID().uuidString
            self.rifIngredienteSottostante = ingID
            self.ingredienteSottostante = IngredientSubModel()
            
            
           /*
            // Old
            
            let sottostante = IngredientModel()
            self.ingredienteSottostante = sottostante
            self.rifIngredienteSottostante = sottostante.id
            self.ingredientiPrincipali = nil
            self.ingredientiSecondari = nil*/
        }
        
    }

    public func isDescriptionOk() -> Bool {
        
        guard self.adress == .composizione else { return true }
        
       /* guard let ingredienteSottostante else {
            // throw error
            return false }*/
        
        guard let descrizione else { return false }
        
        return !descrizione.isEmpty
  
    }
    
    /// Per i prodotti finiti in fase di creazione sincronizza il nome con il sottostante
  /* mutating public func syncronizeIntestazione() {
        
       /* if self.adress == .finito {
            self.ingredienteSottostante?.intestazione = self.intestazione
           // self.ingredienteSottostante?.descrizione = self.descrizione
        }*/
    }*/ // deprecata
    
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
       
      /* if adress == .composizione {
           
           self.ingredienteSottostante?.id = UUID().uuidString
       }*/
    
       self.id = UUID().uuidString

    }
    
    public func getSottostante(viewModel:FoodieViewModel) -> (sottostante:IngredientSubModel?,notEditable:Bool) {
        
        switch self.adress {
            
        case .preparazione:
            return (nil,false)
        case .composizione:
            return (ingredienteSottostante,false)
        case .finito:
            
            var lock:Bool
            // Nuovo // idProduct & idIngredient non esistono
            // Modifica // idProduct & idIngredient esistono
            // Nuova da Ingrediente // idProduct non esiste & idIngredient esiste
            if let rifIngredienteSottostante {
                
                let rifExist = viewModel.isTheModelAlreadyExist(modelID: rifIngredienteSottostante, path: \.db.allMyIngredients)
                let productExist = viewModel.isTheModelAlreadyExist(modelID: self.id, path: \.db.allMyDish)
                
                if productExist { lock = false } // modifica
                else if rifExist { lock = true } // crea da ingrediente
                else { lock = false } // nuovo prodotto

            } else {
                return (nil,true)
            }
            
            return (ingredienteSottostante,lock)
          /*  if let ingredienteSottostante { return (ingredienteSottostante,false) }
            
            else if let rifIngredienteSottostante {
               let sottostante = viewModel.modelFromId(id: rifIngredienteSottostante, modelPath: \.db.allMyIngredients)
                return (sottostante,true)
                
            } else { return (nil,false) }*/
        }
        
    }
    
    private func getIngredienteCollegato(viewModel:FoodieViewModel) -> IngredientModel? {
        
        switch self.adress {
            
        case .preparazione:
            return nil
        case .composizione:
            let ing = ingredienteSottostante?.generaEmptyIngredient()
            return ing
        case .finito:
            let asProduct = getIngredienteCollegatoAsProduct(viewModel: viewModel)
            return asProduct

        }
        
    }
    
    public func getIngredienteCollegatoAsProduct(viewModel:FoodieViewModel) -> IngredientModel? {
        
        guard let rifIngredienteSottostante else { return nil } // throw Error
        
        let ing = viewModel.modelFromId(id: rifIngredienteSottostante, modelPath: \.db.allMyIngredients)
        return ing
        
    }
    
    public func getStatoScorteAsProduct(viewModel:FoodieViewModel) -> StatoScorte {
        
        guard let ingCollegato = self.getIngredienteCollegatoAsProduct(viewModel: viewModel) else { return .outOfStock }
        
        let statoScorte = ingCollegato.statusScorte()
        return statoScorte
        
    }
    
 
}

extension ProductModel:Decodable { 
    
    public static let codingInfo:CodingUserInfoKey = CodingUserInfoKey(rawValue: "ProductModel")!
    
    public enum CodingKeys:String,CodingKey {
        
        case id
     
        case intestazione
        case descrizione
        
        case ingredientiPrincipali = "ingredienti_principali"
        case ingredientiSecondari = "ingredienti_secondari"
        case offManager = "ingredienti_off"
        
        case ingredienteSottostante = "ingrediente_sottostante"
        case rifSottostante = "rif_sottostante"
        
       // case idIngredienteDaSostituire = nil
        case categoriaMenu = "categoria_menu"
        case mostraDieteCompatibili = "show_diet"
        case status = "status_cache"
        case pricingPiatto = "pricing"
        
       // case off // test
        
    }
    
    public init(from decoder: Decoder) throws {
        
        let decodingCase = decoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .subCollection
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.rifIngredienteSottostante = nil
        
        switch decodingCase {
            
        case .mainCollection:
            throw URLError(.cannotConnectToHost)
        case .subCollection:
            
            self.intestazione = try container.decode(String.self, forKey: .intestazione)
            self.descrizione = try container.decodeIfPresent(String.self, forKey:.descrizione)
            self.ingredientiPrincipali = try container.decodeIfPresent([String].self, forKey: .ingredientiPrincipali)
            self.ingredientiSecondari = try container.decodeIfPresent([String].self, forKey: .ingredientiSecondari)
            self.ingredienteSottostante = try container.decodeIfPresent(IngredientSubModel.self, forKey: .ingredienteSottostante)
            
            self.offManager = try container.decodeIfPresent(ProductOffManager.self, forKey: .offManager)
            
            self.categoriaMenu = try container.decode(String.self, forKey: .categoriaMenu)
            self.mostraDieteCompatibili = try container.decode(Bool.self, forKey: .mostraDieteCompatibili)
            self.pricingPiatto = try container.decode([DishFormat].self, forKey: .pricingPiatto)
            let statusValue = try container.decode(String.self, forKey: .status)
            self.statusCache = Int(statusValue) ?? 0
            
        case .inbound:
            
            self.intestazione = ""
            self.descrizione = nil
            self.ingredientiPrincipali = nil
            self.ingredientiSecondari = nil
            self.ingredienteSottostante = nil
            self.offManager = nil
            
            self.categoriaMenu = try container.decode(String.self, forKey: .categoriaMenu)
            self.mostraDieteCompatibili = try container.decode(Bool.self, forKey: .mostraDieteCompatibili)
            self.pricingPiatto = try container.decode([DishFormat].self, forKey: .pricingPiatto)
            self.statusCache = 0
        }
        
    
    }
}

extension ProductModel:Encodable { 
    
    public func encode(to encoder: Encoder) throws {
        
        let codingCase = encoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .subCollection
        
        var container = encoder.container(keyedBy: CodingKeys.self)
      
        switch codingCase {
            
        case .mainCollection:
            throw URLError(.cannotConnectToHost)
            
        case .subCollection:
     
            try container.encode(self.id, forKey: .id)
            
            try container.encode(self.intestazione, forKey: .intestazione)
            try container.encodeIfPresent(self.descrizione, forKey: .descrizione)
            try container.encodeIfPresent(self.ingredientiPrincipali, forKey: .ingredientiPrincipali)
            try container.encodeIfPresent(self.ingredientiSecondari, forKey: .ingredientiSecondari)
            try container.encodeIfPresent(self.ingredienteSottostante, forKey: .ingredienteSottostante)
            try container.encodeIfPresent(self.offManager, forKey: .offManager)
            
            try container.encode(self.categoriaMenu, forKey: .categoriaMenu)
            try container.encode(self.mostraDieteCompatibili, forKey: .mostraDieteCompatibili)
          
            try container.encode(self.pricingPiatto, forKey: .pricingPiatto)
            
            let statusValue = String(self.statusCache)
            try container.encode(statusValue, forKey: .status)
            
        case .inbound:
            
            try container.encode(self.id, forKey: .id)
            
            try container.encode(self.categoriaMenu, forKey: .categoriaMenu)
            try container.encode(self.mostraDieteCompatibili, forKey: .mostraDieteCompatibili)
            try container.encode(self.pricingPiatto, forKey: .pricingPiatto)
        }
        
        
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
    
    /// 07.02.24 Evoluzione da allIngredientsAttivi. Ci restituisce tutti gli ingredienti disponibili, e tutti gli ingredienti in pausa (rimpiazzandoli dove presente con il sostituto, qualora quest'ultima sia a sua volta disponibile).
    public func allIngredientsOrSubs(viewModel:FoodieViewModel) -> [IngredientModel] {
        
        let allIngIn = allIngredientsIn(viewModel: viewModel)
        
        guard self.adress == .preparazione else { return allIngIn }
        // preparazioni
        
        guard let offManager,
              !offManager.elencoIngredientiOff.isEmpty else { return allIngIn }
        
        let allInPausa = allIngIn.filter({
            $0.statusTransition == .inPausa
            })
        
        var allInPausaId = allInPausa.map({$0.id})
        let idIngredienteDaSostituire = offManager.idIngredienteDaSostituire
        
        if idIngredienteDaSostituire != nil {
            
            if !allInPausaId.contains(idIngredienteDaSostituire!) {
                allInPausaId.append(idIngredienteDaSostituire!)
            }
        }
        
        //
        
        var allActiveIDs = allIngIn.map({$0.id})
        
        for ingredient in allInPausaId {
            
            let position = allActiveIDs.firstIndex{$0 == ingredient}
            
            if let sostituto = offManager.fetchSubstitute(for: ingredient) {

                let modelSostituo = viewModel.modelFromId(id: sostituto, modelPath: \.db.allMyIngredients)
                let isActive = modelSostituo?.statusTransition == .disponibile
                
                if isActive {
                    allActiveIDs[position!] = sostituto
                } //else { allActiveIDs.remove(at: position!)}
                
            } //else { allActiveIDs.remove(at: position!)}
            
        }
        
        let allActiveModels = viewModel.modelCollectionFromCollectionID(collectionId: allActiveIDs, modelPath: \.db.allMyIngredients)
        
        return allActiveModels
        
    }
    
    
    /// Updated 03.02.24  ritorna gli ingredienti Attivi (disponibili) escludendo gli ingredienti in pausa ma considerando eventuali sostituti qualora presenti e disponibili. In caso di pf e composizio ritorna un array contenente il sottostante
    /*public func allIngredientsAttivi(viewModel:FoodieViewModel) -> [IngredientModel] {
        // Possibile deprecazione 07.02.24
        let sottostante = self.getIngredienteCollegato(viewModel: viewModel)
        
        guard sottostante == nil else {
            // prodotti finiti & composizione
            if sottostante!.statusTransition == .disponibile { return [sottostante!] }
            else { return [] }
            
        }
        // preparazione
        let allIngIn = allIngredientsIn(viewModel: viewModel)

        guard let offManager else {
            
            return allIngIn.filter({
              $0.statusTransition == .disponibile
          })
        }
        
        let allInPausa = allIngIn.filter({
            $0.statusTransition == .inPausa
            })
        
        var allInPausaId = allInPausa.map({$0.id})
        let idIngredienteDaSostituire = offManager.idIngredienteDaSostituire
        
        if idIngredienteDaSostituire != nil {
            
            if !allInPausaId.contains(idIngredienteDaSostituire!) {
                allInPausaId.append(idIngredienteDaSostituire!)
            }
        }
        
        guard !offManager.elencoIngredientiOff.isEmpty else {
            
            return allIngIn.filter({
              $0.statusTransition == .disponibile //&&
             // $0.id != idIngredienteDaSostituire
          })
        }

        var allActiveIDs = allIngIn.map({$0.id})
        
        for ingredient in allInPausaId {
            
            let position = allActiveIDs.firstIndex{$0 == ingredient}
            
            if let sostituto = offManager.fetchSubstitute(for: ingredient) {

                let modelSostituo = viewModel.modelFromId(id: sostituto, modelPath: \.db.allMyIngredients)
                let isActive = modelSostituo?.statusTransition == .disponibile
                
                if isActive {
                    allActiveIDs[position!] = sostituto
                } else { allActiveIDs.remove(at: position!)}
                
            } else { allActiveIDs.remove(at: position!)}
            
        }
        
        let allActiveModels = viewModel.modelCollectionFromCollectionID(collectionId: allActiveIDs, modelPath: \.db.allMyIngredients)
        
        return allActiveModels
    }*/ // deprecata 08.02.24
    
    /// Updated 03.02.24 Ritorna tutti gli ingredienti, principali e secondari, a prescindere dal loro status. Non considera il sottostante dei pf e delle composizioni. Da verificare
    public func allIngredientsIn(viewModel:FoodieViewModel) -> [IngredientModel] {
        
        let collegato = self.getIngredienteCollegato(viewModel: viewModel)
        
        guard collegato == nil else { return [collegato!] }
        // preparazione
        let ingredientiPrincipali = self.ingredientiPrincipali ?? []
        let ingredientiSecondari = self.ingredientiSecondari ?? []
        
        let allIngredientsID = ingredientiPrincipali + ingredientiSecondari
        
        guard !allIngredientsID.isEmpty else { return [] }
        
        let allTheIngredients = viewModel.modelCollectionFromCollectionID(collectionId: allIngredientsID, modelPath: \.db.allMyIngredients)
        
       /* let allMinusBozzeEArchiviati = allTheIngredients.filter({
           // !$0.status.checkStatusTransition(check: .archiviato)
            $0.statusTransition != .archiviato
        }) */
        
       // return allMinusBozzeEArchiviati
        return allTheIngredients // 03_02_24 Update_ Non vi possono più essere ingredienti archiviati nel prodotto
        
    }
    
    /// cerca corrispondenza delle chiavi sostituite negli array ingredienti Principali e Secondari, e in caso di assenza cancella la key portandola su nil
  /* mutating public func autoCleanElencoIngredientiOff() {
       
       guard let elencoIngredientiOff = self.elencoIngredientiOff else { return }
       
       let allKey = elencoIngredientiOff.keys
       guard !allKey.isEmpty else { return }
       
       let ingredientiPrincipali = self.ingredientiPrincipali ?? []
       let ingredientiSecondari = self.ingredientiSecondari ?? []
       
        for key in allKey {
            
            if ingredientiPrincipali.contains(key) || ingredientiSecondari.contains(key) { continue }
            else { self.elencoIngredientiOff?[key] = nil }
        }
        
    } */ // not used at 02_02_24
    
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
        
        let elencoIngredientiOff = self.offManager?.elencoIngredientiOff ?? [:]
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
    
    /// Updated 03.02.24 controlla se un ingrediente ha un sostituto nell'offManager
    public func checkIngredientHasSubstitute(idIngrediente:String) -> Bool {
        
        guard let offManager else { return false}
        
        if let _ = offManager.fetchSubstitute(for: idIngrediente) { return true }
        else { return false }
    
        
        /*let allSostituiti = offManager.elencoIngredientiOff.keys
        let condition = allSostituiti.contains(where: {$0 == idIngrediente})
        return condition*/
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
    public func preCallHasAllIngredientSameQuality<T:MyProEnumPack_L0>(viewModel:FoodieViewModel,kpQuality:KeyPath<IngredientModel,T>,quality:T?,tipologiaFiltro:TipologiaFiltro) -> Bool {
        
        guard let unwrapQuality = quality else { return true }
        
        let condition = self.hasAllIngredientSameQuality(viewModel: viewModel, kpQuality: kpQuality, quality: unwrapQuality)
        
        return tipologiaFiltro.normalizeBoolValue(value: condition)
        
    }
    
    public func hasAllIngredientSameQuality<T:MyProEnumPack_L0>(viewModel:FoodieViewModel,kpQuality:KeyPath<IngredientModel,T>,quality:T) -> Bool {
        
       // let allIngredient = self.allIngredientsAttivi(viewModel: viewModel)
        let allIngredient = self.allIngredientsOrSubs(viewModel: viewModel)
        
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
        
       // let allIngredient = self.allIngredientsAttivi(viewModel: viewModel)
        let allIngredient = self.allIngredientsOrSubs(viewModel: viewModel)
        
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
               //let allModelIngredients = self.allIngredientsAttivi(viewModel: viewModel)
                let allModelIngredients = self.allIngredientsOrSubs(viewModel: viewModel)
                return returnDiet(throw: allModelIngredients)
            }
           /* if let throwSottostante = self.ingredienteSottostante {
                return returnDiet(throw: throwSottostante)
            } else {
               let allModelIngredients = self.allIngredientsAttivi(viewModel: viewModel)
               return returnDiet(throw: allModelIngredients)
            } */
    
    }
    
    private func returnDiet(throw singleIngredient:IngredientSubModel) -> (inDishTipologia:[TipoDieta],inStringa:[String]) {
        
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
        let animalOrFish: [IngredientModel] = allModelIngredients.filter({$0.values.origine.returnTypeCase() == .animale})
        
        let milkIn: [IngredientModel] = allModelIngredients.filter({
            
            if let allergeniIn = $0.values.allergeni {
                return allergeniIn.contains(.latte_e_derivati)
            } else { return false }
            
            //  $0.allergeni.contains(.latte_e_derivati)
            
        })
        
        let glutenIn: [IngredientModel] = allModelIngredients.filter({
            // $0.allergeni.contains(.glutine)
            if let allergeniIn = $0.values.allergeni {
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
        
       //let allING = self.allIngredientsAttivi(viewModel: readOnlyVM)
       let allING = self.allIngredientsOrSubs(viewModel: readOnlyVM)
       let allInGMapped = allING.map({$0.values.origine})
        
        guard allInGMapped.contains(.animale) else { return .vegetale }
        
       // let allergeneIn = allING.map({$0.allergeni})
       let allergeneIn = allING.compactMap({$0.values.allergeni})
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
       
        // let allIngredients = self.allIngredientsAttivi(viewModel: viewModel)
         let allIngredients = self.allIngredientsOrSubs(viewModel: viewModel)
         var allergeniPiatto:[AllergeniIngrediente] = []
         
              for ingredient in allIngredients {
                  
                  let allergeneIngre:[AllergeniIngrediente] = ingredient.values.allergeni ?? []
                  allergeniPiatto.append(contentsOf: allergeneIngre)
              }

             let setAllergeniPiatto = Set(allergeniPiatto)
             let orderedAllergeni = Array(setAllergeniPiatto).sorted { $0.simpleDescription() < $1.simpleDescription() }
         
             return orderedAllergeni
     
      }
}
