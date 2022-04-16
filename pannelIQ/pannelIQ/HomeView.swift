//
//  HomeView.swift
//  pannelIQ
//
//  Created by Jack MacKinnon on 2022-03-11.
//

import SwiftUI
import AWSCore
import AWSIoT
import AWSDynamoDB

struct HomeView: View {
    
    @Binding var selectedTab: MainView.TabItems
    @EnvironmentObject var energyMeasurements: EnergyMeasurements
    
    @State var time: String = getPrettyTime(date: Date())
    
    var liveTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var chartTimer = Timer.publish(every: 150, on: .main, in: .common).autoconnect()
    
    @State var costPerEnergy: Double = 17.6 //awsData.getCostPerEnergy()
    @State var costPerHour: Double = 0.0 //= awsData.getCostPerHour()
    @State var currentEnergyUse: Double = 0.0 //= awsData.getEnergyUse()
    
    @State var chartXAxis = getChartXAxis(date: Date())
    
    @State var hourlyEnergyUse: Double = 0.00 //= awsData.getHourlyEnergyUse()
    @State var hourlyCost: Double = 0.0 //= awsData.getAverageHourlyCost()
    @State var hourlyRate: Double = 0.0 //= awsData.getAverageHourlyRate()
    
    private func setCostPerEnergy() {
        self.costPerEnergy = 17.6
    }
    
    private func setCostPerEnergyHour() {
        self.hourlyRate = 17.6
    }
    
    private func getCostPerHour() {
        let curEnergy = energyMeasurements.data[0].totalEnergy //kW
        self.costPerHour = round(100.0*curEnergy*17.6) / 100.0
//        print("getCostPerHour updated \(self.costPerHour) because curEnergy = \(curEnergy)")
    }
    
    private func getCurrentEnergyUse() {
        let curPower = energyMeasurements.data[0].totalEnergy
        self.currentEnergyUse = round(1000.0*curPower)
//        print("getCurrentEnergy updated \(self.currentEnergyUse)")
    }
    
    private func getHourlyEnergyUse(dateEnd: Date) {
        let hourlyEnergy = energyMeasurements.getTotalWH(dateEnd: dateEnd)*1000
        self.hourlyEnergyUse = round(100.0*hourlyEnergy)/100.0
//        print("getHourlyEnergy updated \(self.hourlyEnergyUse)")
    }
    
