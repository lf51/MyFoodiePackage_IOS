//
//  SwiftUIView.swift
//  
//
//  Created by Calogero Friscia on 28/12/22.
//

import SwiftUI
import MyPackView_L0
import CoreLocation

public struct ProductModelRow_ClientVersion: View {
    
   // @EnvironmentObject var viewModel:FoodieViewModel
    @ObservedObject var viewModel:FoodieViewModel
    
    let item: ProductModel
    // @Binding var carrelloOrdini:[String] // rif dei piatti
    let rowColor:Color
    let rowOpacity:CGFloat
    let rowBoundReduction:CGFloat
    
    @State private var openInfo:Bool
    @State private var openPrices:Bool
    
    let selectorAction:() -> Void
    let reviewButton:() -> Void
   // let selectionCheck:() -> Bool
   // @State private var isPriceActionActive:Bool = false
    private let isSelected:Bool
    private let isItemIbrido:Bool
    
    let moneyCode = Locale.current.currency?.identifier ?? "EUR"
    
    public init(
        viewModel:FoodieViewModel,
        item: ProductModel,
        rowColor: Color,
        rowOpacity:CGFloat = 0.0,
        rowBoundReduction:CGFloat = 20,
        vistaEspansa:Bool = false,
        isSelectedActionCheck:() -> Bool = {false},
        selectorAction:@escaping () -> Void = {},
        reviewButton:@escaping () -> Void) {
        
        self.isItemIbrido = {
           // item.ingredientiPrincipali.contains(item.id)
            item.adress != .preparazione
        }()
            
        self.viewModel = viewModel
        self.item = item
        self.rowColor = rowColor
        self.rowOpacity = rowOpacity
        self.rowBoundReduction = rowBoundReduction
            
        _openInfo = State(wrappedValue: vistaEspansa)
        _openPrices = State(wrappedValue: vistaEspansa)
       
        self.isSelected = isSelectedActionCheck()
        self.selectorAction = selectorAction
        self.reviewButton = reviewButton
    }
    
    public var body: some View {
        
     //CSZStackVB_OpenFrame {
      
        CSZStackVB_Framed(
            backgroundOpacity: rowOpacity,
            shadowColor: Color.black,
            rowColor: rowColor,
            cornerRadius: 1.0,
            riduzioneMainBounds: rowBoundReduction) {
     
        ZStack(alignment:.bottomTrailing) {
            
           VStack(alignment: .leading,spacing: 8) {
 
               HStack(alignment:.lastTextBaseline) {
                        
                    vbIntestastione()
                    Spacer()
                    vbPriceSpace()
                      
                    }
 
                  vbSecondLine()
                   .padding(.top,-5)
               
                  vbBadgeRow()
                
                ZStack(alignment:.topLeading) {
                    
                  VStack(alignment:.leading,spacing: 5) {
                        
                        vbPrincipalIngredientRow()
                        
                        if let dietAvaible = csPreShowDiet() {
                            vbShowDiet(dietAvaible: dietAvaible)
                        }
                        
                        if self.openInfo {
                            
                            vbDishHistory()
                        }
                    }
                    
                    Button {
                        withAnimation {
                            self.openInfo.toggle()
                        }
                    } label: {
                        
                        let sign = self.openInfo ? "up" : "down"
                        
                        Image(systemName: "chevron.\(sign).circle.fill")
                        //.imageScale(.medium)
                            .foregroundColor(self.openInfo ? Color.seaTurtle_4 : Color.seaTurtle_3)
                            .shadow(color: .seaTurtle_1, radius: 5)
                    }
                    
                    
                }
                
                if self.openPrices,
                   self.item.pricingPiatto.count > 1 { vbShowPrices() }
                
                VStack(alignment:.leading,spacing:0) {
                    
                    vbAllergeniLine()
                    vbConservazioneLine()
                    
                    }
 
                } // Close VStack
           
                    vbSelector()
                    .disabled(selectorAction() == {}())
            
            } // close ZStack Interno
           // .padding(.horizontal,10)
            .padding(.vertical,5)
        }
    }
    
    // ViewBuilder - Method
    
