//
//  Protocolli.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation
import SwiftUI
//import Firebase

// 14.09 Spazio protocolli MyPro - Nuova generazione
public protocol MyProStarterPack_L0:Identifiable,Equatable,Hashable { // Primo passo per la riorganizzazione dei protocolli. Step by step e per funzioni. L'incipit sarà MyPro seguito dal Pack. ModelPack EnumPack StatusPack per raggruppare le varie funzioni e utilizzi
    
    var id: String { get }
   
}

public protocol MyProStarterPack_L1:MyProStarterPack_L0,MyProVMPack_L0 {
    
    
    
    var id: String { get set } // sovrascrive il livello zero per non crearci problemi con le enum. Dobbiamo chiarire se quei pochi casi in cui sovrasciviamo gli id possono essere risolti diversamente, o altrimenti facciamo un po' di ordine. Proprietà da considerarsi QUI TEMPORANEA
    
    var intestazione: String { get set } // esistono view che richiedono solo questo valore
    
  //  func returnModelTypeName() -> String // deprecata in futuro. inglobata nella viewModelContainerInstance // deprecata 15.09
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<VM,[Self]>, nomeContainer: String, nomeOggetto:String, imageAssociated:String)
   
    
    /// Stessa funzione di viewModelContainer() Solo che abbiamo l'accesso dal type
    static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<VM,[Self]>
}

public protocol MyProDescriptionPack_L0 {

    var descrizione: String { get set }
}

public protocol MyProSearchPack_Sub_0 {
       
   associatedtype SortCondition
}
/// FPM = FilterPropertyModel / SC = SortCondition
public protocol MyProSearchPack_L0:MyProVMPack_L0 {
    
    associatedtype FPM: MyProSearchPack_Sub_0
    
    /// StringResearch per le liste
    func modelStringResearch(string: String,readOnlyVM:VM?) -> Bool
    func modelPropertyCompare(filterProperty:FPM,readOnlyVM:VM) -> Bool
    
    static func sortModelInstance(lhs:Self,rhs:Self,condition:FPM.SortCondition?,readOnlyVM:VM) -> Bool
}





/// SM = StatusModel
public protocol MyProStatusPack_L0 {
    
   // associatedtype SM:Equatable,MyProCloudPack_L0
    
    var status: StatusModel { get set }
    func modelStatusDescription() -> String
}

/// ST = Status Transition / DPV = DestinationPathView
public protocol MyProStatusPack_L1: MyProStatusPack_L0,MyProStarterPack_L1,MyProVMPack_L0 {
    
   // associatedtype ST:Equatable,MyProEnumPack_L0
    associatedtype DPV:Hashable
    
    func pathDestination() -> DPV
    func manageCambioStatus(nuovoStatus:StatusTransition,viewModel:VM)
    func conditionToManageMenuInterattivo_dispoStatusDisabled(viewModel:VM) -> Bool
   
    func conditionToManageMenuInterattivo() -> (disableCustom:Bool,disableStatus:Bool,disableEdit:Bool,disableTrash:Bool,opacizzaAll:CGFloat)
}

/*protocol MyProDestinationPack_L0 {
    func pathDestination() -> DestinationPathView
} */ // Nota 27.09


/// RS = RowSize
public protocol MyProVisualPack_L0:MyProVMPack_L0 {
    
    associatedtype RowView: View
    associatedtype InteractiveMenuContent: View
    associatedtype RS
    
    var id:String { get }
    
    func returnModelRowView(rowSize:RS) -> RowView
    /// Bottoni per il menu Interattivo specifici del modello
    func vbMenuInterattivoModuloCustom(viewModel:VM,navigationPath:ReferenceWritableKeyPath<VM,NavigationPath>) -> InteractiveMenuContent
    
    func conditionToManageMenuInterattivo() -> (disableCustom:Bool,disableStatus:Bool,disableEdit:Bool,disableTrash:Bool,opacizzaAll:CGFloat)
}

public protocol MyProVisualPack_L1: MyProVisualPack_L0,MyProStarterPack_L1 {
    
  
}
// NUOVA FASE DI RIORDINO - 15.09

public protocol MyProEnumPack_L0: MyProOrganizerPack_L0 {
    
    func simpleDescription() -> String
    
}

public protocol MyProEnumPack_L1:MyProEnumPack_L0 {
    
    static var defaultValue: Self { get }
}

public protocol MyProEnumPack_L2: MyProEnumPack_L1,MyProStarterPack_L0 {
    
    func imageAssociated() -> String
    
    func extendedDescription() -> String
}

public protocol MyProOrganizerPack_L0: Hashable {
    
    func returnTypeCase() -> Self
    func orderAndStorageValue() -> Int // Usiamo il numero oltre che a ordinare i case, anche come valore di storage in firebase
}

public protocol MyProManagingPack_L0:MyProVMPack_L0 {
    /// gestisce il delete a livello Model, permettendo di compiere altre operazioni insieme.
    func manageModelDelete(viewModel:VM)
    func conditionToManageMenuInterattivo() -> (disableCustom:Bool,disableStatus:Bool,disableEdit:Bool,disableTrash:Bool,opacizzaAll:CGFloat)
   
}

// fine spazio MyPro

public protocol MyProToolPack_L0:MyProStatusPack_L1,MyProVisualPack_L0 { }

public protocol MyProToolPack_L1:MyProToolPack_L0,MyProSearchPack_L0,MyProManagingPack_L0 { }


/*
/// Gestione upload e download da/per firebase per enum
public protocol MyProCloudPack_L0 {
    /// protocollo per le proprietà, in particolare per le enum, per essere convertite in un valore più facilmente stockabile
    // 14.12 Probabilmente sarà deprecato dall'implementazione di Codable. Tuttavia i metodi definiti potrebbero essere stati utilizzati per altri usi. Verificare ed eventualmente spostarli in altri protocolli
          func orderAndStorageValue() -> Int
   static func convertiInCase(fromNumber:Int) -> Self
} */

/// download dei modelli dal firebase
/*public protocol MyProCloudDownloadPack_L1 {
   
    // Questa è la nostra versione custom del protocollo Decodable. Deprecata 14.12.22. Sostituita appunto da Decodable
    
    associatedtype DataBaseField
    init(frDocID:String,frDoc:[String:Any])
    
}*/
///upload modelli su firebase
/*public protocol MyProCloudUploadPack_L1 {
    
    // Questa è la nostra versione custom del protocollo Encodable. Deprecata 14.12.22. Sostituita appunto da Encodable
    var id: String { get }
    func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String:Any] // Nota 24.11
   
}*/

/*public protocol MyProCloudPack_L1:MyProCloudDownloadPack_L1,MyProCloudUploadPack_L1 {
    // Lo abbiamo splittato in due protocolli, uno per l'upload e uno per il download. Lo abbiamo messo così per gestire la transizione. Se non sarà necessario riaverlo unificato, li usiamo splittati e questo lo eliminiamo
    
    // Questa è la nostra versione custom del protocollo Codable (Encodavle + Decodable). Deprecata 14.12.22. Sostituita appunto da Codable
} */

 public protocol MyProVMPack_L0 {
    
     associatedtype VM:MyProViewModelPack_L1
   
    
}







