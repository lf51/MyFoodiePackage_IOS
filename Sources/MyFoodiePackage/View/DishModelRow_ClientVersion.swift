//
//  SwiftUIView.swift
//  
//
//  Created by Calogero Friscia on 28/12/22.
//

import SwiftUI
import MyPackView_L0


public struct DishModelRow_ClientVersion: View {
    
    @EnvironmentObject var viewModel:FoodieViewModel
    
    let item: DishModel
    let backgroundView:Color
    private let isItemIbrido:Bool
    
    @State private var openInfo:Bool = false
    
    public init(item: DishModel, backgroundView: Color) {
        
        self.isItemIbrido = {
            item.ingredientiPrincipali.contains(item.id)
        }()
        
        self.item = item
        self.backgroundView = backgroundView
    }
 
   public var body: some View {
       
       CSZStackVB_OpenFrame {

           VStack(alignment: .leading) {
    
               HStack {
                   
                   VStack(alignment:.leading) {
                       
                       vbFirstLine()
                       vbSecondLine()
                   }
                   
                   vbPriceSpace()
                       .padding(.horizontal,10)
                       .background {
                           Color.seaTurtle_1.cornerRadius(5.0)
                       }
                   
               }
           
              vbBadgeRow()
              vbPrincipalIngredientRow()
               
               vbAllergeniLine()
               
               HStack {
                   
                   vbConservazioneLine()
                   Spacer()
                   
                   Button {
                       withAnimation(.easeIn(duration: 0.5)) {
                           self.openInfo.toggle()
                      }
                   } label: {
                       
                       let sign = self.openInfo ? "up" : "down"
                       
                       Image(systemName: "chevron.\(sign).circle.fill")
                           .imageScale(.medium)
                           .foregroundColor(self.openInfo ? .seaTurtle_4 : .seaTurtle_2)
                   }
               }
              
               if self.openInfo {
                   
                   vbDishHistory()
               }
    
           }
           .padding(.horizontal,10)
           .padding(.vertical,5)
           
           
       }
       
       
    }
    
    @ViewBuilder private func vbAllergeniLine() -> some View {
        
        let allergeni = self.item.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
        
        let stringAllergeni = allergeni.map({$0.intestazione})
        let isEmpty = allergeni.isEmpty
    
            Text("*")
                .foregroundColor(Color.white)
            +
            Text(isEmpty ? "Non contiene allergeni" : "Contiene: ")
                .italic(isEmpty)
                .bold(!isEmpty)
                .font(.caption2)
            +
            Text(stringAllergeni,format: .list(type: .and))
                .italic()
                .fontWeight(.semibold)
                .font(.caption2)
                .foregroundColor(Color.black.opacity(0.8))

    }
    
