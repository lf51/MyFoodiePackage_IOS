//
//  Protocolli.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation
import SwiftUI

// L'incipit sarà MyPro seguito dal Pack. ModelPack EnumPack StatusPack per raggruppare le varie funzioni e utilizzi
public protocol MyProVMPack_L0 { associatedtype VM:FoodieViewModel }

public protocol MyProStarterPack_L0:Identifiable,Equatable,Hashable {
    
    var id:String { get }
}

public protocol MyProStarterPack_L01/*:MyProStarterPack_L0*/ {
    
    var intestazione: String { get set }
}

public protocol MyProStarterPack_L1:MyProVMPack_L0 {
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<VM,[Self]>, nomeContainer: String, nomeOggetto:String, imageAssociated:String)
   
    /// Stessa funzione di viewModelContainer() Solo che abbiamo l'accesso dal type
    static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<VM,[Self]>
    
    /// Metodo custom rispetto all'equatable per stabilire quando due modelli sono uguali
    func isEqual(to rhs:Self) -> Bool // deprecata in futuro

}

/// Lo stato di completezza del modello
public protocol MyProStatusPack_L0 {
    
    var status: StatusModel { get }
    func modelStatusDescription() -> String

}
/// descrizione dello stato generale del modello,completezza transitione o quello che si vuole
public protocol MyProStatusPack_L02:MyProVMPack_L0 {
    
    func visualStatusDescription(viewModel:VM) -> (internalImage:String,internalColor:Color,externalColor:Color,description:String)
}
/// Per una gestione Automatica o semiAutomatica dello status Transition dei modelli, che necessitano o meno di accedere a informazioni tramite viewModel. E' la parte get di due protocolli, uno per il get e uno per il set (L03)
 public protocol MyProTransitionGetPack_L01 {
  
   // var statusTransition:StatusTransition { get }
   // func getStatusTransition() -> StatusTransition
    func getStatusTransition(viewModel:FoodieViewModel?) -> StatusTransition
}
/// Per una gestione semiAutomatica dello status Transition di modelli che richiedono informazioni da reperire tramite viewModel. E' la parte get di due protocolli, uno per il get e uno per il set (L03)
/*public protocol MyProTransitionPack_L02 {
    /// Serve a triangolare il valore del transition. Usiamo salvarlo su firebase come stringa.
  //  var statusCache:Int { get set }
    /// A differenza della computed statusTransition, usiamo un metodo per
    func getStatusTransition(viewModel:FoodieViewModel) -> StatusTransition
}*/

public protocol MyProTransitionSetPack_L02:MyProVMPack_L0 {
    /// Proprietà su cui triangolare il valore tramite firebase.. Usiamo salvarlo su firebase come stringa.
    var statusCache:Int { get set }
    
    func setStatusTransition(to status:StatusTransition,viewModel:VM)
    func generalDisableSetStatusTransition(viewModel:VM) -> Bool
    func validateUpdateStatusTransition(to newStatus:StatusTransition,viewModel:VM) throws
}

/// Implementa una logica per derivare lo Status e/o forzarlo
/*public protocol MyProStatusPack_L1: MyProStatusPack_L0,MyProVMPack_L0 {

    /// Serve a triangolare il valore del transition e viene salvato sul firebase come stringa
    var statusCache:Int { get set }
 
    func getStatusTransition(viewModel:VM) -> StatusTransition
    func setStatusTransition(to status:StatusTransition,viewModel:VM)
  
    func generalDisableSetStatusTransition(viewModel:VM) -> Bool
    
    func validateUpdateStatusTransition(to newStatus:StatusTransition,viewModel:VM) throws

}*/

public protocol MyProNavigationPack_L0 {
    
    associatedtype DPV:Hashable
    func pathDestination() -> DPV
}

public protocol MyProSubCollectionPack {
    
    associatedtype Sub

    func subCollection() -> Sub
    func sortCondition(compare rhs:Self) -> Bool
}

public protocol MyProDescriptionPack_L0 {

    var descrizione: String? { get set }
    
}

public protocol MyProEditingPack_L0:MyProVMPack_L0 {
    
    func disabilitaEditing(viewModel:VM) -> Bool
    
}

public protocol MyProTrashPack_L0:MyProVMPack_L0 {
    
    func manageModelDelete(viewModel:VM)
    func disabilitaTrash(viewModel:VM) -> Bool
}

/// RS = RowSize
public protocol MyProVisualPack_L0:MyProStarterPack_L0,MyProVMPack_L0 {
    
    associatedtype RowView: View
    associatedtype InteractiveMenuContent: View
    associatedtype RS
    
   // var id:String { get }
    
    func returnModelRowView(rowSize:RS) -> RowView
    /// Bottoni per il menu Interattivo specifici del modello
    func vbMenuInterattivoModuloCustom(viewModel:VM,navigationPath:ReferenceWritableKeyPath<VM,NavigationPath>) -> InteractiveMenuContent 
    
    func opacityModelRowView(viewModel:VM) -> CGFloat
    /*func conditionToManageMenuInterattivo(viewModel:VM) -> (disableCustom:Bool,disableStatus:Bool,disableEdit:Bool,disableTrash:Bool,opacizzaAll:CGFloat)*/ // deprecta
}

public protocol MyProOrganizerPack_L0: Hashable {
    
    func returnTypeCase() -> Self
    func orderAndStorageValue() -> Int // Usiamo il numero oltre che a ordinare i case, anche come valore di storage in firebase
}

public protocol MyProProgressBar {
    
    var countProgress:Double { get }
    
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



/*public protocol MyProManagingPack_L0:MyProVMPack_L0 {
    /// gestisce il delete a livello Model, permettendo di compiere altre operazioni insieme.
    func manageModelDelete(viewModel:VM)
   /* func conditionToManageMenuInterattivo(viewModel:VM) -> (disableCustom:Bool,disableStatus:Bool,disableEdit:Bool,disableTrash:Bool,opacizzaAll:CGFloat)*/
   
}*/ // deprecato 11_12_23


