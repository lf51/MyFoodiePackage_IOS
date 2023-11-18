//
//  DishRatingModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/08/22.
//

import Foundation
import SwiftUI
//import Firebase

public struct DishRatingModel: MyProStarterPack_L0,Codable {
    
    public static func == (lhs: DishRatingModel, rhs: DishRatingModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.voto.generale == rhs.voto.generale // da vedere ????
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static public let minLenghtComment:Int = 70
    
    public var id: String
    public let rifPiatto: String
    
    public var intestazione: String?
    public var commento: String?
    public var rifImage: String? // sarà uguale all'id del reviewModel
    
    public var authorID:String?
    public var ownerReply:String? // 16.07.23 da implementare
    
    public var voto: DishRatingModel.RateModel
    public let dataRilascio: Date
    
    public init(idPiatto:String,percorsoProdotto:PercorsoProdotto = .preparazione) {
        
        self.id = UUID().uuidString
        self.rifPiatto = idPiatto

        self.voto = RateModel(percorsoProdotto: percorsoProdotto)
        self.dataRilascio = Date()
        
        
    }
    
    public func rateColor() -> Color {
        
       // guard let vote = Double(self.voto) else { return Color.gray }
        let vote = self.voto.generale
      
        if vote <= 6.0 { return Color.red }
        else if vote <= 8.0 { return Color.orange }
        else if vote <= 9.0 { return Color.yellow }
        else { return Color.green }
        
    }
    
    public func isVoteInRange(min:Double,max:Double) -> Bool {
        
     //  guard let vote = Double(self.voto) else { return false }
        let vote = self.voto.generale
            
        return vote >= min && vote <= max
        
    }

    /// tiriamo fuori un voto e peso (il peso va da 0.01 a 1.0)
    public func pesoRecensione() -> Double {

      //  let theVote = self.voto.generale
        
        // Peso va da 0.01 a 1.00 // Andremo oltre 1.0 grazie alla reputazione dell'utente. Upgrade futuro.
        var completingRate:Double = 0.25
        
        // voto
        // titolo
        // descrizione
        // image
        // Tot: 1.0
                
        if self.intestazione != nil { completingRate += 0.15 }
        else { completingRate -= 0.05 }
        
        if let commento = self.commento {
            
            let countChar = commento.replacingOccurrences(of: " ", with: "").count
            
            if countChar < Self.minLenghtComment { completingRate += 0.2 }
            else { completingRate += 0.3 }
            
          /*  else if countChar > 70,
                    countChar <= 220 {
                completingRate += 0.3
            } // gold range
            
            else if countChar > 220 { completingRate += 0.25 } */
            
        }
        else { completingRate -= 0.095 }
        
        if self.rifImage != nil { completingRate += 0.3 }
        else { completingRate -= 0.095}


        return completingRate
    }
    
    
    public struct RateModel:Codable {
        // da sistemare in chiave salvataggio su firebase. Non serve salvare i pesi che sono praticamente due set(uno per food, uno per drink) uguali per tutte le recensioni
        public var presentazione:Double
        public var cottura:Double
        public var mpQuality:Double
        public var succulenza:Double
        public var gusto:Double

        let pesoPresentazione:Double
        let pesoCottura:Double
        let pesoMpQuality:Double
        let pesoSucculenza:Double
        let pesoGusto:Double
        
        let sommaPesi:Double // la vogliamo sempre uguale a 10
            
      /*  public enum CodingKeys:String,CodingKey {
            
            case presentazione
            case cottura
            case mpQuality = "mp_quality"
            case succulenza
            case gusto
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<DishRatingModel.RateModel.CodingKeys> = try decoder.container(keyedBy: DishRatingModel.RateModel.CodingKeys.self)
            
            self.presentazione = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.presentazione)
            self.cottura = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.cottura)
            self.mpQuality = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.mpQuality)
            self.succulenza = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.succulenza)
            self.gusto = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.gusto)
            
           /* self.pesoPresentazione = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.pesoPresentazione)
            self.pesoCottura = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.pesoCottura)
            self.pesoMpQuality = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.pesoMpQuality)
            self.pesoSucculenza = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.pesoSucculenza)
            self.pesoGusto = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.pesoGusto)
            self.sommaPesi = try container.decode(Double.self, forKey: DishRatingModel.RateModel.CodingKeys.sommaPesi) */
        }
        
        public func encode(to encoder: Encoder) throws {
            var values = encoder.container(keyedBy: CodingKeys.self)
            
            try values.encode(presentazione, forKey: .presentazione)
            try values.encode(cottura, forKey: .cottura)
            try values.encode(mpQuality, forKey: .mpQuality)
            try values.encode(succulenza, forKey: .succulenza)
            try values.encode(gusto, forKey: .gusto)
        } */
        
        
        
        public var generale:Double {
            
            get {
                
               ((presentazione * pesoPresentazione) +
                (cottura * pesoCottura) +
                (mpQuality * pesoMpQuality) +
                (succulenza * pesoSucculenza) +
                (gusto * pesoGusto)) / sommaPesi
                
            }
            
            set {
                
                presentazione = newValue
                cottura = newValue
                mpQuality = newValue
                succulenza = newValue
                gusto = newValue
            }
        }
        
        public init(percorsoProdotto:PercorsoProdotto) {
            
            switch percorsoProdotto {

            case .preparazione:
                
                pesoPresentazione = 1
                pesoCottura = 1
                pesoMpQuality = 3
                pesoSucculenza = 2.5
                pesoGusto = 2.5
            
                
            default:
                
                pesoPresentazione = 1.5
                pesoCottura = 0.0
                pesoMpQuality = 3.0
                pesoSucculenza = 2.75
                pesoGusto = 2.75
            }
            
            self.sommaPesi = 10.0
            
            self.presentazione = 10.0
            self.cottura = 10.0
            self.mpQuality = 10.0
            self.succulenza = 10.0
            self.gusto = 10.0
            
        }
        
       
    }
    
}
/* public struct DishRatingModel: MyProStarterPack_L0,MyProDescriptionPack_L0,Codable {
  
    public let id: String
    public let rifPiatto: String
    /// il voto deve essere un INT ma vine salvato come double : ex 8.0. Quindi nelle trasformazioni lo trattiamo come Double. Da Creare una ghera con i valori selezionabili prestabiliti
    public var voto: String // 01.02.23 Deprecato. Da sostituire con un oggetto specifico, RateModel costruito nella FoodieClient
    public var titolo: String // deve avere un limite di caratteri
    public var commento: String = "" // 30.01.23 Deprecata per sostituzione con - descrizione -
    public var descrizione: String
    public var rifImage: String // 19.10 Togliere le virgolette di default.
    public let dataRilascio: Date // Messo in Var per i test, riportare come let
    
    public init(/*id:String,*/voto: String, titolo: String, commento: String,rifImage:String = "circle",idPiatto: String) {
        
        // Utile solo per i test. Il cliente business non crea recensioni.
        self.id = UUID().uuidString
        
        self.voto = voto
        self.titolo = titolo
        self.commento = commento
        self.descrizione = commento
        self.rifPiatto = idPiatto
        self.rifImage = rifImage
        
        self.dataRilascio = Date()
    }
    
    public init(rifDish:String) {
        
        self.id = UUID().uuidString
        self.rifPiatto = rifDish
        
        self.voto = ""
        self.titolo = ""
        self.descrizione = ""
        self.rifImage = "photo.on.rectangle.angled"
        
        self.dataRilascio = Date()
        
        
    }
    
    // MyProCloudPack_L1
    
    /*public init(frDocID:String,frDoc: [String:Any]) {
        
        self.id = frDocID
        
        self.voto = frDoc[DataBaseField.voto] as? String ?? ""
        self.titolo = frDoc[DataBaseField.titolo] as? String ?? ""
        self.commento = frDoc[DataBaseField.commento] as? String ?? ""
        self.rifPiatto = frDoc[DataBaseField.rifPiatto] as? String ?? ""
        self.image = frDoc[DataBaseField.image] as? String ?? ""
    
        self.dataRilascio = frDoc[DataBaseField.dataRilascio] as? Date ?? .now
    }
    
    public func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.rifPiatto : self.rifPiatto,
            DataBaseField.voto : self.voto,
            DataBaseField.titolo : self.titolo,
            DataBaseField.commento : self.commento,
            DataBaseField.image : self.image,
            DataBaseField.dataRilascio : self.dataRilascio
        
        ]
        
        return documentData
    }
    
    public struct DataBaseField {
        
        static let rifPiatto = "rifPiatto"
        static let voto = "voto"
        static let titolo = "titolo"
        static let commento = "commento"
        static let image = "rifImage"
        static let dataRilascio = "dataRilascio"
        
    } */
    
    public func rateColor() -> Color {
        
        guard let vote = Double(self.voto) else { return Color.gray }
      
        if vote <= 6.0 { return Color.red }
        else if vote <= 8.0 { return Color.orange }
        else if vote <= 9.0 { return Color.yellow }
        else { return Color.green }
        
    }
    
    public func isVoteInRange(min:Double,max:Double) -> Bool {
        
        guard let vote = Double(self.voto) else { return false }
            
        return vote >= min && vote <= max
        
    }

    /// tiriamo fuori un voto e peso (il peso va da 0.1 a 1.05)
    public func votoEPeso() -> (voto:Double,peso:Double) {
        
        let theVote = Double(self.voto) ?? 10.0
        
        // Peso va da 0.1 a 1.05
        var completingRate:Double
        if theVote > 7.4 { completingRate = 0.5 } //(6) min 0.5 max 1.05
        else if theVote > 3.9 { completingRate = 0.25 }//(7) min 0.25 max 0.80
        else { completingRate = 0.2 }//(8) min 0.2 max 0.75
        
        if self.titolo != "" { completingRate += 0.05 }
        if self.rifImage != "" { completingRate += 0.15 }
        if self.commento != "" {
            
            let countChar = self.commento.replacingOccurrences(of: " ", with: "").count
           
            if countChar < 70 { completingRate += 0.2 }
            
            else if countChar > 70 && countChar <= 180 {
                completingRate += 0.35
            } // gold range
            
            else if countChar > 180 && countChar <= 300 { completingRate += 0.30 }
            else if countChar > 300 { completingRate += 0.25 }
            
        }

        return (theVote,completingRate)
    }
    
}*/  // 03.02.23 BackUp
