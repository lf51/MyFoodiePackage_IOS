//
//  SwiftUIView 2.swift
//  
//
//  Created by Calogero Friscia on 08/02/23.
//

import SwiftUI
import MyPackView_L0

public struct DishRatingListView: View {
    
  //  @ObservedObject var viewModel:FoodieViewModel
    
    let dishTitle: String
    let backgroundColorView: Color
    
    private let dishRating: [DishRatingModel]
    
    private let ratingsCount: Int
    private let mediaRating: Double
    private let mediaL10: Double

    @State private var minMaxRange: (Double,Double) = (0.0,10.0)
    
    public init(dishItem:DishModel, backgroundColorView: Color, readOnlyViewModel:FoodieViewModel) {
        
      //  self.viewModel = readOnlyViewModel
        
        self.dishTitle = dishItem.intestazione
        self.backgroundColorView = backgroundColorView
        
        let(model,rif) = readOnlyViewModel.reviewFilteredByDish(idPiatto: dishItem.id)
        self.dishRating = model
        
        (self.ratingsCount,_,self.mediaRating,self.mediaL10) = readOnlyViewModel.monitorRecensioni(rifReview: rif)
        
        
    }
    
  //  @State var opac:CGFloat = 1.0
    @State private var frames:[CGRect]? = []
    
    public var body: some View {
       
        CSZStackVB(
            title: dishTitle,
            titlePosition: .bodyEmbed([.horizontal,.top],10),
            backgroundColorView: backgroundColorView) {
        
                VStack {
                                
                HStack(alignment:.top) {
                    
                    csSplitRatingByVote()
                        .font(.system(.subheadline, design: .rounded, weight: .light))
                    
                   Spacer()

                        vbRatingvote()
                        
                }
                .background {
                  //  Color.green
                }
           
             //   CSDivider()
                
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        
                        ForEach(dishRating,id:\.self) { rate in
                            // da ordinare seguendo la data
                            if rate.isVoteInRange(min: minMaxRange.0, max: minMaxRange.1) {
                                
                                DishRating_RowView(
                                    rating: rate,
                                    backgroundColorView: backgroundColorView,
                                    frames: $frames,
                                    coordinateSpace: "RatingList")
                                    
                                
                            }
                            
                        }
                        
                    }
                }
                .cornerRadius(10)
               // .csCornerRadius(10, corners: [.topLeft,.topRight])
                .coordinateSpace(name: "RatingList")
                .onPreferenceChange(FramePreference.self, perform: {
                                frames = $0.sorted(by: { $0.minY < $1.minY })
                            })
                
                CSDivider()
            } // chiusa Vstack Madre
           // .padding(.horizontal)
            .background {
               // Color.red
                
            }
            
                
        }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("+ Add")
                }
            }
            
    }
    
    // method
    
    @ViewBuilder private func vbRatingvote() -> some View {
  
        HStack(alignment:.top) {
                
                   Text("\(mediaRating,specifier: "%.1f")")
                        .fontWeight(.black)
                        .font(.largeTitle)
                        .foregroundColor(.seaTurtle_1)
                        .padding(5)
                        .background {
                            Color.seaTurtle_2.cornerRadius(5.0)
                        }
                
                VStack(spacing:-5) {
                    
                    HStack(spacing:0) {
                        Text("L10")
                            .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                            .foregroundColor(.seaTurtle_2)
                        
                        vbMediaL10(mediaGen: mediaRating, mediaL10: mediaL10)
                    }
                    
                    Text("\(mediaL10,specifier: "%.1f")")
                        .fontWeight(.heavy)
                        .font(.title)
                        .foregroundColor(.seaTurtle_4)
                    }
                    .padding(.horizontal,5)
                    .background {
                        Color.seaTurtle_1.cornerRadius(5.0)
                        
                    }
            }
        
        .background{
          //  Color.gray
            
        }

    }
    
    private func csSplitRatingByVote() -> some View {
        
        let fromZeroToSix = "da 0 a 5.99"
        let fromSixTo8 = "da 6 a 7.99"
       // let from8To9 = "da 8.1 a 9"
        let from9To10 = "da 8 a 10"
        
        var ratingContainer: [String:Int] = [fromZeroToSix:0,fromSixTo8:0,from9To10:0]
        let ratingRangeValue: [String:(Double,Double)] = [fromZeroToSix:(0.0,5.99),fromSixTo8:(6.0,7.99),from9To10:(8.0,10.0)]
        
        for rating in self.dishRating {
            
          //  guard let vote = Double(rating.voto) else { continue }
            let vote = rating.voto.generale
            
            if vote < 6.0 { ratingContainer[fromZeroToSix]! += 1 }
            else if vote < 8.0 { ratingContainer[fromSixTo8]! += 1 }
            else { ratingContainer[from9To10]! += 1 }
        }

        return Grid(alignment:.leading,verticalSpacing: 5) {
            
            ForEach(ratingContainer.sorted(by: <), id: \.key) { key, value in
                
                let isTheRangeActive = self.minMaxRange == ratingRangeValue[key]!
                
                GridRow {
                    
                    Text(key)
                       // .fontWidth(.condensed)
                        .foregroundColor(Color.black)
                    
                    Text("( \(value,format: .number.notation(.compactName)) )")
                        .fontWeight(.semibold)
                        .foregroundColor(.seaTurtle_4)
                    
                    Button {
                        withAnimation {
                            self.minMaxRange = isTheRangeActive ? (0.0,10.0) : ratingRangeValue[key]!
                        }
                    } label: {
                        Image(systemName: isTheRangeActive ? "eye" : "eye.slash")
                            .imageScale(.medium)
                            .foregroundColor(.seaTurtle_3)
                            .opacity(isTheRangeActive ? 1.0 : 0.6)
                    }
                    
                } // GridRow
                
            } // chiusa ForEach
        
            GridRow {
                
                Text("totale:")
                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                    .fontWidth(.compressed)
                    .gridCellColumns(1)
                Text("\(ratingsCount,format: .number.notation(.automatic))")
                    .fontWeight(.black)
                    .font(.subheadline)
                    .gridCellColumns(2)
            }
            
        } // Chiusa Grid

        
    }
    
   
    
}