    private func getHourlyCost() {
        self.hourlyCost = round(100.0*self.hourlyEnergyUse*costPerHour/1000.0)
//        print("getHourlyCost updated \(self.hourlyCost)")
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack(alignment: .bottom, spacing: 110) {
                Image("profile_icon")
                Image("panneliQ")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            Button {
                selectedTab = MainView.TabItems.insights
//                sendTestIoTCoreEvent()
            } label: {
                ZStack {
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Current Usage")
                                .fontWeight(.semibold)
                                .font(.title2)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(20)
                    
                                HStack(spacing: 8) {
                                    Text(String(currentEnergyUse)  + "W")
                                    .fontWeight(.semibold)
                                    .font(.title)
//                                    .alignmentGuide(.leading) {d in d[.leading]}
//                                    .frame(width: 100)

                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(String(costPerHour) + "¢/hour")
                                        .font(.caption)

                                        Text(String(costPerEnergy) + "¢/kWh")
                                        .font(.caption)
                                    }
                                }
//                                .border(.black)
//                                .frame(width: 300, alignment: .center)
                            }
                            .frame(width: 194, height: 58)

                            HStack(spacing: 4) {
                                Text("Online")
                                .fontWeight(.bold)
                                .font(.subheadline)
                                .foregroundColor(.green)

                                Text(time)
                                .italic()
                                .font(.caption)
                                .frame(width: 150)
                                .onReceive(liveTimer) { input in
                                    self.time = getPrettyTime(date: input)
                                    if energyMeasurements.newData {
                                        setCostPerEnergy()
                                        setCostPerEnergyHour()
                                        getCostPerHour()
                                        getCurrentEnergyUse()
                                        getHourlyEnergyUse(dateEnd: input)
                                        getHourlyCost()
                                    }
                                }
                            }
                        }
                        .foregroundColor(Color.white)

                        VStack(alignment: .trailing, spacing: 7) {
                            VStack(alignment: .trailing, spacing: 7) {
                                Text("Top Consumers")
                                .underline()
                                .fontWeight(.light)
                                .font(.subheadline)
                                .lineLimit(.none)
                                
                                VStack(alignment: .trailing, spacing: 0) {
                                    Group {
                                        Text("Furnace")
                                        Text("Oven")
                                        Text("Refigerator")
                                    }
                                    .font(.italic(.subheadline)())
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .frame(width: 116, height: 79)

                            HStack(alignment: .top, spacing: 0) {
                                    Text("More Details")
                                    .italic()
                                    .font(.caption)
                                    Text(">")
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(.black)
                    }
                    .offset(x: 2, y: 7.50)
                }
                .frame(width: 374, height: 134)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.61, green: 0.32, blue: 0.88), Color(red: 0.23, green: 0.22, blue: 0.73)]), startPoint: .trailing, endPoint: .leading))
                .cornerRadius(20)
                .frame(width: 374, height: 134)
                .frame(width: 374, height: 134)
            }
            .accessibilityIgnoresInvertColors()

            Spacer()
            
            HStack(alignment: .bottom, spacing: 0.50) {
                VStack(alignment: .trailing, spacing: 22.0) {
                    Text("kW")
                    .fontWeight(.heavy)
                    .font(.caption)
                    .tracking(0.12)
                    .lineSpacing(12)

                    VStack(alignment: .trailing, spacing: 25) {
                        Group {
                            Text("1.0")
                            Spacer()
                            Text("0.5")
                            Spacer()
                            Text("0")
                        }
                        .font(.callout)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 30, height: 14.15, alignment: .trailing)
                    }
                }
                .frame(width: 32, height: 292, alignment: .leading)
                .padding(8)

                VStack(alignment: .center, spacing: 0.5) {
                    
                    if energyMeasurements.hasLoaded {
                        LivePowerView()
                            .environmentObject(energyMeasurements)
                            .task {
                                getCostPerHour()
                                getCurrentEnergyUse()
                                getHourlyEnergyUse(dateEnd: Date.now)
                                getHourlyCost()
                            }
                    } else {
                        Spacer()
                    }
                    
                    HStack(alignment: .center, spacing: 7) {
                        Group{
                            ForEach(chartXAxis, id: \.self) { date in
                                Text("\(date)")
                            }
                            .onReceive(liveTimer) { input in
                                self.chartXAxis = getChartXAxis(date: input)
                            }
                        }
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center).rotationEffect(.degrees(32))
                    }
                    .frame(alignment: .bottom)
                    .padding(.trailing, 32)
                }
            }
            .frame(width: 380, height: 292, alignment: .leading)

            Spacer()
            
            VStack(spacing: 15) {
                Text("Hourly Stats")
                .fontWeight(.bold)
                .font(.title3)
                .frame(width: 336, alignment: .topLeading)
                .lineSpacing(20)

                HStack(spacing: 42) {
                    VStack(spacing: 6) {
                        Text("TOTAL (WH)")
                        .fontWeight(.heavy)
                        .font(.caption)
                        .tracking(0.12)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .lineSpacing(12)

                        Text(String(hourlyEnergyUse))
                        .fontWeight(.bold)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .lineSpacing(24)
                    }

                    VStack(spacing: 6) {
                        Text("COST (¢)")
                        .fontWeight(.heavy)
                        .font(.caption)
                        .tracking(1)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .lineSpacing(12)

                        Text(String(hourlyCost))
                        .fontWeight(.bold)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .lineSpacing(24)
                    }

                    VStack(spacing: 6) {
                        Text("RATE (¢/kWh)")
                        .fontWeight(.heavy)
                        .font(.caption)
                        .tracking(1)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .lineSpacing(12)

                        Text(String(hourlyRate))
                        .fontWeight(.bold)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .lineSpacing(24)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            Spacer()
        }
    }
}

func sendTestIoTCoreEvent() {
    let AWSMessage =
    "{ \"device_id\": \"0\", \"is_door_latched\": 1, \"breaker_4_current\": 5.5, \"breaker_5_current\": 6.5, \"device_id\": 0, \"breaker_1_current\": 2.5, \"breaker_2_current\": 3.5, \"breaker_7_current\": 8.5, \"breaker_3_current\": 4.5, \"breaker_6_current\": 7.5, \"voltage\": 120, \"breaker_0_current\": 0}"
    publishMessage(message: AWSMessage, topic: "measure/basic")
}

func getPrettyTime(date: Date) -> String {
    let formatter = DateFormatter()

    formatter.timeStyle = .short
    formatter.dateStyle = .long

    return formatter.string(from: date)
}

