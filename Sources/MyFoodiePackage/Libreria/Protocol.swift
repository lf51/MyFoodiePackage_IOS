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
  //  var status:StatusModel { get set }
    
}

public protocol MyProStarterPack_L1:/*MyProStarterPack_L0,*/MyProVMPack_L0 {
    
   // var id: String { get set } // sovrascrive il livello zero per non crearci problemi con le enum. Dobbiamo chiarire se quei pochi casi in cui sovrasciviamo gli id possono essere risolti diversamente, o altrimenti facciamo un po' di ordine. Proprietà da considerarsi QUI TEMPORANEA
    
  //  var intestazione: String { get set } // esistono view che richiedono solo questo valore

    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<VM,[Self]>, nomeContainer: String, nomeOggetto:String, imageAssociated:String)
   
    
    /// Stessa funzione di viewModelContainer() Solo che abbiamo l'accesso dal type
    static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<VM,[Self]>
    
    /// Metodo custom rispetto all'equatable per stabilire quando due modelli sono uguali
    func isEqual(to rhs:Self) -> Bool // deprecata in futuro

    
}

public protocol MyProStatusPack_L0 {
    
    var status: StatusModel { get set }
    func modelStatusDescription() -> String

}

public protocol MyProSubCollectionPack/*:MyProStarterPack_L1*/ {
    
    associatedtype Sub

    func subCollection() -> Sub
    func sortCondition(compare rhs:Self) -> Bool
}

public protocol MyProDescriptionPack_L0 {

    var descrizione: String? { get set }
    
}

/// ST = Status Transition / DPV = DestinationPathView
public protocol MyProStatusPack_L1: MyProStatusPack_L0,MyProSubCollectionPack,MyProVMPack_L0 {
    
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

public protocol MyProProgressBar {
    
    var countProgress:Double { get }
    
}
