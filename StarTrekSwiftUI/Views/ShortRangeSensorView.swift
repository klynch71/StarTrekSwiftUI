//
//  ShortRangeSensorView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/16/25.
//

import SwiftUI

/*
 A view that displays the sectors of a quadrant in a Grid with gridlines as well as numerical column and row header labels
 */
struct ShortRangeSensorView: View {
    @EnvironmentObject var model: AppState
    //add 1 to sector columns for the row label
    let columns = Array(repeating: GridItem(.flexible()), count: Location.SECTOR_COLS + 1)
    let colLabels = [" "] + Array(1...Location.SECTOR_COLS).map {String($0)}
    let rowLabels = Array(1...Location.SECTOR_ROWS).map {String($0)}
    let indices = Array(0..<Quadrant.SECTORS_PER_QUADRENT)
    
    var body: some View {
        GeometryReader { geo in
            //fit the window
            let cellWidth = geo.size.width / CGFloat(columns.count)
            let cellHeight = geo.size.height /
                (CGFloat(rowLabels.count) + 1)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    //column headers
                    ForEach(colLabels, id:\.self) {label in
                        Text(label)
                            .foregroundColor(Color.white)
                    }.padding()
                    
                    //sector contents
                    ForEach (indices, id:\.self) {index in
                        if (index % Location.SECTOR_COLS == 0) {
                            //row label
                            Text(rowLabels[index / Location.SECTOR_COLS]).foregroundColor(Color.white)
                        }
                        //sector contents
                        let imageName = getImageName(getSector(index))
                        Image(imageName)
                            .resizable()
                                .scaledToFit()
                                .frame(width: cellWidth, height: cellHeight)
                                .border(Color.gray, width: 1)

                    }
                }
            }.background(Color.black)
        }
    }
    
    /*
     return the sectors of the quadrant where the
     Enterprise currently is
     */
    func sectors() -> Array<Sector> {
        return model.enterprise.location.quadrant!.sectors
    }
    
    /*
     return the sector of the quadrant for the
     current index
     */
    func getSector(_ index: Int) -> Sector {
        let quadrant = model.enterprise.location.quadrant!
        return quadrant.sectors[index]
    }
    
    /*
     return an image for the Sector
     */
    func getImageName(_ sector: Sector) -> String {
        if model.enterprise.location.sector == sector {
            return model.enterprise.name
        } else if let object = model.galaxyObjects.first (where: {$0.location.sector == sector}) {
            return object.name;
        }
        return "EmptySpace";
    }
}

#Preview {
    ShortRangeSensorView()
        .environmentObject(AppState())
}