func getChartXAxis(date: Date) -> [String] {
    var currentDateTime = date.addingTimeInterval(150)
    let modDate = currentDateTime.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 300)
    let roundedTime = currentDateTime - modDate

    let formatter = DateFormatter()
    var xAxis:[String] = []

    formatter.timeStyle = .short

    for i in 1...6 {
        let timeDifference = roundedTime.addingTimeInterval(TimeInterval(-10*i*60))
        xAxis.append(formatter.string(from: timeDifference))
    }
    
    return xAxis.reversed()
}

struct LineView: View {
  var dataPoints: [Double]

  var highestPoint: Double {
    let max = dataPoints.max() ?? 1.0
    if max == 0 { return 1.0 }
    return max
  }

  var body: some View {
    GeometryReader { geometry in
      let height = geometry.size.height
      let width = geometry.size.width

      Path { path in
        path.move(to: CGPoint(x: 0, y: height * self.ratio(for: 0)))

        for index in 1..<dataPoints.count {
          path.addLine(to: CGPoint(
            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
            y: height * self.ratio(for: index)))
        }
      }
      .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
    }
    .padding(.vertical)
  }

  private func ratio(for index: Int) -> Double {
    dataPoints[index] / highestPoint
  }
}

struct LineChartCircleView: View {
  var dataPoints: [Double]
  var radius: CGFloat

  var highestPoint: Double {
    let max = dataPoints.max() ?? 1.0
    if max == 0 { return 1.0 }
    return max
  }

  var body: some View {
    GeometryReader { geometry in
      let height = geometry.size.height
      let width = geometry.size.width

      Path { path in
        path.move(to: CGPoint(x: 0, y: (height * self.ratio(for: 0)) - radius))

        path.addArc(center: CGPoint(x: 0, y: height * self.ratio(for: 0)),
                    radius: radius, startAngle: .zero,
                    endAngle: .degrees(360.0), clockwise: false)

        for index in 1..<dataPoints.count {
          path.move(to: CGPoint(
            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
            y: height * dataPoints[index] / highestPoint))

          path.addArc(center: CGPoint(
            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
            y: height * self.ratio(for: index)),
                      radius: radius, startAngle: .zero,
                      endAngle: .degrees(360.0), clockwise: false)
        }
      }
      .stroke(Color.accentColor, lineWidth: 2)
    }
    .padding(.vertical)
  }

  private func ratio(for index: Int) -> Double {
//      print("dataPoints: \(dataPoints)\nIndex: \(index)")
      return dataPoints.indices.contains(index) ? (dataPoints[index] / highestPoint) : 0.0
  }
}

struct LineChartView: View {
    var dataPoints: [Double]
    var lineColor: Color = Color("pannelPurple")
    var outerCircleColor: Color = Color("pannelPurple")
    var innerCircleColor: Color = .white

    var body: some View {
        ZStack {
          LineView(dataPoints: dataPoints)
            .accentColor(lineColor)

          LineChartCircleView(dataPoints: dataPoints, radius: 3.0)
            .accentColor(outerCircleColor)

          LineChartCircleView(dataPoints: dataPoints, radius: 1.0)
            .accentColor(innerCircleColor)
        }
    }
}

struct LivePowerView: View {
    
    @EnvironmentObject var energyMeasurements: EnergyMeasurements
    @State var dataPoints: [Double] = [0.0, 0.1]
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        LineChartView(dataPoints: dataPoints)
          .frame(height: 200)
          .padding(4)
          .padding(.trailing)
          .onReceive(timer) { input in
              if(energyMeasurements.newData) {
                  loadData(dateEnd: input)
              }
          }
          .task {
              let dateEnd = Date.now
              let dateStart = Calendar.current.date(byAdding: .hour, value: -1, to: dateEnd)!
              self.dataPoints = self.energyMeasurements.getEnergyData(beginningTime: dateStart, endTime: dateEnd, binType: .minute, binSize: 5)
              if(self.dataPoints.isEmpty) {
                  self.dataPoints = [0.0, 0.1]
              }
          }
    }
    
    private func loadData(dateEnd: Date) {
        let dateStart = Calendar.current.date(byAdding: .hour, value: -1, to: dateEnd)!
        self.dataPoints = self.energyMeasurements.getEnergyData(beginningTime: dateStart, endTime: dateEnd, binType: .minute, binSize: 5)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(selectedTab: MainView.TabItems.home)
//    }
//}
