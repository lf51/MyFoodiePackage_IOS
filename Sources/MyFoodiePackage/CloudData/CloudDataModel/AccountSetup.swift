//
//  AccountSetup.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/11/22.
//

import Foundation

public struct AccountSetup: Codable {
   
    public var id: String
    public var startCountDownMenuAt:TimeValue

    public var autoPauseDish_byPauseING: ActionValue
    public var autoPauseDish_byArchiveING: ActionValue
    public var autoPauseDish_byDeleteING: ActionValue // 27.11 Non serve -> Vedi Nota 27.11

    public static let autoPauseDish_allCases:[ActionValue] = [.sempre,.mai]
    
  /*  init(id: String, startCountDownMenuAt: TimeValue, autoPauseDish_byPauseING: ActionValue) {
        // Non dovrebbe essere in uso
        self.id = id
        self.startCountDownMenuAt = startCountDownMenuAt
        self.autoPauseDish_byPauseING = mettiInPausaDishByIngredient
    } */
    
    public enum CodingKeys:String,CodingKey {
        
        case id
        case startCountDownMenuAt = "start_countdown"
        case autoPauseDish_byPauseING = "autopausedish_bypause_ing"
        case autoPauseDish_byArchiveING = "autopausedish_byarchive_ing"
        case autoPauseDish_byDeleteING = "autopausedish_bydelete_ing"
    }
    
    public init() {
        
        self.id = "userSetup"
        self.startCountDownMenuAt = .trenta
        self.autoPauseDish_byPauseING = .sempre
        self.autoPauseDish_byDeleteING = .sempre
        self.autoPauseDish_byArchiveING = .sempre
    
    }
    
    // MyProCloudPack_L1
    
  /*  public init(frDocID:String,frDoc: [String:Any]) {
        
        let countDownInt = frDoc[DataBaseField.startCountDownMenuAt] as? Int ?? 0
        let pausaInt = frDoc[DataBaseField.autoPauseDish_byPauseING] as? Int ?? 0
        let byDeleteInt = frDoc[DataBaseField.autoPauseDish_byDeleteING] as? Int ?? 0
        let byArchiveInt = frDoc[DataBaseField.autoPauseDish_byArchiveING] as? Int ?? 0
        
        self.id = frDocID
        self.startCountDownMenuAt = TimeValue.convertiInCase(fromNumber: countDownInt)
        self.autoPauseDish_byPauseING = ActionValue.convertiInCase(fromNumber: pausaInt)
        self.autoPauseDish_byArchiveING = ActionValue.convertiInCase(fromNumber: byArchiveInt)
        self.autoPauseDish_byDeleteING = ActionValue.convertiInCase(fromNumber: byDeleteInt)
        
    }
    
    public func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.startCountDownMenuAt : self.startCountDownMenuAt.orderAndStorageValue(),
            DataBaseField.autoPauseDish_byPauseING : self.autoPauseDish_byPauseING.orderAndStorageValue(),
            DataBaseField.autoPauseDish_byArchiveING : self.autoPauseDish_byArchiveING.orderAndStorageValue(),
            DataBaseField.autoPauseDish_byDeleteING : self.autoPauseDish_byDeleteING.orderAndStorageValue()
            
        ]
        return documentData
    }
    
    public struct DataBaseField {
        
        static let startCountDownMenuAt = "startCountDownValue"
        static let autoPauseDish_byPauseING = "autoPauseDish_byPauseING"
        static let autoPauseDish_byDeleteING = "autoPauseDish_byDeleteING"
        static let autoPauseDish_byArchiveING = "autoPauseDish_byArchiveING"
    } */
    
    //
    
    public enum ActionValue:String,Codable {
        
        static var allCases:[ActionValue] = [.sempre,.mai,.chiedi]
        static var defaultValue:ActionValue = .mai
        
        case sempre
        case mai
        case chiedi
        
        public func orderAndStorageValue() -> Int {
            switch self {
                
            case .mai: return 0
            case .sempre: return 1
            case .chiedi: return 2
            }
        }
        
       /* public static func convertiInCase(fromNumber: Int) -> AccountSetup.ActionValue {
            switch fromNumber {
                
            case 0: return .mai
            case 1: return .sempre
            case 2: return .chiedi
            default: return .defaultValue
            }
        } */
        
    }
    
    public enum TimeValue:Int,Codable {
        //04.07.23 Abbiamo deciso di deprecare la scelta e impostare un unico tempo a 30 minuti. Tenere presente che questo data è utilizzato per il nextCheck del timer nei Menu. E' una scelta senza sensa, per cui uniformia con un valore di 30. Punto. Vedere se c'è nota vocale di spiegazione
       public static var allCases:[TimeValue] = [.quarter,.trenta,.fortyfive,.sixty,.seventyFive,.novanta,.twoHour]
       public static var defaultValue:TimeValue = .trenta
        
        case quarter = 15
        case trenta = 30
        case fortyfive = 45
        case sixty = 60
        case seventyFive = 75
        case novanta = 90
        case twoHour = 120
        
        public func orderAndStorageValue() -> Int {
            switch self {
            case .quarter: return 15
            case .trenta: return 30
            case .fortyfive: return 45
            case .sixty: return 60
            case .seventyFive: return 75
            case .novanta: return 90
            case .twoHour: return 120
            }
        }
        
      /*  public static func convertiInCase(fromNumber: Int) -> AccountSetup.TimeValue {
            switch fromNumber {
                
            case 15: return .quarter
            case 30: return .trenta
            case 45: return .fortyfive
            case 60: return .sixty
            case 75: return .seventyFive
            case 90: return .novanta
            case 120: return .twoHour
                
            default: return .defaultValue
                
            }
        } */
    }
}
