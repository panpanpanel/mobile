//
//  ControlView.swift
//  pannelIQ
//
//  Created by Jack MacKinnon on 2022-03-11.
//

import SwiftUI

struct ControlView: View {
    
    @State private var acControl =         ControlKnob(img: "ac", isOn: false, sched: nil, breaker: 0)
    @State private var dryerControl =      ControlKnob(img: "dryer", isOn: true, sched: nil, breaker: 2)
    @State private var ovenControl =       ControlKnob(img: "oven", isOn: true, sched: nil, breaker: 4)
    @State private var dishwasherControl = ControlKnob(img: "dishwasher", isOn: false, sched: nil, breaker: 6)
    @State private var furnaceControl =    ControlKnob(img: "furnace", isOn: true, sched: nil, breaker: 1)
    @State private var fridgeControl =     ControlKnob(img: "fridge", isOn: true, sched: nil, breaker: 3)
    @State private var washerControl =     ControlKnob(img: "washer", isOn: true, sched: nil, breaker: 5)
    @State private var livingControl =     ControlKnob(img: "living-room", isOn: true, sched: nil, breaker: 7)
    
    var body: some View {
        VStack() {
            HStack(alignment: .bottom, spacing: 110) {
                    Text("Control")
                    .fontWeight(.bold)
                    .font(.title3)
                    .lineSpacing(24)

                    Image(systemName: "calendar")
                    .frame(width: 30, height: 30)
            }
            .padding(.leading, 150)
            .padding(.trailing, 10)
            .frame(maxWidth: .infinity, alignment: .center)

            HStack(alignment: .top, spacing: 48) {
                    VStack(spacing: 32) {
                        VStack(spacing: 0) {
                            Button {
                                acControl.flipBreaker()
                            } label: {
                                ZStack {
                                    Ellipse()
                                    .fill(Color(acControl.isActive() ? "pannelPurple" : "controlGrey"))
                                    .frame(width: 88, height: 88)
                                    
                                    acControl.getImage()
                                    .frame(width: 28.98, height: 30)
                                }
                                .opacity(acControl.isActive() ? 1.0 : 0.60)
                                .frame(width: 88, height: 88)
                            }
                            Text("A/C")
                            .fontWeight(.semibold)
                            .font(.callout)
                            .lineSpacing(24)
                            .opacity(acControl.isActive() ? 1.0 : 0.60)
                        }
                        .frame(height: 127)

                        VStack(spacing: 0) {
                            Button {
                                dryerControl.flipBreaker()
                            } label: {
                                ZStack {
                                    Ellipse()
                                    .fill(Color(dryerControl.isActive() ? "pannelPurple" : "controlGrey"))
                                    .frame(width: 88, height: 88)
                                    
                                    dryerControl.getImage()
                                    .frame(width: 28.98, height: 30)
                                }
                                .opacity(dryerControl.isActive() ? 1.0 : 0.60)
                                .frame(width: 88, height: 88)
                            }

                            VStack(spacing: 0) {
                                Text("Dryer")
                                .fontWeight(.semibold)
                                .font(.callout)
                                .lineSpacing(24)

                                Text("(6PM-12AM)")
                                .font(.caption2)
                                .lineSpacing(15)
                            }
                            .opacity(dryerControl.isActive() ? 1.0 : 0.60)
                        }

                        VStack(spacing: 0) {
                            Button {
                                ovenControl.flipBreaker()
                            } label: {
                                ZStack {
                                    Ellipse()
                                    .fill(Color(ovenControl.isActive() ? "pannelPurple" : "controlGrey"))
                                    .frame(width: 88, height: 88)
                                    
                                    ovenControl.getImage()
                                    .frame(width: 28.98, height: 30)
                                }
                                .opacity(ovenControl.isActive() ? 1.0 : 0.60)
                                .frame(width: 88, height: 88)
                            }

                            VStack(spacing: 0) {
                                Text("Oven")
                                .fontWeight(.semibold)
                                .font(.callout)
                                .lineSpacing(24)

                                Text("(7AM-9PM)")
                                .font(.caption2)
                                .lineSpacing(15)
                            }
                            .opacity(ovenControl.isActive() ? 1.0 : 0.60)
                        }

                        VStack(spacing: 0) {
                            Button {
                                dishwasherControl.flipBreaker()
                            } label: {
                                ZStack {
                                    Ellipse()
                                    .fill(Color(dishwasherControl.isActive() ? "pannelPurple" : "controlGrey"))
                                    .frame(width: 88, height: 88)
                                    
                                    dishwasherControl.getImage()
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 48, maxHeight: 48)
                                    .frame(width: 48, height: 48)
                                }
                                .opacity(dishwasherControl.isActive() ? 1.0 : 0.60)
                                .frame(width: 88, height: 88)
                            }

                            VStack(spacing: 0) {
                                Text("Dishwasher")
                                .fontWeight(.semibold)
                                .font(.callout)
                                .lineSpacing(24)

                                Text("(9PM-12AM)")
                                .font(.caption2)
                                .lineSpacing(15)
                            }
                            .opacity(dishwasherControl.isActive() ? 1.0 : 0.60)
                        }
                    }

                VStack(spacing: 32) {
                    VStack(spacing: 0) {
                        Button {
                            furnaceControl.flipBreaker()
                        } label: {
                            ZStack {
                                Ellipse()
                                .fill(Color(furnaceControl.isActive() ? "pannelPurple" : "controlGrey"))
                                .frame(width: 88, height: 88)
                                
                                furnaceControl.getImage()
                                .frame(width: 28.98, height: 30)
                            }
                            .opacity(furnaceControl.isActive() ? 1.0 : 0.60)
                            .frame(width: 88, height: 88)
                        }

                        Text("Furnace")
                        .fontWeight(.semibold)
                        .font(.callout)
                        .lineSpacing(24)
                        .opacity(furnaceControl.isActive() ? 1.0 : 0.60)
                    }
                    .frame(height: 127)

                    VStack(alignment: .leading, spacing: 0) {
                        Button {
                            fridgeControl.flipBreaker()
                        } label: {
                            ZStack {
                                Ellipse()
                                .fill(Color(fridgeControl.isActive() ? "pannelPurple" : "controlGrey"))
                                .frame(width: 88, height: 88)
                                
                                fridgeControl.getImage()
                                .frame(width: 28.98, height: 30)
                            }
                            .opacity(fridgeControl.isActive() ? 1.0 : 0.60)
                            .frame(width: 88, height: 88)
                        }

                        Text("Refrigerator")
                        .fontWeight(.semibold)
                        .font(.callout)
                        .lineSpacing(24)
                        .opacity(fridgeControl.isActive() ? 1.0 : 0.60)
                    }
                    .frame(height: 127)

                    VStack(spacing: 0) {
                        Button {
                            washerControl.flipBreaker()
                        } label: {
                            ZStack {
                                Ellipse()
                                .fill(Color(washerControl.isActive() ? "pannelPurple" : "controlGrey"))
                                .frame(width: 88, height: 88)
                                
                                washerControl.getImage()
                                .frame(width: 28.98, height: 30)
                            }
                            .opacity(washerControl.isActive() ? 1.0 : 0.60)
                            .frame(width: 88, height: 88)
                        }

                        VStack(spacing: 0) {
                            Text("Washing Machine")
                            .fontWeight(.semibold)
                            .font(.callout)
                            .lineSpacing(24)

                            Text("(6PM-12AM)")
                            .font(.caption2)
                            .lineSpacing(15)
                        }
                        .opacity(washerControl.isActive() ? 1.0 : 0.60)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Button {
                            livingControl.flipBreaker()
                        } label: {
                            ZStack {
                                Ellipse()
                                    .fill(Color(livingControl.isActive() ? "pannelPurple" : "controlGrey"))
                                .frame(width: 88, height: 88)
                                
                                livingControl.getImage()
                                .frame(width: 28.98, height: 30)
                            }
                            .opacity(livingControl.isActive() ? 1.0 : 0.60)
                            .frame(width: 88, height: 88)
                        }

                        VStack(spacing: 0) {
                            Text("Living Room")
                            .fontWeight(.semibold)
                            .font(.callout)
                            .lineSpacing(24)

                            Text("(6AM-11PM)")
                            .font(.caption2)
                            .lineSpacing(15)
                        }
                        .opacity(livingControl.isActive() ? 1.0 : 0.60)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct ControlKnob {
    private let img: Image
    private var isFlipped: Bool
    private var sched: [Date]?
    private let breaker: Int
    
    init(img: String, isOn: Bool, sched: [Date]?, breaker: Int) {
        self.img = Image(img)
        self.isFlipped = isOn
        self.sched = sched
        self.breaker = breaker
    }
    
    func getImage() -> Image {
        return self.img
    }
    
    func isActive() -> Bool {
        return self.isFlipped
    }
    
    mutating func flipBreaker() {
        isFlipped = isFlipped ? false : true
        
        let AWSMessage = "{\"device_id\": \"0\", \"breaker\": \(self.breaker)}"
        publishMessage(message: AWSMessage, topic: "control/basic")
    }
    
//    func updateSchedule() {
//        let curTime = Date()
//    }
}

extension ControlKnob {
//    init?(json: [String: Any]) {
//        guard let device_id = json["device_id"] as? String,
//              let breaker = json["breaker"] as? Int
//        else {
//            return nil
//        }
//        device_id = "0"
//        self.breaker = breaker
//    }
}


struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView()
    }
}