    @ViewBuilder private func vbSelector() -> some View {
        
        let value:(image:String,opacity:CGFloat) = {
            
            if self.isSelected {return ("😋",1.0) }
            else { return ("🤔",0.4)}
            
        }()
        
        Button {
            self.selectorAction()
        } label: {
            Text(value.image)
                .shadow(color: .seaTurtle_1, radius: 5)
                .opacity(value.opacity)
               
        }
    }
    
    private func csPreShowDiet() -> [TipoDieta]? {
        // Utilizziamo un preCalcolo perchè rimaneva un piccolo spazietto quando non c'erano valori da mostrare. Così invece è risolto.
        let dietAvaible = self.item.returnDietAvaible(viewModel: self.viewModel).inDishTipologia
        
       /* if dietAvaible.count == 1 &&
           dietAvaible.contains(.standard) { return nil }
        else { return dietAvaible }*/
        
        if dietAvaible.isEmpty { return nil }
        else { return dietAvaible }
        
    }
    
    @ViewBuilder private func vbShowDiet(dietAvaible:[TipoDieta]) -> some View {
        
        HStack(spacing: 10.0) {
            
            ForEach(dietAvaible,id:\.self) { diet in
                
                let value = csDietImage(diet: diet)
                
                if let image = value.imageOrEmojy,
                   let color = value.color,
                   let daElidere = value.daElidere {
                    
                    image
                        .foregroundColor(.black.opacity(0.7))
                        .frame(width: 30, height: 30)
                        .background {
                            Color.seaTurtle_3.opacity(0.2)
                        }
                        .clipShape(Circle())
                        .overlay {
                            if daElidere {
                                Image(systemName: "line.diagonal")
                                    .foregroundColor(color)
                                    .fontWeight(.light)
                                
                            }
                        }
                }
                
            }
        }
        
    }
    
    private func csDietImage(diet:TipoDieta) -> (imageOrEmojy:Text?,color:Color?,daElidere:Bool?) {
        
        switch diet {
            
        case .vegetariano:
            return (Text(Image(systemName: "pawprint.fill")),.white,true)
        case .zeroLatticini:
            return (Text("🥛"),.black,true)
        case .glutenFree:
            return (Text(Image(systemName: "laurel.leading")),.black,true)
            
        default: return (nil,nil,nil)
        }
        
        
    }
    
    @ViewBuilder private func vbShowPrices() -> some View {
        
        let items:[GridItem] = [
            GridItem(.flexible(), spacing: 5, alignment: .leading),
            GridItem(.flexible(), spacing: 5, alignment: .leading),
            GridItem(.flexible(), spacing: 5, alignment: .leading)
        ]
        
        LazyVGrid(columns: items,alignment: .center, spacing: 5) {
            
            ForEach(self.item.pricingPiatto.sorted(
                by: {csOrdinaPriceFormat(lhs: $0, rhs: $1)}),id:\.self) { formato in
                    
                    let doubleValue = csConvertToDouble(from: formato.price)
                    
                  //  Button {
                      // self.priceAction(formato.price)
                  //  } label: {
                        
                        VStack {
                            
                            Text(formato.label)
                                .foregroundColor(.seaTurtle_4)
                            
                            Text(doubleValue,format: .currency(code: self.moneyCode))
                             .foregroundColor(.seaTurtle_2)
                          /*  HStack(alignment:.top,spacing:1) {
                                
                                Text("\(doubleValue,format: .currency(code: self.moneyCode))")
                                // .font(.title2)
                                    .foregroundColor(.seaTurtle_2)
                                
                                Text(self.openPrices ? "-" : "+")
                                    .fontWeight(.bold)
                                    .font(.caption2)
                                    .foregroundColor(.seaTurtle_3)
                            } */
                        }
                        .font(.headline)
                        .lineLimit(1)
                        .frame(maxWidth:.infinity)
                        .background {
                            Color.seaTurtle_1
                                .cornerRadius(5.0)
                                .opacity(0.6)
                        }
                        .shadow(color: .black, radius: 0.5)
                  //  }
                    
                }
            
        }
        
    }
    
    private func csConvertToDouble(from value:String) -> Double {
        
        Double(value) ?? 0.0
    }
    
