//
//  File 2.swift
//  
//
//  Created by Calogero Friscia on 30/12/22.
//

import Foundation











let today = Date()
let todayString = csTimeFormatter().data.string(from: today)

let oldDate = Date().addingTimeInterval(-172800)
let oldDateString = csTimeFormatter().data.string(from: oldDate)
let otherDate = Date().addingTimeInterval(-259200)
let otherDateString = csTimeFormatter().data.string(from: otherDate)

let otherDate1 = Date().addingTimeInterval(-388800)
let otherDateString1 = csTimeFormatter().data.string(from: otherDate1)

let otherDate2 = Date().addingTimeInterval(-583200)
let otherDateString2 = csTimeFormatter().data.string(from: otherDate2)
let otherDateString3 = "\(otherDateString2)|Casa Dolce casa del sapore 56 kg a 26 € prezzo concordato con il titolare in data 11.09.2022"

/*var testAccount: AccounterVM = {

    var vm = AccounterVM()
     vm.allMyMenu = [menuSample_Test,menuSample2_Test,menuSample3_Test,menuDelGiorno_Test,menuDelloChef_Test]
     vm.allMyDish = [dishItem2_Test,dishItem3_Test,dishItem4_Test,dishItem5_Test,prodottoFinito]
     vm.allMyIngredients = [ingredientSample_Test,ingredientSample2_Test,ingredientSample3_Test,ingredientSample4_Test,ingredientSample5_Test,ingredientSample6_Test,ingredientSample7_Test,ingredientSample8_Test,ingredienteFinito]
    vm.inventarioScorte.ingInEsaurimento = [/*ingredientSample5_Test.id,*/ingredientSample6_Test.id,ingredientSample7_Test.id,ingredientSample8_Test.id]
    vm.inventarioScorte.ingEsauriti = [/*ingredientSample_Test.id,*/ingredientSample2_Test.id,ingredientSample3_Test.id,ingredientSample4_Test.id]
    vm.inventarioScorte.cronologiaAcquisti = [
        ingredientSample_Test.id:[otherDateString3,otherDateString1,otherDateString,oldDateString,todayString],ingredientSample5_Test.id:[oldDateString,todayString]
    
    ]
    vm.inventarioScorte.archivioIngInEsaurimento = [todayString:[ingredientSample5_Test.id]]
    vm.allMyReviews = [rate1,rate2,rate3,rate4,rate5,rate6,rate7,rate8,rate9,rate10,rate11,rate12]
    vm.allMyCategories = [cat1,cat2,cat3,cat4,cat5,cat6,cat7]
    
    vm.remoteStorage.modelRif_deleted = [ingredientSample_Test.id:ingredientSample_Test.intestazione]
    vm.remoteStorage.modelRif_newOne = [menuSample_Test.id,dishItem3_Test.id]
    vm.remoteStorage.modelRif_modified = [menuSample2_Test.id,dishItem3_Test.id]
    
     return vm
 }() */

 var property_Test:PropertyModel = {
  
    var prp = PropertyModel()
    prp.intestazione = "Osteria del Vicolo"
    prp.cityName = "Sciacca"
    prp.streetAdress = "vicolo San Martino"
    prp.numeroCivico = "22"
    prp.webSite = "https:\\osteriadelvicolo.it"
    prp.phoneNumber = "340 67 13 777"
    return prp
}()

