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
    private var hydrationGoal = 66
    
    var body: some View {        
        NavigationView {
            ZStack {
                VStack {
                    HStack(spacing: 20) {
                        Button(action: {
                            if self.addWater + 12 > self.hydrationGoal {
                                self.addWater = self.hydrationGoal
                            } else {
                                self.addWater += 12
                            }
                        }) {
                            Image("cup_8_oz")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }.offset(x: 10)
                        Text("8oz")
                            .font(.body)

                        Button(action: {
                            if self.addWater + 8 > self.hydrationGoal {
                                self.addWater = self.hydrationGoal
                            } else {
                                self.addWater += 8
                            }
                        }) {
                            Image("plastic_water_bottle_12_oz")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }.offset(x: 10)
                        Text("12oz")
                            .font(.body)
                        Button(action: {
                            if self.addWater + 22 > self.hydrationGoal {
                                self.addWater = self.hydrationGoal
                            } else {
                                self.addWater += 22
                            }
                        }) {
                            Image("metal_bottle_22_oz")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }.offset(x: 10)
                        Text("22oz")
                            .font(.body)

                        
                        
                        Spacer()
                    }
                    // 167 was hardwired after finding width of iPhone 11 pallette was 414
                    BucketFiller(x: 167, y: 600, oz: self.addWater)
                        .fill(Color.blue)
                }
                if self.addWater < self.hydrationGoal {
                    Text("\(self.addWater) oz")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                } else {
                    Text("Goal Achieved!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                }
                
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