    private func csOrdinaPriceFormat(lhs:DishFormat,rhs:DishFormat) -> Bool {
        
        lhs.type.orderAndStorageValue() < rhs.type.orderAndStorageValue() ||
        csConvertToDouble(from: lhs.price) > csConvertToDouble(from: rhs.price)
        
    }
    
    @ViewBuilder private func vbAllergeniLine() -> some View {
        
        let allergeni = self.item.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
        
        let textAllergeni = allergeni.map({creaTextAllergene(allergene: $0)})
        let isEmpty = allergeni.isEmpty
        
        if !isEmpty {
            
            HStack(alignment:.firstTextBaseline,spacing: 0) {
                
                Text("*")
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                
                combinaTesto(
                    textList: textAllergeni,
                    coloreSeparatore: .black,
                    fontFinale: .caption2) {
                        
                        Text("Contiene:")
                            .fontWeight(.heavy)
                            .fontWidth(.condensed)
                    }
                
                
            }
            
        }
        
    }
    
    private func creaTextAllergene(allergene:AllergeniIngrediente) -> Text {
        
        Text(allergene.intestazione)
            .italic()
            .fontWeight(.semibold)
        //.font(.caption2)
            .foregroundColor(Color.black.opacity(0.8))
        
    }
    
    @ViewBuilder private func vbConservazioneLine() -> some View {
        
        let isThereSurgelati = self.item.hasSomeIngredientASpecificQuality(viewModel: self.viewModel, kpQuality: \.values.conservazione, quality: .surgelato)
        let isThereCongelati = self.item.hasSomeIngredientASpecificQuality(viewModel: self.viewModel, kpQuality: \.values.conservazione, quality: .congelato)
        
        // Se l'ingrediente viene salvato di defult come Altro, allora invece di cercarle singolarmente possiamo ricercare per esclusione
        
        let valueSintesi = isThereCongelati || isThereSurgelati
        
        if valueSintesi {
            
            HStack(alignment:.firstTextBaseline,spacing:0) {
                
                Text("*")
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.6))
                
                Text("Può contenere ingredienti congelati e/o surgelati")
                    .italic()
                    .font(.caption2)
                    .fontWeight(.light)
                    .foregroundColor(Color.black)
                
            }
        }
        
    }
    
    @ViewBuilder private func vbDishHistory() -> some View {
        
        // 1. Prendiamo gli ingredienti secondari e li trasformiamo nella Sintesi
        let allFilteredIngredients = self.item.allIngredientsIn(viewModel: self.viewModel)
        let allSintesys:[IngredientModelInSintesi] = allFilteredIngredients.map({self.sintetizzaIngredienteTitolare(ingredient: $0)})
        let allSintesysSecondary:[IngredientModelInSintesi] = allSintesys.filter({!$0.isPrincipal})
        
        let nomePercorso = self.item.adress.simpleDescription()
        // 2. Controlliamo se la descrizione del piatto li contiene tutti
        
        let mapByName:[String] = allSintesysSecondary.map({$0.intestazione})
        
        let areAllMentioned:Bool = {
            
            guard !mapByName.isEmpty else { return false }
            guard let description = self.item.descrizione?.lowercased() else {
                return false }
            
           // description.lowercased()
           // let description = self.item.descrizione.lowercased()
            
            for ing in mapByName {
                
                let lowIng = ing.lowercased()
                
                if description.contains(lowIng) { continue }
                else { return false }
            }
            return true
        }()
        
        self.combinaIngredienti(
            ing: allSintesysSecondary,
            areAllMentioned: areAllMentioned,
            fontFinale: .footnote) {
                
                Text("Altri ingredienti usati nella preparazione:")
                //.font(.footnote)
                    .fontWeight(.semibold)
                    .fontWidth(.condensed)
                    .foregroundColor(Color.black)
                
            }//.multilineTextAlignment(.leading)
        
        self.descriptionWithIngMentions(
            ing: allSintesysSecondary,
            fontFinale: .footnote) {
                
                Text("Racconto del \(nomePercorso):")
                // .font(.footnote)
                    .fontWeight(.semibold)
                    .fontWidth(.condensed)
                    .foregroundColor(Color.black)
                
            }//.multilineTextAlignment(.leading)
    }
    
    @ViewBuilder private func vbIntestastione() -> some View {
        
        Text(self.item.intestazione)
            .font(.title2)
            .fontWeight(.semibold)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .allowsTightening(true)
            .foregroundColor(.seaTurtle_4)
        
    }
    
    @ViewBuilder private func vbSecondLine() -> some View {
        
        if !isItemIbrido { vbReviewLine() }
        else {
            
            Text(self.item.adress.simpleDescription().lowercased())
                .italic()
                .fontWeight(.light)
                .font(.subheadline)
                .foregroundColor(.seaTurtle_2)
                .padding(.top,-5)
        }
        
    }
    
    @ViewBuilder private func vbReviewLine() -> some View {
        
      /*  let (mediaRating,ratingCount,_) = self.item.ratingInfo(readOnlyViewModel: self.viewModel) */
        // Upgrade 07.02.23
        let dishRevRif = self.viewModel.reviewFilteredByDish(idPiatto: self.item.id).rif
        let (ratingCount,_,mediaRating,_) = self.viewModel.monitorRecensioni(rifReview: dishRevRif)
    
        let zeroCount = ratingCount == 0
        
        HStack(alignment: .lastTextBaseline, spacing:5) {
            
            Text("\(mediaRating,specifier: "%.1f")") // media
                .fontWeight(.semibold)
                .font(.title2)
                .foregroundColor(.seaTurtle_1)
                .padding(.horizontal,5)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.seaTurtle_4)
                        .shadow(color: .seaTurtle_1, radius:3)
                )
            
          /*  Image(systemName: "arrow.up.right")
                 .imageScale(.medium)
                 .fontWeight(.semibold)
                 .foregroundColor(.seaTurtle_3)
                 .opacity(zeroCount ? 0.2 : 1.0) */
            
         /*   Text("\(ratingCount) recensioni") // valore da importare
                    .italic()
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.seaTurtle_2) */
 
            Button {
                withAnimation {
                    self.reviewButton()
                }
            } label: {
                
            
                HStack(spacing:5) {
                    
                    Text("\(ratingCount) recensioni")
                                .italic()
                                .font(.headline)
                                //.fontWeight(.semibold)
                                .foregroundColor(.seaTurtle_2)

                    Image(systemName: "arrow.up.right")
                            .imageScale(.medium)
                            //.fontWeight(.semibold)
                            .foregroundColor(.seaTurtle_3)
                            .opacity(zeroCount ? 0.2 : 1.0)
                }
                .fontWeight(.semibold)
                .foregroundColor(.seaTurtle_3)
                
                
            }.disabled(zeroCount)
            
         
        }
        
   

    }
    
    @ViewBuilder private func vbPriceSpace() -> some View {
        
        let (price,count) = csIterateDishPricing()
        let priceDouble = csConvertToDouble(from: price)//Double(price) ?? 0

      //  let (value,action) = labelPriceMultiAction(count: count,price: price)
        let countZero = count == "0"
        let label:String = {
            
            if countZero { return ""}
            else {
                let lab = self.openPrices ? "-" : "+"
                return "\(lab)\(count)"
            }
        }()
        
        Button {
            withAnimation {

                self.openPrices.toggle()
            }
        } label: {
            
            HStack(alignment:.top,spacing:1) {
                
                Text("\(priceDouble,format: .currency(code: self.moneyCode))")
                    .font(.title2)
                    .foregroundColor(.seaTurtle_4)
                
                Text(label)
                    .fontWeight(.bold)
                    .font(.caption2)
                    .foregroundColor(.seaTurtle_3)
            }
            .padding(.horizontal,10)
            .background {
                Color.seaTurtle_1.cornerRadius(5.0)
                   // .brightness(self.isPriceSelectionActive ? 0.3 : 0.0)
            }
            .shadow(color: .seaTurtle_1, radius: 0.5)
            
        }.disabled(countZero)
        
    }
    
    
   /* private func labelPriceMultiAction(count:String,price:String) -> (label:String,action:()->Void){
        
        let countZero = count == "0"
        let condition_4 = self.isPriceSelectionActive && !self.openPrices
        
        func action() {
           // self.isPriceActionActive = self.priceAction(price)
            self.priceAction(price)
        }
        func multiAction() {
           // if condition_4 { self.isPriceActionActive = self.priceAction(price) }
            if condition_4 { self.priceAction(price) }
            else { self.openPrices.toggle() }
        }

            if countZero {
                let label = self.isPriceSelectionActive ? "-" : "+"
                return (label,action)}
            
            else {
                
                let label:String = {
                   
                    if condition_4 { return "-" }
                    else {
                        let lab = self.openPrices ? "-" : "+"
                        return "\(lab)\(count)"
                    }
                    
                }()

                return ("\(label)",multiAction) }

    } */
    
    
    
   /* @ViewBuilder private func vbPriceSpace() -> some View {
           
        let (price,count) = csIterateDishPricing()
        let priceDouble = csConvertToDouble(from: price)//Double(price) ?? 0
        let countZero = count == "0"
        
        
        
        let countValue:String = {
            
            if countZero {
                
                let label = self.isPriceActionActive ? "-" : "+"
                return label }
            
            else if self.openPrices { return "-"}
            else { return "+\(count)"}
            
        }()
        
        Button {
            withAnimation {
                
                if countZero {
                    self.isPriceActionActive = self.priceAction()
                } else {
                    self.openPrices.toggle()
                }
                
               
            }
        } label: {
            
            HStack(alignment:.top,spacing:1) {
          
                Text("\(priceDouble,format: .currency(code: self.moneyCode))")
                    .font(.title2)
                    .foregroundColor(.seaTurtle_4)
                
                Text(countValue)
                    .fontWeight(.bold)
                    .font(.caption2)
                    .foregroundColor(.seaTurtle_3)
            }
            .padding(.horizontal,10)
            .background {
                Color.seaTurtle_1.cornerRadius(5.0)
            }
        }//.disabled(countZero)

    }*/ // backup 09.01
    
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
    
   /* private func csReduceDishPricesInDictionary() -> [String:String] {
        
        let extended:[String:String] = self.item.pricingPiatto.reduce(into: [:]) { partialResult, format in
            partialResult[format.label] = format.price
        }
        return extended
        
    } */ // Deprecata 06.01.23
    
    @ViewBuilder private func vbBadgeRow() -> some View {
        
        let areAllBio = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.values.produzione, quality: .biologico)
        let areAllLocal = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.values.provenienza, quality: .km0)
        let areAllItalian = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.values.provenienza, quality: .italia)
    
        let isDelGiorno = self.viewModel.checkMenuDiSistemaContainDish(idPiatto: self.item.id, menuDiSistema: .delGiorno)
        let isAdviceByTheChef = self.viewModel.checkMenuDiSistemaContainDish(idPiatto: self.item.id, menuDiSistema: .delloChef)

        HStack(spacing:3) {
                    
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
   
                    if areAllItalian {
                            
                        CSEtichetta(
                            text: "🇮🇹",
                            fontStyle: .subheadline,
                            textColor: Color.white,
                            image: "💯",
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: .seaTurtle_4.opacity(0.8),
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
  
                    if isDelGiorno {
                        
                        CSEtichetta(
                            text: "del Giorno",
                            textColor: Color.white,
                            image: "fork.knife.circle.fill",
                            imageColor: .seaTurtle_4,
                            imageSize: .medium,
                            backgroundColor: .seaTurtle_2,
                            backgroundOpacity: 0.5)
                    }

                    if isAdviceByTheChef {
                        
                        CSEtichetta(
                            text: "dello Chef",
                            textColor: Color.white,
                            image: "👨🏻‍🍳", //"🗣️", // person.wave.2
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: .gray,
                            backgroundOpacity: 0.7)
                    }
                    
                }
    }
        
    /// Crea un array di Ingredienti in Sintesi, filtra i principali, e ritorna una view che li descrive
    /// - Returns: Text
    @ViewBuilder private func vbPrincipalIngredientRow() -> some View {
 
        let allFilteredIngredients = self.item.allIngredientsIn(viewModel: self.viewModel)
        let allSintesys:[IngredientModelInSintesi] = allFilteredIngredients.map({self.sintetizzaIngredienteTitolare(ingredient: $0)})
        let allSintesysPrincipal:[IngredientModelInSintesi] = allSintesys.filter({$0.isPrincipal})
      
        combinaIngredienti(
            ing: allSintesysPrincipal,
            fontFinale: .callout) { //.subheadline
            Text(
                 Image(
                     systemName:"circle"/*"list.bullet.rectangle"*/)
                 )
            .foregroundColor(Color.clear)
            //.font(.subheadline)
           // .foregroundColor(.seaTurtle_2)
                // Un segnaposto che viene sovrapposto da un bottone che qui non possiamo inserire
           
        }
       // .lineSpacing(-2)
           // .multilineTextAlignment(.leading)
            
                
    }
    
    /// Mappa un array di Ingredienti in Sintesi in un array di Text
    /// - Parameter ing: ingredienti in sintesi
    /// - Parameter areAllMentioned: Solo per i secondari. Indicare se gli ingredienti sono tutti menzionati nel testo della descrizione
    /// - Parameter textIniziale: Il testo di incipit. Può anche essere un Text contenente una immagine
    /// - Returns: Text
    private func combinaIngredienti(ing:[IngredientModelInSintesi],areAllMentioned:Bool = false,fontFinale:Font,textIniziale:() -> Text) -> some View {
        
        let texts:[Text] = {
         
            if ing.isEmpty {
                
                let emptyText = Text("(nessuno)")
                   // .italic()
                    .font(fontFinale)
                    .foregroundColor(.seaTurtle_2)
                
                return [emptyText]
            }
            else if areAllMentioned {
                
                let emptyText = Text("(in grassetto nel testo)")
                 //   .italic()
                    .font(fontFinale)
                    .foregroundColor(.seaTurtle_2)
                
                return [emptyText]
                
            }
            else {
               return ing.map{textMapIngMain(ing: $0)}
            }
            
        }()
        
        return combinaTesto(
            textList: texts,
            fontFinale: fontFinale,
            textIniziale: textIniziale)
        
    }
    
    /// Combina un array di Text (stilizzati diversamente)in un unico Text
    /// - Parameter textList: [Text]
    /// - Returns: Text
    private func combinaTesto(textList:[Text],coloreSeparatore:Color = .white,fontFinale:Font,textIniziale:() -> Text) -> Text {

        let initialText:Text = textIniziale()
    
        let testoComposto:Text = textList.reduce(initialText) { partialResult, text in
 
                 partialResult
                 +
                 Text(partialResult == initialText ? " " : ", ")
                    .foregroundColor(coloreSeparatore)
                 +
                 text
            }
        
        return testoComposto
                .font(fontFinale)
        
    }
    
    /// Crea un ingrediente in sintesi dal sostituto (qualora esista) dell'ingrediente titolare
    /// - Parameter ing: ingrediente Titolare
    /// - Returns: Text combinato del titolare + il sostituto
    private func textMapIngMain(ing:IngredientModelInSintesi) -> Text {
        
        var sintesiSostituto:IngredientModelInSintesi? = nil
        
        if let idSostituto = ing.idSostituto,
           ing.isTemporaryOff {
            
            if let modelSostituto = self.viewModel.modelFromId(id: idSostituto, modelPath: \.db.allMyIngredients),
               modelSostituto.statusTransition == .disponibile {
                
              //  let hasAllergene = !modelSostituto.allergeni.isEmpty
                let hasAllergene:Bool = {
                    if let allergeneIn = modelSostituto.values.allergeni {
                        return !allergeneIn.isEmpty
                    } else { return false }
                }()
                let isItBio = modelSostituto.values.produzione == .biologico
                let isFreeze = modelSostituto.values.conservazione == .congelato || modelSostituto.values.conservazione == .surgelato

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
            
       /*let font:(intestazione:Font,isBio:Font.TextStyle) = {
                
            if ing.isPrincipal { return (Font.subheadline,.caption2) }
            else { return (Font.caption,.caption2) }
        
        }() */
        
      return
        Text(isASubstitute ? " (" : "")
            .bold()
            .foregroundColor(.seaTurtle_3)
        +
        Text(ing.intestazione)
           // .font(font.intestazione)
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
           // .font(.system(font.isBio ,design: .monospaced, weight: .semibold))
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
        
        let allTemporaryOff = self.item.offManager?.elencoIngredientiOff ?? [:]
        let ingredientiPrincipali = self.item.ingredientiPrincipali ?? []
        
        let isPrincipal = ingredientiPrincipali.contains(ingredient.id)
      //  let hasAllergene = !ingredient.allergeni.isEmpty
        let hasAllergene:Bool = {
            if let allergeneIn = ingredient.values.allergeni {
                return !allergeneIn.isEmpty
            } else { return false }
        }()
        let isItBio = ingredient.values.produzione == .biologico
        let isFreeze = ingredient.values.conservazione == .congelato || ingredient.values.conservazione == .surgelato
   
        var isOff: Bool = false
        
        if self.item.offManager?.idIngredienteDaSostituire == ingredient.id {isOff = true}
        else { isOff = ingredient.statusTransition == .inPausa}

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
    
    private func descriptionWithIngMentions(ing:[IngredientModelInSintesi],fontFinale:Font,textIniziale:() -> Text) -> Text {
        
         // 1. Atomizziamo la descrizione del Piatto come un array delle singole parole, in forma Text.
         let (atomicDescription,emptyDescription) = atomizzaDescrizionePiatto(ing: ing)
        
         let initialText = textIniziale()
         
         let testoElaborato:Text = atomicDescription.reduce(initialText) { partialResult, word in
             
             partialResult
             +
             Text(" ")
             +
             word
                 
         }
         
         return testoElaborato
                    .italic(!emptyDescription)
                    .font(fontFinale)
                    .foregroundColor(emptyDescription ? .seaTurtle_2 : .seaTurtle_4)
        
    }
    
    private func atomizzaDescrizionePiatto(ing:[IngredientModelInSintesi]) -> (texts:[Text],isEmpty:Bool) {
        // check description
        guard let description = self.item.descrizione,
                 !description.isEmpty else {
            
            let emptyText:Text = Text("(nessuno)")
            return ([emptyText],true)
        }
        
        // 1. Creaiamo un dictionary String:Text per gli ingredienti.
        let ingText = ing.reduce(into: [:]) { partialResult, ing in
            partialResult[ing.intestazione.lowercased()] = textMapIngMain(ing: ing)
        }
       // let description = self.item.descrizione
        
        var atomicDescription:[Text] = []
        //2. Separiamo le parole della descrizione
        
       /* guard !description.isEmpty else {
            
            let emptyText:Text = Text("(nessuno)")
            return ([emptyText],true)
        } */
        
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

/*struct ProductModelRow_ClientVersion_Previews: PreviewProvider {
        
    @StateObject static var viewModel:FoodieViewModel = testAccount
    @State static var preSelection:[ProductModel] = []
    static var espanso:Bool = true
    
    static var previews: some View {
      
        CSZStackVB(title: "Menu", backgroundColorView: .seaTurtle_1) {
            
            VStack(alignment:.leading) {
                
                HStack {
                    Text("Selected:\(preSelection.count)")
                        .padding(.horizontal)
                    Image(systemName: "cart")
                        .onTapGesture {
                           // self.espanso.toggle()
                        }
                }
                
                ScrollView {
                    
                    
                    ForEach(viewModel.db.allMyDish) { dish in
                        
                        ProductModelRow_ClientVersion(
                            viewModel: viewModel,
                            item: dish,
                            rowColor:.seaTurtle_4,
                            vistaEspansa: espanso) {
                                preSelection.contains(dish)
                            } selectorAction: {
                                test(value: dish)
                            } reviewButton: {
                                //
                            }

                        
                       /* ProductModelRow_ClientVersion(viewModel: viewModel, item:dish,backgroundView: .seaTurtle_1) { price in
                            
                          test(value: dish)
                        } */
                        CSDivider(
                            visibleColor: .seaTurtle_3,
                            height: 0.4,
                            radius: 0)
                        .padding(.horizontal)

                    }
                    
                }
                CSDivider()
            }
           
            
        }
      //  .environmentObject(viewModel)

    }
    
    static func test(value:ProductModel)  {
        
        if preSelection.contains(value) {
            let index = preSelection.firstIndex(of: value)
            preSelection.remove(at: index!)
        } else {
            preSelection.append(value)
        }
      // return true
       // return preSelection.contains(value)
    }
    
}*/