var dishItem2_Test: DishModel = {
   
   var newDish = DishModel()
   newDish.intestazione = "Caserecce Gamberi e Zucca"
    newDish.descrizione = "Piatto classico della tradizione, leggero, con il nostro migliore olio d'oliva riscaldato senza toccare il punto di ebolizzione. Non perde nutrienti e discioglie lentamente i principi attivi dell' aglio senza bruciarlo ensamble ultima parola sata."
   newDish.status = .completo(.disponibile)
   newDish.ingredientiPrincipali = [ingredientSample2_Test.id,ingredientSample3_Test.id,ingredientSample4_Test.id,ingredientSample5_Test.id,ingredientSample6_Test.id]
   newDish.ingredientiSecondari = [ingredientSample7_Test.id,ingredientSample8_Test.id]
   newDish.categoriaMenu = "cat2"
   newDish.elencoIngredientiOff = [ingredientSample2_Test.id:ingredientSample_Test.id]
  // newDish.rifReviews = [rate8.id,rate9.id,rate10.id,rate11.id,rate12.id]
    
   let price:DishFormat = {
       var pr = DishFormat(type: .mandatory)
       pr.label = "Porzione"
       pr.price = "29.5"
       return pr
   }()
   let price1:DishFormat = {
       var pr = DishFormat(type: .opzionale)
       pr.label = "1/2 Porzione"
       pr.price = "14.5"
       return pr
   }()
   newDish.pricingPiatto = [price,price1]
   
    newDish.id = "lailo6" // per far funzionare il riferimento con le recensioni e avere un id corto
    
   return newDish
}()

 var dishItem3_Test: DishModel = {
    
    var newDish = DishModel()
    newDish.intestazione = "Bucatini alla Matriciana"
    newDish.status = .completo(.disponibile)
    newDish.ingredientiPrincipali = [ingredientSample4_Test.id]
    newDish.ingredientiSecondari = [] //[ingredientSample2_Test.id]
     newDish.rifReviews = [rate8.id,rate9.id,rate10.id,rate11.id,rate12.id]
     newDish.categoriaMenu = "cat2"
     
    let price:DishFormat = {
        var pr = DishFormat(type: .mandatory)
        pr.label = "Porzione"
        pr.price = "22.5"
        return pr
    }()
    let price1:DishFormat = {
        var pr = DishFormat(type: .opzionale)
        pr.label = "1/2 Porzione"
        pr.price = "10.5"
        return pr
    }()
    newDish.pricingPiatto = [price,price1]
    
     newDish.id = "lailo5" // per far funzionare il riferimento con le recensioni e avere un id corto
     
    return newDish
}()

var dishItem4_Test: DishModel = {
    
    var newDish = DishModel()
    newDish.intestazione = "Trofie al Pesto"
    newDish.status = .completo(.disponibile)
    newDish.ingredientiPrincipali = [ingredientSample_Test.id]
    newDish.ingredientiSecondari = [ingredientSample3_Test.id]
    newDish.rifReviews = [rate1.id,rate2.id,rate3.id,rate4.id,rate5.id,rate6.id,rate7.id]
    newDish.categoriaMenu = "cat2"
    let price:DishFormat = {
        var pr = DishFormat(type: .mandatory)
        pr.price = "22.5"
        return pr
    }()
    newDish.pricingPiatto = [price]
    
    newDish.id = "lailo4"
    
    return newDish
}()

var dishItem5_Test: DishModel = {
    
    var newDish = DishModel()
    newDish.intestazione = "Spaghetti Aglio Oglio e Peperoncino"
    newDish.descrizione = "Piatto classico della tradizione, leggero, con il nostro migliore olio d'oliva riscaldato senza toccare il punto di ebolizzione. Non perde nutrienti e discioglie lentamente i principi attivi dell'aglio senza bruciarlo. Per chiudere una spolverata di prezzemolo ok"
    newDish.status = .completo(.disponibile)
    newDish.ingredientiPrincipali = [ingredientSample7_Test.id]
    newDish.ingredientiSecondari = [ingredientSample9_Test.id]
    newDish.categoriaMenu = "cat2"
  //  newDish.rifReviews = [rate1.id,rate2.id,rate3.id,rate4.id,rate5.id,rate6.id,rate7.id]
    let price:DishFormat = {
        var pr = DishFormat(type: .mandatory)
        pr.price = "8.5"
        return pr
    }()
    newDish.pricingPiatto = [price]
    
    newDish.id = "lailo14"
    
    return newDish
}()
var prodottoFinito: DishModel = {
    
    var newDish = DishModel()
    newDish.intestazione = "CocoCola"
    newDish.status = .completo(.disponibile)
    newDish.ingredientiPrincipali = [newDish.id]
    newDish.percorsoProdotto = .prodottoFinito
    newDish.categoriaMenu = "cat7"
 
    let price:DishFormat = {
        var pr = DishFormat(type: .mandatory)
        pr.price = "22.5"
        return pr
    }()
    newDish.pricingPiatto = [price]
    
    return newDish
}()

