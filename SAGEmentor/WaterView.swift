//
//  WaterView.swift
//  SAGEmentor
//
//  Created by brad.hontz on 2/8/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import SwiftUI

// using a bucket size: bucket top width: 200, bottom width: 80, height: 480
// this implies a "slope" of 8; 8 pixels of height for every 1 pixel of width

struct BucketFiller: Shape {
    var x: Int
    var y: Int
    var oz: Int
    
    init(x: Int, y: Int, oz: Int) {
        self.x = x
        self.y = y
        self.oz = oz
    }
    
    func path(in rect: CGRect)-> Path {
        var path = Path()
        var xp = self.x
        var yp = self.y

        path.move(to: CGPoint(x: xp, y: yp))
        xp = xp - (1 * self.oz)
        yp = yp - (8 * self.oz)
        path.addLine(to: CGPoint(x: xp, y: yp))
        xp = xp + (80 + (2 * self.oz))
        path.addLine(to: CGPoint(x: xp, y: yp))
        xp = xp - (1 * self.oz)
        yp = yp + (8 * self.oz)
        path.addLine(to: CGPoint(x: xp, y: yp))
        
        return path
    }
}

struct WaterView: View {
    @State private var addWater = 1
    
    var body: some View {        
        NavigationView {
            VStack {
                HStack(spacing: 20) {
                    Button(action: {
                        self.addWater += 2
                    }) {
                        Image("greenbutton")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }.offset(x: 10)
                    Text("Drank some water")
                    Spacer()
                }
                // 167 was hardwired after finding width of iPhone 11 pallette was 414
                BucketFiller(x: 167, y: 480, oz: self.addWater)
                    .fill(Color.blue)
            }
        }
        .navigationBarTitle("Water")
    }
}

struct WaterView_Previews: PreviewProvider {
    static var previews: some View {
        WaterView()
    }
}