    @ViewBuilder private func vbConservazioneLine() -> some View {
        
        let isThereSurgelati = self.item.hasSomeIngredientASpecificQuality(viewModel: self.viewModel, kpQuality: \.conservazione, quality: .surgelato)
        let isThereCongelati = self.item.hasSomeIngredientASpecificQuality(viewModel: self.viewModel, kpQuality: \.conservazione, quality: .congelato)
        
        // Se l'ingrediente viene salvato di defult come Altro, allora invece di cercarle singolarmente possiamo ricercare per esclusione
        
        let valueSintesi = isThereCongelati || isThereSurgelati
        
        if valueSintesi {
            
            Text("*")
                .foregroundColor(Color.white.opacity(0.6))
            +
            Text("Può contenere ingredienti congelati e/o surgelati")
                .italic()
                .font(.caption2)
                .fontWeight(.light)
                .foregroundColor(Color.black)
            
        } else {
            EmptyView()
        }
        
    }
    
    
    @ViewBuilder private func vbDishHistory() -> some View {
        
        // 1. Prendiamo gli ingredienti secondari e li trasformiamo nella Sintesi
        let allFilteredIngredients = self.item.allMinusArchiviati(viewModel: self.viewModel)
        let allSintesys:[IngredientModelInSintesi] = allFilteredIngredients.map({self.sintetizzaIngredienteTitolare(ingredient: $0)})
        let allSintesysSecondary:[IngredientModelInSintesi] = allSintesys.filter({!$0.isPrincipal})
        
        // 2. Controlliamo se la descrizione del piatto li contiene tutti
        
        let mapByName:[String] = allSintesysSecondary.map({$0.intestazione})
        
        let areAllMentioned:Bool = {
           
            guard !mapByName.isEmpty else { return false }
            
            let description = self.item.descrizione.lowercased()
            
            for ing in mapByName {
                
                let lowIng = ing.lowercased()
                
                if description.contains(lowIng) { continue }
                else { return false }
            }
            return true
        }()
        

        // 3. Distinguiamo i due casi
       // if areAllMentioned {
            // 3.1 Se sono tutti menzionati mostriamo solo la descrizione con gli ing in grassetto
            
          /*  descriptionWithIngMentions(ing: allSintesysSecondary) {
                
                Text("Altri ingredienti usati nella preparazione: (in grassetto nel testo)\nStoria del piatto:\n")
                    .font(.footnote)
                    .fontWidth(.condensed)
                    .foregroundColor(Color.black)
                
            }.multilineTextAlignment(.leading) */
            
            
       // } else {
            // 3.2 Se non sono menzionati tutti, mostriamo la descrizione più l'elenco dei secondari
            
          //  VStack {
                
            self.combinaIngredienti(ing: allSintesysSecondary,areAllMentioned: areAllMentioned) {
                    
                Text("Altri ingredienti usati nella preparazione:")
                        .font(.footnote)
                        .fontWidth(.condensed)
                        .foregroundColor(Color.black)
                    
                }.multilineTextAlignment(.leading)
                
          //  Divider()
            
            self.descriptionWithIngMentions(ing: allSintesysSecondary) {
                
                Text("Storia del piatto:")
                    .font(.footnote)
                    .fontWidth(.condensed)
                    .foregroundColor(Color.black)
                
            }.multilineTextAlignment(.leading)
            
            
            
           /* VStack(alignment:.leading) {
                Text("Storia del piatto:")
                    .font(.footnote)
                    .fontWidth(.condensed)
                    .foregroundColor(Color.black)
                
                Text(self.item.descrizione)
                        .italic()
                        .font(.caption)
                        .foregroundColor(.seaTurtle_4)
            } */
                
            
            
            
            
         //   }
            
           // Text("Descrizione Plus Elento")
            
            
      //  }
        
    
        
        
        
    }
    
    
    
    
    @ViewBuilder private func vbFirstLine() -> some View {

        HStack(alignment:.bottom) {
            
            Text(self.item.intestazione)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .allowsTightening(true)
               
                .foregroundColor(.seaTurtle_4)
              //  .fixedSize()
            
            Spacer()
            
          //  vbEstrapolaStatusImage(itemModel: self.item)
            
        }
                
        
    }
    