var ingredienteFinito:IngredientModel = {
   
    var new = IngredientModel(id:prodottoFinito.id)
    new.intestazione = prodottoFinito.intestazione
    new.origine = .vegetale
    new.conservazione = .surgelato
    new.produzione = .biologico
    new.provenienza = .italia
    new.allergeni = [.latte_e_derivati]
    return new
}()

 var menuSample_Test: MenuModel = {

     var menu = MenuModel()
     menu.intestazione = "Pranzo Abbunnato della domenica di pasqua"
     menu.descrizione = "Pranzo tradizionale con portate dalla quantità sopra la media"
     menu.tipologia = .fisso(persone: .due, costo: "18")
    // menu.tipologia = .allaCarta
     menu.isAvaibleWhen = .intervalloAperto
     menu.dataInizio = Date.now
     menu.oraInizio = Date.now.advanced(by: 3600)
    
   //  menu.dishInDEPRECATO = [dishItem3]
     menu.rifDishIn = [dishItem3_Test.id,prodottoFinito.id]
     menu.status = .bozza(.disponibile)
     
     return menu
 }()
 
  var menuSample2_Test: MenuModel = {
    
     var menu = MenuModel()
     menu.intestazione = "Pranzo della Domenica"
      menu.descrizione = "Pranzo di gala per compleanno del Presidente. Sala riservata. 350 pax"
     menu.tipologia = .allaCarta()
   //  menu.tipologia = .allaCarta
     menu.isAvaibleWhen = .dataEsatta
      menu.dataInizio = Date.now.addingTimeInterval(259200)
   //  menu.giorniDelServizio = [.domenica]
     menu.rifDishIn = [dishItem3_Test.id,dishItem4_Test.id]
   //  menu.dishInDEPRECATO = [dishItem3]
     menu.status = .completo(.inPausa)
     
     return menu
 }()
 
 var menuSample3_Test: MenuModel = {
    
     var menu = MenuModel()
     menu.intestazione = "Pranzo della MezzaDi"
     menu.descrizione = "Pranzo di mezzogiorno con prodotti tipici della Campania, Puglia, Calabria e Sicilia."
     menu.tipologia = .fisso(persone: .uno, costo: "18.5")
   //  menu.tipologia = .allaCarta
     menu.isAvaibleWhen = .intervalloChiuso
     menu.giorniDelServizio = [.domenica,.martedi,.giovedi]
     menu.dataInizio = Date.now.addingTimeInterval(-259200)
     menu.oraInizio = Date.now.addingTimeInterval(-10800)
     menu.oraFine = Date.now.addingTimeInterval(10800)
     menu.rifDishIn = [dishItem3_Test.id]
    // menu.dishInDEPRECATO = [dishItem3]
     menu.status = .completo(.archiviato)
     
     return menu
 }()

var menuDelGiorno_Test:MenuModel = {
 
    //var mDD = MenuModel(tipologia: .allaCarta(.delGiorno))
    var mDD = MenuModel(tipologiaDiSistema: .delGiorno)
    mDD.rifDishIn = [dishItem4_Test.id,dishItem3_Test.id]
    return mDD
    
}()

var menuDelloChef_Test:MenuModel = {
 
   // var mDD = MenuModel(tipologia: .allaCarta(.delloChef))
    var mDD = MenuModel(tipologiaDiSistema: .delloChef)
    mDD.rifDishIn = [dishItem2_Test.id,dishItem5_Test.id]
    return mDD
    
}()

var ingredientSample_Test =  IngredientModel(
    intestazione: "Guanciale Nero",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .altro,
    produzione: .biologico,
    provenienza: .defaultValue,
    allergeni: [],
    origine: .animale,
    status: .completo(.disponibile)
)

var ingredientSample2_Test =  IngredientModel(
    intestazione: "Merluzzo",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .surgelato,
    produzione: .biologico,
    provenienza: .km0,
    allergeni: [.pesce],
    origine: .animale,
    status: .bozza(.archiviato)
        )

var ingredientSample3_Test =  IngredientModel(
    intestazione: "Basilico",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .altro,
    produzione: .biologico,
    provenienza: .restoDelMondo,
    allergeni: [.anidride_solforosa_e_solfiti,.arachidi_e_derivati,.crostacei,.fruttaAguscio,.lupini],
    origine: .vegetale,
    status: .bozza(.disponibile))

 var ingredientSample4_Test =  IngredientModel(
    intestazione: "Mozzarella di Bufala",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .congelato,
    produzione: .biologico,
    provenienza: .km0,
    allergeni: [.latte_e_derivati],
    origine: .animale,
    status: .bozza(.disponibile)
)

var ingredientSample5_Test =  IngredientModel(
    intestazione: "Mortadella",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .altro,
    produzione: .convenzionale,
    provenienza: .defaultValue,
    allergeni: [.glutine],
    origine: .vegetale,
    status: .completo(.disponibile)
)

