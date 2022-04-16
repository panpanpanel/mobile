//
//  InsightsView.swift
//  pannelIQ
//
//  Created by Jack MacKinnon on 2022-03-11.
//

import SwiftUI

struct InsightsView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 17) {
            HStack(alignment: .top, spacing: 100) {
                Text("Analytics")
                .fontWeight(.bold)
                .font(.title3)
                .lineSpacing(24)

                Image("cog")
                .frame(width: 24, height: 24)
            }
            .padding(.leading, 139)
            .padding(.trailing, 16)
            .padding(.bottom)
            .padding(.top)
            .frame(maxWidth: .infinity)

            HStack(alignment: .top, spacing: 0) {
                    Text("GRAPH")
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(width: 156, alignment: .center)
                    .lineSpacing(14)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 9)
                    .frame(width: 172, height: 32)
                    .background(Color("pannelPurple"))
                    .cornerRadius(6)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(red: 0.20, green: 0.25, blue: 0.29), lineWidth: 0.50))

                    Text("TABLE")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 156)
                    .lineSpacing(100)
                    .padding(.horizontal, 8)
                    .frame(width: 172, height: 32)
                    .cornerRadius(6)
                    .frame(width: 172, height: 32)
            }
            .cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(red: 0.20, green: 0.25, blue: 0.29), lineWidth: 0.50))

            VStack(alignment: .leading, spacing: 15) {
                    Text("Overview")
                    .fontWeight(.bold)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .lineSpacing(20)
                    .padding(.horizontal, 16)

                    HStack(alignment: .top, spacing: 45) {
                                VStack(spacing: 6) {
                                                Text("TOTAL KWH")
                                                .fontWeight(.heavy)
                                                .font(.caption)
                                                .tracking(0.12)
                                                .lineSpacing(12)

                                                Text("206")
                                                .fontWeight(.bold)
                                                .font(.title3)
                                                .frame(width: 50, alignment: .topLeading)
                                                .lineSpacing(24)
                                }
                                .frame(maxWidth: .infinity)

                                VStack(spacing: 6) {
                                                Text("COST")
                                                .fontWeight(.heavy)
                                                .font(.caption)
                                                .tracking(1)
                                                .lineSpacing(12)

                                                Text("$5.83")
                                                .fontWeight(.bold)
                                                .font(.title3)
                                                .frame(width: 70.13, alignment: .topLeading)
                                                .lineSpacing(24)
                                }
                                .frame(maxWidth: .infinity)

                                VStack(spacing: 8) {
                                                Text("CHANGE")
                                                .fontWeight(.heavy)
                                                .font(.caption)
                                                .tracking(1)
                                                .lineSpacing(12)

                                                Text("-$0.21")
                                                .fontWeight(.bold)
                                                .font(.title3)
                                                .lineSpacing(24)
                                                .foregroundColor(.green)
                                }
                                .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
            }

            HStack(alignment: .top, spacing: 3) {
                    Text("Timescale")
                    .fontWeight(.bold)
                    .font(.title3)
                    .frame(width: 170, alignment: .topLeading)
                    .lineSpacing(24)

                    Text("See more")
                    .fontWeight(.bold)
                    .font(.callout)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 170, alignment: .topTrailing)
                    .lineSpacing(24)
                    .foregroundColor(Color("pannelPurple"))
            }

            HStack(alignment: .top, spacing: 0) {
                    Text("DAY")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(width: 96, alignment: .top)
                    .lineSpacing(14)
                    .padding(.top, 8)
                    .padding(.bottom, 10)
                    .frame(width: 86, height: 32)
                    .cornerRadius(6)

                    Text("WEEK")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(width: 96, alignment: .top)
                    .lineSpacing(14)
                    .padding(.vertical, 9)
                    .frame(width: 86, height: 32)
                    .background(Color(red: 0.61, green: 0.32, blue: 0.88))
                    .cornerRadius(6)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(red: 0.20, green: 0.25, blue: 0.29), lineWidth: 0.50))
                    .frame(width: 86, height: 32)

                    Text("MONTH")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(width: 96, alignment: .top)
                    .lineSpacing(14)
                    .padding(.top, 8)
                    .padding(.bottom, 10)
                    .frame(width: 86, height: 32)
                    .cornerRadius(6)

                    Text("YEAR")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(width: 96, alignment: .top)
                    .lineSpacing(14)
                    .padding(.top, 8)
                    .padding(.bottom, 10)
                    .frame(width: 86, height: 32)
                    .cornerRadius(6)
            }
            .cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(red: 0.20, green: 0.25, blue: 0.29), lineWidth: 0.50))

            HStack(alignment: .bottom, spacing: 0) {
                    VStack(alignment: .leading, spacing: 6) {
                                Text("AVERAGE KWH")
                                .fontWeight(.heavy)
                                .font(.caption)
                                .frame(width: 120, alignment: .topLeading)
//                                .tracking(1)
                                .lineSpacing(12)

                                Text("29.4")
                                .fontWeight(.bold)
                                .font(.title3)
                                .frame(width: 60, alignment: .topLeading)
                                .lineSpacing(24)
                    }

                    Text("Nov 29 - Dec 5")
                    .font(.subheadline)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 217, alignment: .topTrailing)
                    .lineSpacing(15.96)
            }

            HStack(alignment: .bottom, spacing: 0) {
                Group {
                    RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.61, green: 0.32, blue: 0.88))
                    .frame(width: 8.21, height: 144.62)

                    RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.61, green: 0.32, blue: 0.88))
                    .frame(width: 8.21, height: 71.20)

                    RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.61, green: 0.32, blue: 0.88))
                    .frame(width: 8.21, height: 231.40)

                    RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.61, green: 0.32, blue: 0.88))
                    .frame(width: 8.21, height: 153.52)

                    RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.61, green: 0.32, blue: 0.88))
                    .frame(width: 8.21, height: 211.38)
                    
                    RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.61, green: 0.32, blue: 0.88))
                    .frame(width: 8.21, height: 267)

                    RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.61, green: 0.32, blue: 0.88))
                    .frame(width: 8.21, height: 71.20)
                }
                .padding(.leading, 21)
                .padding(.trailing, 21)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .padding(.trailing)

            HStack(alignment: .top, spacing: 0) {
                Group {
                    Text("M")
                    Text("T")
                    Text("W")
                    Text("Th")
                    Text("F")
                    Text("Sa")
                    Text("Su")
                }
                .font(.bold(.title3)())
                .padding(.leading)
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}