    @ViewBuilder private func vbSecondLine() -> some View {
        
            if !isItemIbrido {
                
                vbReviewLine()
                
            } else {
                
                Text(self.item.percorsoProdotto.simpleDescription().lowercased())
                    .italic()
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.seaTurtle_2)
            }

    }
    
    @ViewBuilder private func vbPriceSpace() -> some View {
           
        let (price,count) = csIterateDishPricing()
        // add 21.09
        let moneyCode = Locale.current.currency?.identifier ?? "EUR"
        let priceDouble = Double(price) ?? 0
        
        HStack(alignment:.top,spacing:1) {
      
            Text("\(priceDouble,format: .currency(code: moneyCode))")
               // .fontWeight(.bold)
                .font(.title2)
                .foregroundColor(.seaTurtle_4)
            
            Text("+\(count)")
                .fontWeight(.bold)
                .font(.caption2)
                .foregroundColor(.seaTurtle_3)
        }
        
    }
    
    @ViewBuilder private func vbReviewLine() -> some View {
        
        let (mediaRating,ratingCount) = (9.5,18)
    
        HStack(spacing:3) {
            Text("\(mediaRating,specifier: "%.1f")") // media
                .fontWeight(.light)
                .foregroundColor(.seaTurtle_1)
                .padding(.horizontal,5)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.seaTurtle_2)
                )

            Group {
                Text("/")
                Text("\(ratingCount) recensioni") // valore da importare
                    .italic()
            }
            .fontWeight(.semibold)
            .foregroundColor(.seaTurtle_2)
        }

    }
    
    @ViewBuilder private func vbBadgeRow() -> some View {
        
        let areAllBio = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.produzione, quality: .biologico)
        let areAllLocal = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.provenienza, quality: .km0)
        let areAllItalian = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.provenienza, quality: .italia)
    
        let isDelGiorno = self.viewModel.checkMenuDiSistemaContainDish(idPiatto: self.item.id, menuDiSistema: .delGiorno)
        let isAdviceByTheChef = self.viewModel.checkMenuDiSistemaContainDish(idPiatto: self.item.id, menuDiSistema: .delloChef)

      //  let isIbrido = self.isItemIbrido
        
        HStack {
  
          //  ScrollView(.horizontal,showsIndicators: false){
                
                HStack {
                    
                    if areAllBio {
                        
                        CSEtichetta(
                            text: "BIO",
                            textColor: .seaTurtle_1,
                            image: "💯",
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: Color.green,
                            backgroundOpacity: 1.0)
              
                    }
                
                  //  if !isIbrido {
                        
                        if areAllItalian {
                            
                            CSEtichetta(
                                text: "🇮🇹",
                                fontStyle: .subheadline,
                                textColor: Color.white,
                                image: "💯",
                                imageColor: nil,
                                imageSize: .large,
                                backgroundColor: Color.white.opacity(0.5),
                                backgroundOpacity: 1.0)
                        }
                        
                        if areAllLocal {
                            
                            CSEtichetta(
                                text: "locale",
                                textColor: Color.white,
                                image: "💯",
                                imageColor: nil,
                                imageSize: .large,
                                backgroundColor: Color.yellow.opacity(0.5),
                                backgroundOpacity: 1.0)
                        }
              //      }
                    
                    if isDelGiorno {
                        
                        CSEtichetta(
                            text: "del Giorno",
                            textColor: Color.white,
                            image: "fork.knife.circle.fill",
                            imageColor: Color.yellow,
                            imageSize: .medium,
                            backgroundColor: Color.pink,
                            backgroundOpacity: 0.5)
                    }

                    if isAdviceByTheChef {
                        
                        CSEtichetta(
                            text: "dello Chef",
                            textColor: Color.white,
                            image: "👨🏻‍🍳", //"🗣️", // person.wave.2
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: Color.purple,
                            backgroundOpacity: 0.7)
                    }
                    
                }
                
        //    }

        }
    }
    
    private func csIterateDishPricing() -> (price:String,count:String) {
        
        var mandatoryPrice:String = "0.00"
        let pricingCount = self.item.pricingPiatto.count
        let normalizedCount = pricingCount > 0 ? (pricingCount - 1) : pricingCount
        let stringCount:String = String(normalizedCount)
        
        guard !self.item.pricingPiatto.isEmpty else {
          
            return (mandatoryPrice,stringCount)
        }
            
            for format in self.item.pricingPiatto {
                
                if format.type == .mandatory {
                    mandatoryPrice = format.price
                    break
                }
               
            }

            return (mandatoryPrice,stringCount)
            
    }
    
    /// Crea un array di Ingredienti in Sintesi, filtra i principali, e ritorna una view che li descrive
    /// - Returns: Text
    @ViewBuilder private func vbPrincipalIngredientRow() -> some View {
 
        let allFilteredIngredients = self.item.allMinusArchiviati(viewModel: self.viewModel)
        let allSintesys:[IngredientModelInSintesi] = allFilteredIngredients.map({self.sintetizzaIngredienteTitolare(ingredient: $0)})
        let allSintesysPrincipal:[IngredientModelInSintesi] = allSintesys.filter({$0.isPrincipal})
      
        combinaIngredienti(ing:allSintesysPrincipal) {
            Text(
                 Image(
                     systemName:"list.bullet.rectangle")
                 ).foregroundColor(.seaTurtle_2)
        }
            .multilineTextAlignment(.leading)
                
    }
    
    /// Mappa un array di Ingredienti in Sintesi in un array di Text
    /// - Parameter ing: ingredienti in sintesi
    /// - Parameter areAllMentioned: Solo per i secondari. Indicare se gli ingredienti sono tutti menzionati nel testo della descrizione
    /// - Parameter textIniziale: Il testo di incipit. Può anche essere un Text contenente una immagine
    /// - Returns: Text
    private func combinaIngredienti(ing:[IngredientModelInSintesi],areAllMentioned:Bool = false,textIniziale:() -> Text) -> some View {
        
        let texts:[Text] = {
         
            if ing.isEmpty {
                
                let emptyText = Text("(nessuno)")
                   // .italic()
                    .font(.caption)
                    .foregroundColor(.seaTurtle_2)
                
                return [emptyText]
            }
            else if areAllMentioned {
                
                let emptyText = Text("(in grassetto nel testo)")
                 //   .italic()
                    .font(.caption)
                    .foregroundColor(.seaTurtle_2)
                
                return [emptyText]
                
            }
            else {
               return ing.map{textMapIngMain(ing: $0)}
            }
            
        }()
        
        return combinaTestoIng(textList: texts,textIniziale: textIniziale)
        
    }
    
    /// Combina un array di Text (stilizzati diversamente)in un unico Text
    /// - Parameter textList: [Text]
    /// - Returns: Text
    private func combinaTestoIng(textList:[Text],textIniziale:() -> Text) -> Text {
        
       /* let initialText:Text = Text(
            Image(
                systemName:"list.bullet.rectangle")
            ).foregroundColor(.seaTurtle_2) */
        let initialText:Text = textIniziale()
        
        let testoComposto:Text = textList.reduce(initialText) { partialResult, text in
            
          //  if textList.isEmpty {
                
                return partialResult
                 +
                 Text(partialResult == initialText ? " " : ", ")
                    .foregroundColor(Color.white)
                 +
                 text
                
           /* }  else {
                
                return partialResult
                 +
                 Text(" ")
                 +
                 Text("Lista Ingredienti Vuota")
                     .italic()
                     .font(.subheadline)
                     .foregroundColor(.seaTurtle_2)
                
            } */
        }
        
        return testoComposto
        
    }
    
    /// Crea un ingrediente in sintesi dal sostituto (qualora esista) dell'ingrediente titolare
    /// - Parameter ing: ingrediente Titolare
    /// - Returns: Text combinato del titolare + il sostituto
    private func textMapIngMain(ing:IngredientModelInSintesi) -> Text {
        
        var sintesiSostituto:IngredientModelInSintesi? = nil
        
        if let idSostituto = ing.idSostituto,
           ing.isTemporaryOff {
            
            if let modelSostituto = self.viewModel.modelFromId(id: idSostituto, modelPath: \.allMyIngredients),
               modelSostituto.status.checkStatusTransition(check: .disponibile){
                
                let hasAllergene = !modelSostituto.allergeni.isEmpty
                let isItBio = modelSostituto.produzione == .biologico
                let isFreeze = modelSostituto.conservazione == .congelato || modelSostituto.conservazione == .surgelato

                sintesiSostituto = IngredientModelInSintesi(
                    intestazione: modelSostituto.intestazione,
                    isPrincipal: ing.isPrincipal, // lo eredita dall'eventuale Sostituito
                    isTemporaryOff: false,
                    isBio: isItBio,
                    hasAllergene: hasAllergene,
                    isFreeze: isFreeze,
                    idSostituto: nil)
                
            }
        }
        
       return textMapIngSub(ingSintesi: ing) + textMapIngSub(ingSintesi: sintesiSostituto,isASubstitute: true)
        
    }
    
    /// Crea l'elemento Text di un ingrediente
    /// - Parameters:
    ///   - ingSintesi: ingrediente da stilizzare
    ///   - isASubstitute: Passare true se si tratta di un sostituto
    /// - Returns: Text
    private func textMapIngSub(
        ingSintesi:IngredientModelInSintesi?,
        isASubstitute:Bool = false) -> Text {
        
        guard let ing = ingSintesi else { return Text("")}
        
        let show:(hasAllergene:Bool,isFreeze:Bool,isBio:Bool) = {
            
            guard !ing.isTemporaryOff else { return (false,false,false)}
            
            return (ing.hasAllergene,ing.isFreeze,ing.isBio)
            
        }()
            
        let font:(intestazione:Font,isBio:Font.TextStyle) = {
                
            if ing.isPrincipal { return (Font.subheadline,.caption2) }
            else { return (Font.caption,.caption2) }
        
        }()
        
      return
        Text(isASubstitute ? " (" : "")
            .bold()
            .foregroundColor(.seaTurtle_3)
        +
        Text(ing.intestazione)
            .font(font.intestazione)
            .foregroundColor(ing.isTemporaryOff ? .seaTurtle_1 : .seaTurtle_4)
            .strikethrough(ing.isTemporaryOff, color: .seaTurtle_3)
       +
        Text(show.hasAllergene ? "*" : "")
            .foregroundColor(Color.white)
        
       +
        Text(show.isFreeze ? "*" : "")
            .foregroundColor(Color.white.opacity(0.6))
       +
        Text(show.isBio ? "(bio)" : "")
            .font(.system(font.isBio ,design: .monospaced, weight: .semibold))
            .foregroundColor(Color.green)
        +
        Text(isASubstitute ? ")" : "")
            .bold()
            .foregroundColor(.seaTurtle_3)

    }
    
    /// Crea un ingrediente in Sintesi da un Ingrediente Titolare
    /// - Parameter ingredient: ingrediente Titolare
    /// - Returns: Ingrediente in Sintesi
    private func sintetizzaIngredienteTitolare(ingredient:IngredientModel) -> IngredientModelInSintesi {
        
        let allTemporaryOff = self.item.elencoIngredientiOff
        
        let isPrincipal = self.item.ingredientiPrincipali.contains(ingredient.id)
        let hasAllergene = !ingredient.allergeni.isEmpty
        let isItBio = ingredient.produzione == .biologico
        let isFreeze = ingredient.conservazione == .congelato || ingredient.conservazione == .surgelato
   
        var isOff: Bool = false
        
        if self.item.idIngredienteDaSostituire == ingredient.id {isOff = true}
        else { isOff = ingredient.status.checkStatusTransition(check: .inPausa) }

        var idSostituto: String? = nil

        if isOff {
            
            for (key,value) in allTemporaryOff {
                
                if ingredient.id == key {
                    
                    let isAlreadyIn = self.item.checkIngredientsInPlain(idIngrediente: value)
                    idSostituto = isAlreadyIn ? nil : value
                    break
                }
                
            }
        }
        
        let ingSintesi = IngredientModelInSintesi(
            intestazione: ingredient.intestazione,
            isPrincipal: isPrincipal,
            isTemporaryOff: isOff,
            isBio: isItBio,
            hasAllergene: hasAllergene,
            isFreeze: isFreeze,
            idSostituto: idSostituto)
        
        return ingSintesi
   
    }
    
     private func descriptionWithIngMentions(ing:[IngredientModelInSintesi],textIniziale:() -> Text) -> Text {
        
         // 1. Atomizziamo la descrizione del Piatto come un array delle singole parole, in forma Text.
         let (atomicDescription,emptyDescription) = atomizzaDescrizionePiatto(ing: ing)
        
         let initialText = textIniziale()
         
         let testoElaborato:Text = atomicDescription.reduce(initialText) { partialResult, word in
             
         return partialResult
             +
             Text(" ")
             +
             word
                 
         }
         
         return testoElaborato
                    .italic(!emptyDescription)
                    .font(.caption)
                    .foregroundColor(emptyDescription ? .seaTurtle_2 : .seaTurtle_4)
        
    }
    
    private func atomizzaDescrizionePiatto(ing:[IngredientModelInSintesi]) -> (texts:[Text],isEmpty:Bool) {
        // 1. Creaiamo un dictionary String:Text per gli ingredienti.
        let ingText = ing.reduce(into: [:]) { partialResult, ing in
            partialResult[ing.intestazione.lowercased()] = textMapIngMain(ing: ing)
        }
        let description = self.item.descrizione
        
        var atomicDescription:[Text] = []
        //2. Separiamo le parole della descrizione
        
        guard !description.isEmpty else {
            
            let emptyText:Text = Text("(nessuna)")
            return ([emptyText],true)
        }
        
        let descrArray:[String] = description.components(separatedBy: " ")
        
        for word in descrArray {
            
            if let isMentioned = ingText[word.lowercased()] {
                
                atomicDescription.append(isMentioned.fontWeight(.black))
                
            } else {
                let text = Text(word)
                atomicDescription.append(text)
            }
        }
        
        return (atomicDescription,false)
        
    }
    
    
  
    
}