var ingredientSample6_Test =  IngredientModel(
    intestazione: "Gambero Rosa",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .surgelato,
    produzione: .convenzionale,
    provenienza: .italia,
    allergeni: [.molluschi],
    origine: .animale,
    status: .bozza(.disponibile)
        )

var ingredientSample7_Test =  IngredientModel(
    intestazione: "Aglio",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .altro,
    produzione: .biologico,
    provenienza: .restoDelMondo,
    allergeni: [],
    origine: .vegetale,
    status: .bozza(.disponibile))

 var ingredientSample8_Test =  IngredientModel(
    intestazione: "Pecorino Romano DOP",
    descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
    conservazione: .altro,
    produzione: .convenzionale,
    provenienza: .europa,
    allergeni: [],
    origine: .vegetale,
    status: .bozza(.inPausa)
)

var ingredientSample9_Test =  IngredientModel(
   intestazione: "Prezzemolo",
   descrizione: "Prezzemolo di nostra produzione.",
   conservazione: .altro,
   produzione: .biologico,
   provenienza: .italia,
   allergeni: [],
   origine: .vegetale,
   status: .bozza(.disponibile)
)

var rate1 = DishRatingModel( voto: "8.0", titolo: "bello", commento: "casacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasa", idPiatto: "lailo4")
var rate2 = DishRatingModel(voto: "8.0", titolo: "bello", commento: "casacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasa", idPiatto: "lailo4")
var rate3 = DishRatingModel( voto: "8.0", titolo: "bello", commento: "casacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasacasa", idPiatto: "lailo4")

var rate4 = DishRatingModel(voto: "8.0", titolo: "Amazing", commento: "I saw the sea from the terrace and feel it in this amazing dish, with a true salty taste!! To eat again again again again for ever!!! I would like to be there again next summer hoping to find Marco and Graziella, two amazing host!! They provide us all kind of amenities, helping with baby food, gluten free, no Milk. No other place in Sicily gave to us such amazing help!!", idPiatto: "lailo4")

var rate5 = DishRatingModel(voto: "8.0", titolo: "Sapore di Niente", commento: "NoComment", idPiatto: "lailo4")
var rate6 = DishRatingModel(voto: "8.0",titolo: "", commento: "", idPiatto: "lailo4")
var rate7 = DishRatingModel(voto: "8.0", titolo: "", commento: "", idPiatto: "lailo4")



var rate8 = {
    
    var rate = DishRatingModel(voto: "10.0", titolo: "", commento: "", idPiatto: "lailo5")
    rate.dataRilascio = oldDate
    return rate
} ()

var rate9 = {
    
    var rate = DishRatingModel(voto: "10.0", titolo: "", commento: "", idPiatto: "lailo5")
    rate.dataRilascio = otherDate
    return rate
} ()

var rate10 = {
    
    var rate = DishRatingModel(voto: "8.0", titolo: "", commento: "", idPiatto: "lailo5")
    rate.dataRilascio = otherDate1
    return rate
} ()

var rate11 = {
    
    var rate = DishRatingModel(voto: "8.0", titolo: "", commento: "", idPiatto: "lailo5")
    rate.dataRilascio = otherDate2
    return rate
} ()

var rate12 = DishRatingModel(voto: "8.0", titolo: "", commento: "", idPiatto: "lailo5")

let rifDish3 = dishItem3_Test.id
let rifDish4 = dishItem4_Test.id


let cat1:CategoriaMenu = CategoriaMenu(
    id:"cat1",
    intestazione: "Antipasti",
    image: "🫒",
    descrizione: "")
let cat2:CategoriaMenu = CategoriaMenu(
    id:"cat2",
    intestazione: "Primi",
    image: "🍝",
    descrizione: "")
let cat3:CategoriaMenu = CategoriaMenu(
    id:"cat3",
    intestazione: "Secondi",
    image: "🍴",
    descrizione: "")
let cat4:CategoriaMenu = CategoriaMenu(
    id:"cat4",
    intestazione: "Contorni",
    image: "🥗",
    descrizione: "")
let cat5:CategoriaMenu = CategoriaMenu(
    id:"cat5",
    intestazione: "Frutta",
    image: "🍉",
    descrizione: "")
let cat6:CategoriaMenu = CategoriaMenu(
    id:"cat6",
    intestazione: "Dessert",
    image: "🍰",
    descrizione: "")
let cat7:CategoriaMenu = CategoriaMenu(
    id:"cat7",
    intestazione: "Bevande",
    image: "🍷",
    descrizione: "")