/*let testCurrentProperty = PropertyCurrentData(
 //  userRole: UserRoleModel(),
   info: PropertyModel(intestazione: "", cityName: "", coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434), webSite: "", phoneNumber: "", streetAdress: "", numeroCivico: "", admin: UserCloudData(id: "test", email: "test@", userName: "@test", isPremium: false)),
   inventario: Inventario(),
   setup: AccountSetup()/*,
   db: CloudDataStore()*/)*/

/*var testAccount: FoodieViewModel = {

    var vm = FoodieViewModel(currentProperty: testCurrentProperty)//FoodieViewModel(userAuth: nil)
  /*  vm.allMyMenu = [menuSample_Test,menuSample2_Test,menuSample3_Test,menuDelGiorno_Test,menuDelloChef_Test]
     vm.allMyDish = [dishItem2_Test,dishItem3_Test,dishItem4_Test,dishItem5_Test,prodottoFinito]
     vm.allMyIngredients = [ingredientSample_Test,ingredientSample2_Test,ingredientSample3_Test,ingredientSample4_Test,ingredientSample5_Test,ingredientSample6_Test,ingredientSample7_Test,ingredientSample8_Test,ingredienteFinito,ingredientSample9_Test]
   /* vm.inventarioScorte.ingInEsaurimento = [/*ingredientSample5_Test.id,*/ingredientSample6_Test.id,ingredientSample7_Test.id,ingredientSample8_Test.id]
    vm.inventarioScorte.ingEsauriti = [/*ingredientSample_Test.id,*/ingredientSample2_Test.id,ingredientSample3_Test.id,ingredientSample4_Test.id]
    vm.inventarioScorte.cronologiaAcquisti = [
        ingredientSample_Test.id:[otherDateString3,otherDateString1,otherDateString,oldDateString,todayString],ingredientSample5_Test.id:[oldDateString,todayString]
    
    ]
    vm.inventarioScorte.archivioIngInEsaurimento = [todayString:[ingredientSample5_Test.id]]
    vm.allMyReviews = [rate1,rate2,rate3,rate4,rate5,rate6,rate7,rate8,rate9,rate10,rate11,rate12]*/
    vm.allMyReviews = [rate1,rate2,rate3,rate4,rate5,rate6,rate7,rate8,rate9,rate10,rate11,rate12]
    vm.allMyCategories = [cat1,cat2,cat3,cat4,cat5,cat6,cat7] */
    
   /* vm.remoteStorage.modelRif_deleted = [ingredientSample_Test.id:ingredientSample_Test.intestazione]
    vm.remoteStorage.modelRif_newOne = [menuSample_Test.id,dishItem3_Test.id]
    vm.remoteStorage.modelRif_modified = [menuSample2_Test.id,dishItem3_Test.id] */
    
     return vm
 }()*/


/// Sfondo della Row del Piatto nella versione Client. Derivata dalla CSZStack Framed, prevede di andare a tutto schermo ( in larghezza ) sui telefoni mentre sugli ipad si ferma a 650
/* struct CSZStackVB_OpenFrame<Content:View>:View {
        
        let frameWidth: CGFloat
        @ViewBuilder var content: Content

        private let backgroundOpacity: Double = 0.03
        private let rowColor:Color = Color.white
   
    init(frameWidth: CGFloat = 650, content: () -> Content) {
       
        let screenWidth: CGFloat = UIScreen.main.bounds.width
       
        self.frameWidth = .minimum(frameWidth, screenWidth)
        self.content = content()
    }
    
       var body: some View {
            
            ZStack(alignment:.leading) {
                
                RoundedRectangle(cornerRadius: 1.0)
                    .fill(rowColor.opacity(backgroundOpacity))
                    .zIndex(0)
                
                content
                    .zIndex(1)
       
            }
            .frame(width:frameWidth)
        }
    } */ //Deprecata 14.01 // da spostare