struct DishModelRow_ClientVersion_Previews: PreviewProvider {
        
    static var viewModel:FoodieViewModel = testAccount
    
    static var previews: some View {
      
        CSZStackVB(title: "Menu", backgroundColorView: .seaTurtle_1) {
            
            VStack {
                
                ScrollView {
                    
                    
                    ForEach(viewModel.allMyDish) { dish in
                        
                        DishModelRow_ClientVersion(item:dish,backgroundView: .seaTurtle_1)
                        

                    }
                    
                }
                
            }
            
            
        }
        .environmentObject(viewModel)

    }
}

var testAccount: FoodieViewModel = {

    var vm = FoodieViewModel()
     vm.allMyMenu = [menuSample_Test,menuSample2_Test,menuSample3_Test,menuDelGiorno_Test,menuDelloChef_Test]
     vm.allMyDish = [dishItem2_Test,dishItem3_Test,dishItem4_Test,dishItem5_Test,prodottoFinito]
     vm.allMyIngredients = [ingredientSample_Test,ingredientSample2_Test,ingredientSample3_Test,ingredientSample4_Test,ingredientSample5_Test,ingredientSample6_Test,ingredientSample7_Test,ingredientSample8_Test,ingredienteFinito,ingredientSample9_Test]
   /* vm.inventarioScorte.ingInEsaurimento = [/*ingredientSample5_Test.id,*/ingredientSample6_Test.id,ingredientSample7_Test.id,ingredientSample8_Test.id]
    vm.inventarioScorte.ingEsauriti = [/*ingredientSample_Test.id,*/ingredientSample2_Test.id,ingredientSample3_Test.id,ingredientSample4_Test.id]
    vm.inventarioScorte.cronologiaAcquisti = [
        ingredientSample_Test.id:[otherDateString3,otherDateString1,otherDateString,oldDateString,todayString],ingredientSample5_Test.id:[oldDateString,todayString]
    
    ]
    vm.inventarioScorte.archivioIngInEsaurimento = [todayString:[ingredientSample5_Test.id]]
    vm.allMyReviews = [rate1,rate2,rate3,rate4,rate5,rate6,rate7,rate8,rate9,rate10,rate11,rate12]*/
    
    vm.allMyCategories = [cat1,cat2,cat3,cat4,cat5,cat6,cat7]
    
   /* vm.remoteStorage.modelRif_deleted = [ingredientSample_Test.id:ingredientSample_Test.intestazione]
    vm.remoteStorage.modelRif_newOne = [menuSample_Test.id,dishItem3_Test.id]
    vm.remoteStorage.modelRif_modified = [menuSample2_Test.id,dishItem3_Test.id] */
    
     return vm
 }()


/// Sfondo della Row del Piatto nella versione Client. Derivata dalla CSZStack Framed, prevede di andare a tutto schermo ( in larghezza ) sui telefoni mentre sugli ipad si ferma a 650
 struct CSZStackVB_OpenFrame<Content:View>:View {
        
        let frameWidth: CGFloat
        @ViewBuilder var content: Content

        private let backgroundOpacity: Double = 0.03
        private let shadowColor:Color = Color.black
        private let rowColor:Color = Color.white
   
    init(frameWidth: CGFloat = 650, content: () -> Content) {
       
        let screenWidth: CGFloat = UIScreen.main.bounds.width
       
        self.frameWidth = .minimum(frameWidth, screenWidth)
        self.content = content()
    }
    
       var body: some View {
            
            ZStack(alignment:.leading) {
                
                RoundedRectangle(cornerRadius: 1.0)
                    .fill(rowColor.gradient.opacity(backgroundOpacity))
                   // .shadow(color:shadowColor,radius: 1.0)
                    .zIndex(0)
                
                content
                    .zIndex(1)
       
            }
            .frame(width:frameWidth)
        }
    } // da spostare



